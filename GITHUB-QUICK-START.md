# ⚡ GitHub'ga Tez Yuklash

## 🎯 Javob: **Ochiq holatda (Git Repository)** - ✅ Tavsiya etiladi

**.zip fayl sifatida yuklash** - ❌ Tavsiya etilmaydi

## 📤 3 Qadamda Yuklash

### 1️⃣ GitHub'da Repository Yaratish

1. https://github.com ga kiring
2. **"+"** tugmasini bosing > **"New repository"**
3. Repository nomi: `restocontrol_2`
4. **"Public"** yoki **"Private"** tanlang
5. ⚠️ **"Add README" ni belgilamang** (kod allaqachon bor)
6. **"Create repository"** tugmasini bosing

### 2️⃣ Terminal'da Buyruqlar

```bash
cd D:\restocontrol_2

# Git user sozlash (bir marta)
git config --global user.name "Sizning Ismingiz"
git config --global user.email "sizning@email.com"

# Barcha fayllarni qo'shish
git add .

# Commit yaratish
git commit -m "Initial commit: RestoControl production ready"

# GitHub'ga ulanish (repository URL'ni o'zgartiring)
git remote add origin https://github.com/SIZNING-USERNAME/restocontrol_2.git

# Branch nomini main qilish
git branch -M main

# Yuklash
git push -u origin main
```

### 3️⃣ Authentication

Agar parol so'ralsa:
- **Personal Access Token** ishlatish kerak
- GitHub Settings > Developer settings > Personal access tokens
- Yoki GitHub Desktop ishlatish

## ✅ Tayyor!

Repository GitHub'da ochiq holatda bo'ladi va barcha kodlar ko'rinadi.

## 🔄 Keyingi Yangilanishlar

```bash
git add .
git commit -m "Yangilanish tavsifi"
git push
```

## ⚠️ Muhim Eslatma

- ✅ `.env` fayli `.gitignore`'da (maxfiy ma'lumotlar yuklanmaydi)
- ✅ `node_modules/` yuklanmaydi
- ✅ Barcha kodlar ochiq holatda bo'ladi
