# Hostingga Joylashtirish Yo'riqnomasi

## 1. Kerakli Talablar

### Server Talablari:
- **Node.js**: 14.0.0 yoki yuqori versiya
- **PostgreSQL**: 12 yoki yuqori versiya
- **PM2** (tavsiya etiladi): Process manager
- **Nginx** (tavsiya etiladi): Reverse proxy

### Hosting Provayderlar:
- **VPS** (DigitalOcean, AWS, Linode, va boshqalar)
- **Node.js hosting** (Heroku, Railway, Render, va boshqalar)
- **Shared hosting** (Node.js qo'llab-quvvatlasa)

---

## 2. Joylashtirish Bosqichlari

### A. VPS (Ubuntu/Debian) uchun

#### 2.1. Serverga ulanish
```bash
ssh root@your-server-ip
```

#### 2.2. Node.js va PostgreSQL o'rnatish
```bash
# Node.js o'rnatish
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# PostgreSQL o'rnatish
sudo apt update
sudo apt install postgresql postgresql-contrib

# PostgreSQL ni ishga tushirish
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### 2.3. PostgreSQL ma'lumotlar bazasini yaratish
```bash
sudo -u postgres psql

# PostgreSQL ichida:
CREATE DATABASE hodim_nazorati;
CREATE USER your_db_user WITH PASSWORD 'your_strong_password';
GRANT ALL PRIVILEGES ON DATABASE hodim_nazorati TO your_db_user;
\q
```

#### 2.4. Loyihani yuklash
```bash
# Git orqali
cd /var/www
git clone your-repository-url hodim-nazorati
cd hodim-nazorati

# Yoki FTP/SFTP orqali fayllarni yuklang
```

#### 2.5. Environment faylini sozlash
```bash
nano .env
```

`.env` faylida quyidagilarni kiriting:
```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=hodim_nazorati
DB_USER=your_db_user
DB_PASSWORD=your_strong_password

# Server
PORT=3000
NODE_ENV=production

# Session Secret (random string)
SESSION_SECRET=your-random-secret-key-here
```

#### 2.6. Loyihani o'rnatish
```bash
npm install --production
npm run migrate
```

#### 2.7. PM2 orqali ishga tushirish
```bash
# PM2 o'rnatish
npm install -g pm2

# Loyihani ishga tushirish
pm2 start server.js --name hodim-nazorati

# Avtomatik qayta ishga tushirish
pm2 startup
pm2 save
```

#### 2.8. Nginx sozlash (Reverse Proxy)
```bash
sudo apt install nginx
sudo nano /etc/nginx/sites-available/hodim-nazorati
```

Nginx konfiguratsiyasi:
```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

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

    # Static files
    location /public {
        alias /var/www/hodim-nazorati/public;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

```bash
# Nginx ni faollashtirish
sudo ln -s /etc/nginx/sites-available/hodim-nazorati /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

#### 2.9. SSL sertifikat (Let's Encrypt)
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

---

### B. Heroku uchun

#### 2.1. Heroku CLI o'rnatish
```bash
# Windows
# https://devcenter.heroku.com/articles/heroku-cli dan yuklab oling

# Mac/Linux
brew tap heroku/brew && brew install heroku
```

#### 2.2. Heroku'ga kirish
```bash
heroku login
```

#### 2.3. Heroku loyihasini yaratish
```bash
cd hodim-nazorati
heroku create your-app-name
```

#### 2.4. PostgreSQL addon qo'shish
```bash
heroku addons:create heroku-postgresql:hobby-dev
```

#### 2.5. Environment variables sozlash
```bash
heroku config:set NODE_ENV=production
heroku config:set DB_HOST=your-db-host
heroku config:set DB_PORT=5432
heroku config:set DB_NAME=your-db-name
heroku config:set DB_USER=your-db-user
heroku config:set DB_PASSWORD=your-db-password
heroku config:set SESSION_SECRET=your-random-secret
```

#### 2.6. Migrations ishga tushirish
```bash
heroku run npm run migrate
```

#### 2.7. Deploy qilish
```bash
git push heroku main
```

---

### C. Railway/Render uchun

#### Railway:
1. Railway.io ga kirib, yangi loyiha yarating
2. GitHub repository'ni ulang
3. PostgreSQL service qo'shing
4. Environment variables'ni sozlang
5. Deploy qiling

#### Render:
1. Render.com ga kirib, yangi Web Service yarating
2. GitHub repository'ni ulang
3. PostgreSQL database yarating
4. Environment variables'ni sozlang
5. Build command: `npm install && npm run migrate`
6. Start command: `node server.js`
7. Deploy qiling

---

## 3. Muhim Sozlamalar

### 3.1. Environment Variables
Quyidagi o'zgaruvchilar majburiy:
- `DB_HOST` - PostgreSQL server manzili
- `DB_PORT` - PostgreSQL port (odatda 5432)
- `DB_NAME` - Ma'lumotlar bazasi nomi
- `DB_USER` - Ma'lumotlar bazasi foydalanuvchisi
- `DB_PASSWORD` - Ma'lumotlar bazasi paroli
- `PORT` - Server port (hosting provayder belgilaydi)
- `NODE_ENV` - `production` qilib qo'ying
- `SESSION_SECRET` - Xavfsiz random string

### 3.2. File Permissions
```bash
# Uploads papkasiga yozish ruxsati
chmod -R 755 public/uploads
```

### 3.3. Firewall Sozlamalari
```bash
# Faqat kerakli portlarni oching
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

---

## 4. Tekshirish

### 4.1. Server ishlayaptimi?
```bash
# PM2 orqali
pm2 status
pm2 logs hodim-nazorati

# Yoki
curl http://localhost:3000
```

### 4.2. Database ulanganmi?
```bash
psql -U your_db_user -d hodim_nazorati -c "SELECT version();"
```

### 4.3. Browser'da tekshirish
- `http://your-domain.com` yoki `http://your-server-ip:3000`
- Login sahifasini oching
- Test qiling

---

## 5. Xavfsizlik

### 5.1. Muhim:
- ✅ `.env` faylini `.gitignore` ga qo'shing
- ✅ Kuchli parollar ishlating
- ✅ SSL sertifikat o'rnating (HTTPS)
- ✅ Firewall sozlang
- ✅ Muntazam backup qiling
- ✅ Node.js va dependencies'ni yangilab turing

### 5.2. Backup
```bash
# Database backup
pg_dump -U your_db_user hodim_nazorati > backup_$(date +%Y%m%d).sql

# Fayllarni backup
tar -czf backup_files_$(date +%Y%m%d).tar.gz /var/www/hodim-nazorati
```

---

## 6. Monitoring va Logs

### PM2 Monitoring:
```bash
pm2 monit
pm2 logs hodim-nazorati --lines 100
```

### Nginx Logs:
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

---

## 7. Muammolarni Hal Qilish

### Server ishlamayapti:
1. PM2 status tekshiring: `pm2 status`
2. Loglarni ko'ring: `pm2 logs hodim-nazorati`
3. Port bandmi? `netstat -tulpn | grep 3000`

### Database ulanish muammosi:
1. PostgreSQL ishlayaptimi? `sudo systemctl status postgresql`
2. Credentials to'g'rimi? `.env` faylini tekshiring
3. Firewall portlarni bloklamayaptimi?

### 404 xatolik:
1. Nginx konfiguratsiyasini tekshiring
2. Static files path to'g'rimi?
3. Server port to'g'rimi?

---

## 8. Foydali Buyruqlar

```bash
# PM2
pm2 restart hodim-nazorati    # Qayta ishga tushirish
pm2 stop hodim-nazorati       # To'xtatish
pm2 delete hodim-nazorati     # O'chirish
pm2 logs hodim-nazorati       # Loglarni ko'rish

# Database
psql -U your_db_user -d hodim_nazorati  # Database'ga kirish
npm run migrate                          # Migrations ishga tushirish

# Nginx
sudo nginx -t              # Konfiguratsiyani tekshirish
sudo systemctl restart nginx  # Qayta ishga tushirish
```

---

## 9. Support

Agar muammo bo'lsa:
1. Loglarni tekshiring
2. Environment variables'ni tekshiring
3. Database connection'ni tekshiring
4. Server resources'ni tekshiring (RAM, CPU, Disk)

---

**Muvaffaqiyatli deploy qilish tilaymiz! 🚀**
