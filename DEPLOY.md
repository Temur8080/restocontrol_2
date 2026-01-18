# 🚀 RestoControl Deployment Qo'llanmasi

Bu qo'llanma loyihani production serverga qo'yish uchun barcha qadamlarni tushuntiradi.

## 📋 Talablar

- **Node.js** 14+ yoki 16+
- **PostgreSQL** 12+
- **PM2** (process manager)
- **Nginx** (reverse proxy)
- **Git** (loyiha versiyalash)

## 🔧 1. Server Sozlash

### 1.1. Node.js va NPM o'rnatish

```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Node.js versiyasini tekshirish
node --version
npm --version
```

### 1.2. PostgreSQL o'rnatish

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib

# PostgreSQL'ni ishga tushirish
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### 1.3. PM2 o'rnatish

```bash
sudo npm install -g pm2

# PM2 avtomatik ishga tushishi uchun
pm2 startup
pm2 save
```

### 1.4. Nginx o'rnatish

```bash
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

## 🗄️ 2. Database Sozlash

### 2.1. Database va foydalanuvchi yaratish

```bash
sudo -u postgres psql
```

PostgreSQL'da:

```sql
-- Database yaratish
CREATE DATABASE hodim_nazorati;

-- Foydalanuvchi yaratish
CREATE USER restocontrol_user WITH PASSWORD 'your_secure_password';

-- Ruxsatlar berish
GRANT ALL PRIVILEGES ON DATABASE hodim_nazorati TO restocontrol_user;

-- PostgreSQL'dan chiqish
\q
```

### 2.2. Schema yuklash

```bash
cd /path/to/restocontrol_2
psql -U restocontrol_user -d hodim_nazorati -f schema.sql
```

### 2.3. Migration'larni yuklash

```bash
# Barcha migration fayllarni yuklash
psql -U restocontrol_user -d hodim_nazorati -f migrations/create-attendance-logs.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/create-work-schedules.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/create-penalties-bonuses-kpi.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/add-admin-id-to-all-tables.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/add-organization-fields.sql
psql -U restocontrol_user -d hodim_nazorati -f migrations/migrate-day-of-week-to-1-7.sql

# Event type column qo'shish
node add-event-type-column.js
```

### 2.4. Super Admin yaratish

```bash
npm run setup-db superadmin your_password super_admin
```

## 📁 3. Loyihani Serverga Ko'chirish

### 3.1. Git orqali (Tavsiya etiladi)

```bash
# Server'da loyiha papkasini yaratish
cd /var/www
sudo git clone https://github.com/your-username/restocontrol_2.git
# yoki
sudo git clone your-git-repo-url restocontrol_2

cd restocontrol_2
sudo chown -R $USER:$USER /var/www/restocontrol_2
```

### 3.2. Yoki SCP orqali

```bash
# Local mashinadan
scp -r D:\restocontrol_2 root@138.249.7.234:/var/www/
```

## ⚙️ 4. Environment Variables Sozlash

```bash
cd /var/www/restocontrol_2

# .env faylini yaratish
cp .env.example .env
nano .env
```

`.env` faylida quyidagilarni to'ldiring:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=hodim_nazorati
DB_USER=restocontrol_user
DB_PASSWORD=your_secure_password

PORT=3000
NODE_ENV=production

SESSION_SECRET=your_random_secret_key_min_32_characters_long
```

**SESSION_SECRET yaratish:**
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

## 📦 5. Dependencies O'rnatish

```bash
cd /var/www/restocontrol_2
npm install --production
```

## 🚀 6. Server Ishga Tushirish

### 6.1. PM2 bilan (Tavsiya etiladi)

```bash
# Ecosystem config bilan
pm2 start ecosystem.config.js

# Yoki to'g'ridan-to'g'ri
pm2 start server.js --name hodim-nazorati --env production

# PM2 holatini ko'rish
pm2 status

# Loglarni ko'rish
pm2 logs hodim-nazorati

# Avtomatik ishga tushishi uchun
pm2 startup
pm2 save
```

### 6.2. Deployment Script bilan

```bash
chmod +x deploy.sh
./deploy.sh
```

## 🌐 7. Nginx Sozlash

### 7.1. Nginx konfiguratsiyasi

```bash
sudo nano /etc/nginx/sites-available/restocontrol
```

Quyidagi konfiguratsiyani kiriting:

```nginx
server {
    listen 80;
    server_name restocontrol.uz www.restocontrol.uz;

    # Logs
    access_log /var/log/nginx/restocontrol_access.log;
    error_log /var/log/nginx/restocontrol_error.log;

    # Client max body size (rasm yuklash uchun)
    client_max_body_size 10M;

    # Static files
    location /public {
        alias /var/www/restocontrol_2/public;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # API va boshqa so'rovlar
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
        
        # Timeout sozlamalari
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

### 7.2. Nginx'ni faollashtirish

```bash
# Symlink yaratish
sudo ln -s /etc/nginx/sites-available/restocontrol /etc/nginx/sites-enabled/

# Test qilish
sudo nginx -t

# Nginx'ni qayta ishga tushirish
sudo systemctl restart nginx
```

## 🔒 8. SSL Sertifikat (HTTPS)

### 8.1. Let's Encrypt o'rnatish

```bash
sudo apt install certbot python3-certbot-nginx
```

### 8.2. SSL sertifikat olish

```bash
sudo certbot --nginx -d restocontrol.uz -d www.restocontrol.uz
```

Certbot avtomatik ravishda Nginx konfiguratsiyasini yangilaydi.

## ✅ 9. Tekshirish

### 9.1. Server holatini tekshirish

```bash
# PM2 holati
pm2 status

# Nginx holati
sudo systemctl status nginx

# PostgreSQL holati
sudo systemctl status postgresql

# Port 3000'da nima ishlayotganini tekshirish
sudo netstat -tlnp | grep :3000
```

### 9.2. Loglarni tekshirish

```bash
# PM2 loglari
pm2 logs hodim-nazorati --lines 50

# Nginx error loglari
sudo tail -f /var/log/nginx/restocontrol_error.log

# Nginx access loglari
sudo tail -f /var/log/nginx/restocontrol_access.log
```

### 9.3. Browser'da tekshirish

- `http://restocontrol.uz` - Sayt ochilishi kerak
- `https://restocontrol.uz` - HTTPS ishlashi kerak

## 🔄 10. Yangilash (Update)

Yangi o'zgarishlar bo'lganda:

```bash
cd /var/www/restocontrol_2

# Git'dan yangi o'zgarishlarni olish
git pull

# Dependencies yangilash
npm install --production

# Database migration (agar kerak bo'lsa)
npm run migrate

# PM2'ni qayta ishga tushirish
pm2 restart hodim-nazorati

# Yoki deployment script bilan
./deploy.sh
```

## 🛠️ 11. Muammolarni Hal Qilish

### 11.1. Server ishlamayapti

```bash
# PM2 loglarini ko'rish
pm2 logs hodim-nazorati --lines 100

# Server'ni qo'lda ishga tushirish (debug uchun)
cd /var/www/restocontrol_2
node server.js
```

### 11.2. Database ulanishi yo'q

```bash
# PostgreSQL'ni tekshirish
sudo systemctl status postgresql

# Database'ga ulanishni test qilish
psql -U restocontrol_user -d hodim_nazorati

# .env faylini tekshirish
cat .env
```

### 11.3. Nginx 502 Bad Gateway

```bash
# Node.js server ishlayotganini tekshirish
pm2 status

# Port 3000'da nima borligini tekshirish
sudo netstat -tlnp | grep :3000

# Nginx error loglari
sudo tail -f /var/log/nginx/restocontrol_error.log
```

### 11.4. Permission xatolari

```bash
# Fayl ruxsatlarini to'g'rilash
sudo chown -R $USER:$USER /var/www/restocontrol_2
chmod -R 755 /var/www/restocontrol_2

# Uploads papkasi uchun
chmod -R 775 /var/www/restocontrol_2/public/uploads
```

## 📊 12. Monitoring

### 12.1. PM2 Monitoring

```bash
# Real-time monitoring
pm2 monit

# PM2 web interface
pm2 web
```

### 12.2. System Resources

```bash
# CPU va Memory
htop

# Disk usage
df -h

# Network
netstat -tuln
```

## 🔐 13. Xavfsizlik

1. **Firewall sozlash:**
```bash
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
```

2. **.env faylini himoya qilish:**
```bash
chmod 600 .env
```

3. **Regular backups:**
```bash
# Database backup script yaratish
# backup-db.sh
pg_dump -U restocontrol_user hodim_nazorati > backup_$(date +%Y%m%d).sql
```

## 📝 14. Checklist

Deployment'dan oldin:

- [ ] Node.js o'rnatilgan
- [ ] PostgreSQL o'rnatilgan va ishlayapti
- [ ] Database yaratilgan
- [ ] Schema yuklangan
- [ ] Migration'lar yuklangan
- [ ] .env fayli sozlangan
- [ ] Dependencies o'rnatilgan
- [ ] PM2 o'rnatilgan
- [ ] Nginx sozlangan
- [ ] SSL sertifikat olingan
- [ ] Firewall sozlangan
- [ ] Super admin yaratilgan
- [ ] Test qilingan

## 🆘 Yordam

Agar muammo bo'lsa:
1. PM2 loglarini tekshiring: `pm2 logs hodim-nazorati`
2. Nginx loglarini tekshiring: `sudo tail -f /var/log/nginx/restocontrol_error.log`
3. Server'ni qo'lda ishga tushiring: `node server.js`
