# 🚀 Tez Deployment Qo'llanmasi

Bu qisqa qo'llanma loyihani tezda production serverga qo'yish uchun.

## ⚡ Tez Start (5 daqiqa)

### 1. Server'ga ulanish
```bash
ssh root@138.249.7.234
```

### 2. Loyihani ko'chirish
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

### 4. .env faylini sozlash
```bash
cp .env.example .env
nano .env
```

`.env` faylida:
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=hodim_nazorati
DB_USER=your_db_user
DB_PASSWORD=your_db_password
PORT=3000
NODE_ENV=production
SESSION_SECRET=your_random_secret_32_chars_min
```

### 5. Database sozlash
```bash
# Database yaratish
sudo -u postgres psql
CREATE DATABASE hodim_nazorati;
CREATE USER restocontrol_user WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE hodim_nazorati TO restocontrol_user;
\q

# Schema yuklash
psql -U restocontrol_user -d hodim_nazorati -f schema.sql

# Migration'lar
psql -U restocontrol_user -d hodim_nazorati -f migrations/*.sql

# Event type column
node add-event-type-column.js

# Super admin
npm run setup-db superadmin password super_admin
```

### 6. PM2 bilan ishga tushirish
```bash
pm2 start ecosystem.config.js
pm2 save
```

### 7. Nginx sozlash
```bash
sudo nano /etc/nginx/sites-available/restocontrol
```

Nginx config:
```nginx
server {
    listen 80;
    server_name restocontrol.uz www.restocontrol.uz;
    
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

### 8. SSL (HTTPS)
```bash
sudo certbot --nginx -d restocontrol.uz -d www.restocontrol.uz
```

## 🔄 Yangilash

Yangi o'zgarishlar bo'lganda:

```bash
cd /var/www/restocontrol_2
./quick-deploy.sh
```

Yoki qo'lda:
```bash
git pull
npm install --production
pm2 restart hodim-nazorati
```

## 📊 Monitoring

```bash
# PM2 holati
pm2 status

# Loglar
pm2 logs hodim-nazorati

# Real-time monitoring
pm2 monit
```

## 🆘 Muammolarni Hal Qilish

### Server ishlamayapti
```bash
pm2 logs hodim-nazorati --lines 100
pm2 restart hodim-nazorati
```

### Database ulanishi yo'q
```bash
# PostgreSQL tekshirish
sudo systemctl status postgresql

# .env tekshirish
cat .env
```

### Nginx 502
```bash
# Server ishlayotganini tekshirish
pm2 status

# Nginx loglar
sudo tail -f /var/log/nginx/error.log
```

## 📝 To'liq Qo'llanma

Batafsil qo'llanma uchun `DEPLOY.md` faylini ko'ring.
