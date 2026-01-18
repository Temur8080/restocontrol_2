# Hikvision DS-K1T Series Integration

Production-ready Node.js backend for Hikvision DS-K1T series terminals (DS-K1T343, DS-K1T341, etc.)

## Features

✅ **Real-time Event Streaming** - Listen to terminal events in real-time  
✅ **Historical Event Sync** - Synchronize past attendance records  
✅ **Duplicate Protection** - Uses `serialNo` to prevent duplicate entries  
✅ **Auto-reconnect** - Automatic reconnection on stream failures  
✅ **Polling Fallback** - Falls back to polling if streaming fails  
✅ **Multiple Terminals** - Support for multiple terminals  
✅ **PostgreSQL Storage** - Stores events in `attendance_logs` table  

## Architecture

```
hikvision-integration.js (Entry point)
    ↓
services/hikvision-manager.js (Orchestrator)
    ↓
services/attendance-sync.js (Storage & sync logic)
    ↓
services/hikvision-isapi.js (ISAPI communication)
```

## Installation

1. **Install dependencies:**
```bash
npm install digest-fetch pg
```

2. **Run database migration:**
```bash
node migrate-db.js
```

This creates the `attendance_logs` table with proper indexes.

## Configuration

Copy `config/hikvision-config.example.js` to `config/hikvision-config.js` and adjust:

```javascript
module.exports = {
  initialSyncDays: 7,              // Days to sync on startup
  enablePollingFallback: true,     // Enable polling if stream fails
  pollingInterval: 30000,          // 30 seconds
  incrementalSyncMinutes: 5,       // Minutes back for incremental sync
  enableRealTimeStream: true,      // Enable real-time streaming
  connectionTimeout: 30000,        // 30 seconds
  maxReconnectAttempts: 5,         // Max reconnect attempts
  reconnectDelay: 5000             // Initial reconnect delay
};
```

## Database Schema

### attendance_logs Table

```sql
CREATE TABLE attendance_logs (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id),
    employee_name VARCHAR(255) NOT NULL,
    terminal_name VARCHAR(100) NOT NULL,
    event_time TIMESTAMP WITH TIME ZONE NOT NULL,
    verification_mode VARCHAR(50),
    serial_no VARCHAR(255) NOT NULL,
    picture_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(serial_no, terminal_name)  -- Duplicate protection
);
```

## Usage

### Automatic Integration

The service auto-initializes when `server.js` starts:

```javascript
// server.js automatically requires hikvision-integration.js
// which initializes the Hikvision Manager
```

### Manual Usage

```javascript
const HikvisionManager = require('./services/hikvision-manager');
const { Pool } = require('pg');

const pool = new Pool({ /* your config */ });
const manager = new HikvisionManager(pool, {
  initialSyncDays: 7,
  enableRealTimeStream: true
});

await manager.initialize();
```

### API Endpoints

**Test Terminal Connection:**
```
POST /api/terminals/:id/test
```

**Sync Historical Events:**
```
POST /api/terminals/:id/sync
Query params: start_date, end_date (optional)
```

### Terminal Configuration

Terminals are stored in the `terminals` table:

```sql
INSERT INTO terminals (name, ip_address, username, password, terminal_type, is_active, admin_id)
VALUES ('Main Entrance', '192.168.1.10', 'admin', 'password123', 'entry', true, 1);
```

## Event Processing

### Event Filtering

Only events with `major=5` and `minor=75` are processed (attendance events).  
All other events (door open, system events, errors) are ignored.

### Employee Mapping

Events are matched to employees using:

1. **Primary:** `employee_faces` table mapping (`face_template_id` = `employeeNoString`)
2. **Fallback:** Uses `employeeNoString` as `employee_name` if no mapping exists

### Duplicate Detection

Events are deduplicated using `serial_no` + `terminal_name` (unique constraint).

## Real-time Streaming

The service listens to:
```
GET /ISAPI/Event/notification/alertStream
```

Features:
- Auto-reconnect on failures (HTTP 400/401/timeout)
- Automatic fallback to polling if stream fails
- Event parsing and filtering
- Error logging

## Historical Sync

Searches events using:
```
POST /ISAPI/AccessControl/AcsEvent?format=json
```

Payload:
```json
{
  "AcsEventCond": {
    "searchID": "sync_xxx",
    "searchResultPosition": 0,
    "maxResults": 100,
    "major": 5,
    "minor": 75,
    "StartTime": "2024-01-01T00:00:00",
    "EndTime": "2024-01-08T00:00:00"
  }
}
```

Supports pagination using `responseStatusStrg = "MORE"`.

## Error Handling

The service handles:
- **HTTP 400** - Invalid Content (logged, not fatal)
- **HTTP 401** - Authentication failed (reconnect with new credentials)
- **HTTP 404** - Endpoint not supported (logged, fallback to polling)
- **Network errors** - ECONNREFUSED, ETIMEDOUT, ECONNRESET (auto-reconnect)
- **Parse errors** - Malformed events are skipped (logged)

## Logging

The service provides detailed logging:
- ✅ Success events
- ⚠️ Warnings (duplicates, stream failures)
- ❌ Errors (connection, parsing, storage)
- 📡 Stream status
- 📊 Sync statistics

## Testing

Test terminal connection:
```javascript
const manager = require('./hikvision-integration');
const result = await manager.testTerminal(terminalId);
console.log(result);
```

Manual sync:
```javascript
const manager = require('./hikvision-integration');
const startDate = new Date('2024-01-01');
const endDate = new Date('2024-01-08');
const result = await manager.manualSync(terminalId, startDate, endDate);
console.log(`Saved: ${result.saved}, Duplicates: ${result.duplicates}`);
```

## Troubleshooting

### Stream not connecting
- Check terminal IP and credentials
- Verify terminal supports ISAPI streaming
- Check firewall/network connectivity
- Service will fallback to polling automatically

### Events not saving
- Check `attendance_logs` table exists
- Verify terminal is active (`is_active = true`)
- Check logs for specific errors
- Verify `serial_no` is unique (duplicates are silently skipped)

### High memory usage
- Adjust `eventBatchSize` in config
- Increase `processDelay` between batches
- Monitor PostgreSQL connection pool size

## Production Deployment

1. **Environment Variables:**
```bash
DB_USER=postgres
DB_HOST=localhost
DB_NAME=hodim_nazorati
DB_PASSWORD=your_password
DB_PORT=5432
```

2. **Run Migration:**
```bash
NODE_ENV=production node migrate-db.js
```

3. **Start Server:**
```bash
NODE_ENV=production node server.js
```

4. **Monitor Logs:**
- Watch for stream reconnection messages
- Monitor sync statistics
- Check for authentication errors

## License

This implementation uses only documented Hikvision ISAPI endpoints.  
No license-based features are assumed.


