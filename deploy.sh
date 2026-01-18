#!/bin/bash

# RestoControl Deployment Script
# Bu script loyihani production serverga deploy qilish uchun

set -e  # Xatolik bo'lsa, to'xtatish

echo "🚀 RestoControl Deployment Script"
echo "=================================="

# 1. Git'dan yangi o'zgarishlarni olish
echo ""
echo "📥 Git'dan yangi o'zgarishlarni olish..."
git pull origin main || git pull origin master

# 2. Dependencies o'rnatish/yangilash
echo ""
echo "📦 Dependencies o'rnatilmoqda..."
npm install --production

# 3. Environment variables tekshirish
echo ""
echo "🔍 Environment variables tekshirilmoqda..."
if [ ! -f .env ]; then
    echo "⚠️  .env fayli topilmadi!"
    echo "📝 .env.example dan .env yarating va sozlang:"
    echo "   cp .env.example .env"
    echo "   nano .env"
    exit 1
fi

# 4. Database migration'larni ishga tushirish
echo ""
echo "🗄️  Database migration'lar tekshirilmoqda..."
if [ -f run-migrations.js ]; then
    echo "   Migration script mavjud, lekin avtomatik ishlamaydi."
    echo "   Qo'lda ishga tushiring: npm run migrate"
fi

# 5. PM2 bilan server ishga tushirish/yangilash
echo ""
echo "🔄 PM2 bilan server yangilanmoqda..."

# PM2'da mavjudligini tekshirish
if pm2 list | grep -q "hodim-nazorati"; then
    echo "   ✅ PM2'da mavjud, qayta ishga tushirilmoqda..."
    pm2 restart hodim-nazorati
else
    echo "   🆕 PM2'da yangi process yaratilmoqda..."
    pm2 start ecosystem.config.js
fi

# 6. PM2 loglarini ko'rsatish
echo ""
echo "📋 PM2 holati:"
pm2 status

echo ""
echo "✅ Deployment muvaffaqiyatli yakunlandi!"
echo ""
echo "📊 Loglarni ko'rish: pm2 logs hodim-nazorati"
echo "🔄 Qayta ishga tushirish: pm2 restart hodim-nazorati"
echo "⏹️  To'xtatish: pm2 stop hodim-nazorati"
