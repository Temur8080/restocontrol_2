# Deployment Qo'llanmasi

Bu qo'llanma loyihani hostingga qo'yish uchun kerakli qadamlarni tushuntiradi.

## Talablar

- Node.js 14+ yoki 16+
- PostgreSQL 12+
- PM2 (production process manager uchun tavsiya etiladi)

## 1. Environment Variables Sozlash

`.env` faylini yarating va quyidagi ma'lumotlarni to'ldiring:

```env
# Database Configuration
DB_HOST=your_database_host
DB_PORT=5432
DB_NAME=hodim_nazorati
DB_USER=your_database_user
DB_PASSWORD=your_database_password

# Server Configuration
PORT=3000
NODE_ENV=production

# Security
SESSION_SECRET=your_random_secret_key_here
```

## 2. Database Sozlash

### 2.1. Database yaratish

```sql
CREATE DATABASE hodim_nazorati;
```

### 2.2. Schema yuklash

```bash
psql -U your_user -d hodim_nazorati -f schema.sql
```

### 2.3. Migration fayllarni yuklash

```bash
psql -U your_user -d hodim_nazorati -f migrations/create-attendance-logs.sql
psql -U your_user -d hodim_nazorati -f migrations/create-work-schedules.sql
psql -U your_user -d hodim_nazorati -f migrations/create-penalties-bonuses-kpi.sql
psql -U your_user -d hodim_nazorati -f migrations/add-admin-id-to-all-tables.sql
psql -U your_user -d hodim_nazorati -f migrations/migrate-day-of-week-to-1-7.sql
```

### 2.4. Event type column qo'shish

```bash
node add-event-type-column.js
```

### 2.5. Admin foydalanuvchi yaratish

```bash
npm run setup-db admin admin123 admin
```

Yoki super admin:

```bash
npm run setup-db superadmin admin123 super_admin
```

## 3. Dependencies O'rnatish

```bash
npm install --production
```

## 4. Production Mode

### 4.1. PM2 bilan ishga tushirish (Tavsiya etiladi)

```bash
# PM2 o'rnatish
npm install -g pm2

# Server ishga tushirish
pm2 start server.js --name hodim-nazorati

# Server avtomatik qayta ishga tushishi uchun
pm2 startup
pm2 save
```

### 4.2. Node.js bilan to'g'ridan-to'g'ri

```bash
NODE_ENV=production node server.js
```

## 5. Nginx Reverse Proxy (Ixtiyoriy)

Nginx konfiguratsiyasi:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 6. SSL/HTTPS Sozlash (Tavsiya etiladi)

Let's Encrypt bilan SSL sertifikat o'rnatish:

```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

## 7. Firewall Sozlash

```bash
# PostgreSQL portini ochish (faqat kerak bo'lsa)
sudo ufw allow 5432/tcp

# HTTP va HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Application port (faqat localhost uchun)
sudo ufw allow 3000/tcp
```

## 8. File Permissions

```bash
# Uploads papkasiga yozish huquqi
chmod -R 755 public/uploads
```

## 9. Monitoring va Logs

### PM2 Monitoring

```bash
# Status ko'rish
pm2 status

# Logs ko'rish
pm2 logs hodim-nazorati

# Monitoring
pm2 monit
```

## 10. Backup

### Database Backup

```bash
# Backup yaratish
pg_dump -U your_user -d hodim_nazorati > backup_$(date +%Y%m%d).sql

# Backup yuklash
psql -U your_user -d hodim_nazorati < backup_20240101.sql
```

### Uploads Backup

```bash
tar -czf uploads_backup_$(date +%Y%m%d).tar.gz public/uploads/
```

## 11. Yangilash

```bash
# Kod yangilash
git pull origin main

# Dependencies yangilash
npm install --production

# PM2 qayta ishga tushirish
pm2 restart hodim-nazorati
```

## 12. Troubleshooting

### Database ulanish muammosi

```bash
# PostgreSQL status
sudo systemctl status postgresql

# Connection test
psql -U your_user -d hodim_nazorati -h your_host
```

### Port band

```bash
# Portni tekshirish
sudo lsof -i :3000

# Processni to'xtatish
kill -9 PID
```

### Memory muammosi

```bash
# PM2 memory limit
pm2 start server.js --name hodim-nazorati --max-memory-restart 500M
```

## 13. Production Checklist

- [ ] `.env` fayl to'g'ri sozlangan
- [ ] Database yaratilgan va schema yuklangan
- [ ] Admin foydalanuvchi yaratilgan
- [ ] Dependencies o'rnatilgan
- [ ] PM2 yoki boshqa process manager sozlangan
- [ ] Nginx yoki reverse proxy sozlangan (ixtiyoriy)
- [ ] SSL sertifikat o'rnatilgan (tavsiya etiladi)
- [ ] Firewall sozlangan
- [ ] Backup strategiyasi sozlangan
- [ ] Monitoring sozlangan
- [ ] Log rotation sozlangan

## 14. Support

Muammo bo'lsa, quyidagilarni tekshiring:
- Server logs: `pm2 logs hodim-nazorati`
- Database logs: PostgreSQL log fayllari
- Browser console: Frontend xatoliklari
