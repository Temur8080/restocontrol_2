# ⚡ Tez Deployment (Quick Start)

## Server'ga Birinchi Marta Qo'yish

### 1. Server'ga ulanish
```bash
ssh root@138.249.7.234
```

### 2. Loyihani yuklash
```bash
cd /var/www
git clone your-repo-url restocontrol_2
cd restocontrol_2
```

### 3. Avtomatik sozlash
```bash
chmod +x setup-production.sh
./setup-production.sh
```

### 4. Environment variables
```bash
cp .env.example .env
nano .env
```

### 5. Database
```bash
# Database yaratish va sozlash
sudo -u postgres psql
CREATE DATABASE hodim_nazorati;
CREATE USER restocontrol_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE hodim_nazorati TO restocontrol_user;
\q

# Schema va migration'lar
psql -U restocontrol_user -d hodim_nazorati -f schema.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/create-attendance-logs.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/create-work-schedules.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/create-penalties-bonuses-kpi.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/add-admin-id-to-all-tables.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/add-organization-fields.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/migrate-day-of-week-to-1-7.sql

# Event type column
node add-event-type-column.js

# Super admin
npm run setup-db superadmin your_password super_admin
```

### 6. PM2
```bash
pm2 start ecosystem.config.js
pm2 save
```

### 7. Nginx
```bash
sudo nano /etc/nginx/sites-available/restocontrol
```

Paste:
```nginx
server {
    listen 80;
    server_name restocontrol.uz www.restocontrol.uz;
    client_max_body_size 10M;
    
    location /public {
        alias /var/www/restocontrol_2/public;
    }
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/restocontrol /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 8. SSL
```bash
sudo certbot --nginx -d restocontrol.uz -d www.restocontrol.uz
```

## 🔄 Yangilash

```bash
cd /var/www/restocontrol_2
./quick-deploy.sh
```

## ✅ Tekshirish

```bash
pm2 status
pm2 logs hodim-nazorati
curl http://localhost:3000
```
