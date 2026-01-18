#!/bin/bash

# Production Server Setup Script
# Bu script yangi server'da birinchi marta sozlash uchun

set -e

echo "🔧 RestoControl Production Setup"
echo "=================================="

# 1. Check Node.js
echo ""
echo "📦 Node.js tekshirilmoqda..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js topilmadi! O'rnatish kerak."
    exit 1
fi
echo "✅ Node.js: $(node --version)"

# 2. Check PostgreSQL
echo ""
echo "🗄️  PostgreSQL tekshirilmoqda..."
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL topilmadi! O'rnatish kerak."
    exit 1
fi
echo "✅ PostgreSQL mavjud"

# 3. Check PM2
echo ""
echo "🔄 PM2 tekshirilmoqda..."
if ! command -v pm2 &> /dev/null; then
    echo "⚠️  PM2 topilmadi. O'rnatilmoqda..."
    sudo npm install -g pm2
fi
echo "✅ PM2: $(pm2 --version)"

# 4. Create logs directory
echo ""
echo "📁 Logs papkasi yaratilmoqda..."
mkdir -p logs
echo "✅ Logs papkasi yaratildi"

# 5. Create uploads directories
echo ""
echo "📁 Uploads papkalari yaratilmoqda..."
mkdir -p public/uploads/logos
mkdir -p public/uploads/faces
chmod -R 775 public/uploads
echo "✅ Uploads papkalari yaratildi"

# 6. Check .env file
echo ""
echo "⚙️  .env fayli tekshirilmoqda..."
if [ ! -f .env ]; then
    echo "⚠️  .env fayli topilmadi!"
    echo "📝 .env.example dan .env yarating:"
    echo "   cp .env.example .env"
    echo "   nano .env"
    echo ""
    read -p "Davom etishni xohlaysizmi? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ .env fayli mavjud"
fi

# 7. Install dependencies
echo ""
echo "📦 Dependencies o'rnatilmoqda..."
npm install --production
echo "✅ Dependencies o'rnatildi"

# 8. Database setup reminder
echo ""
echo "🗄️  Database sozlash:"
echo "   1. Database yaratish: CREATE DATABASE hodim_nazorati;"
echo "   2. Schema yuklash: psql -U user -d hodim_nazorati -f schema.sql"
echo "   3. Migration'lar: psql -U user -d hodim_nazorati -f migrations/*.sql"
echo "   4. Super admin: npm run setup-db superadmin password super_admin"

# 9. PM2 setup
echo ""
echo "🚀 PM2 sozlanmoqda..."
pm2 start ecosystem.config.js || echo "⚠️  PM2'da muammo bo'lishi mumkin"
pm2 save
echo "✅ PM2 sozlandi"

echo ""
echo "✅ Setup yakunlandi!"
echo ""
echo "📋 Keyingi qadamlar:"
echo "   1. .env faylini to'ldiring"
echo "   2. Database'ni sozlang"
echo "   3. Nginx'ni sozlang (DEPLOY.md qarang)"
echo "   4. pm2 logs hodim-nazorati - loglarni tekshiring"
