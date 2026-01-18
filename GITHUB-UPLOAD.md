# 📤 GitHub'ga Loyihani Yuklash Qo'llanmasi

## ✅ Tavsiya etilgan usul: Git Repository

GitHub'ga loyihani **Git repository** sifatida yuklash eng yaxshi usul. Bu:
- ✅ Versiya nazorati
- ✅ Oson yangilanishlar
- ✅ Hamkorlik qulay
- ✅ Kod tarixi saqlanadi

## 🚀 Qadamlari

### 1. GitHub'da yangi repository yaratish

1. GitHub'ga kiring: https://github.com
2. "New repository" tugmasini bosing
3. Repository nomini kiriting: `restocontrol_2`
4. "Public" yoki "Private" tanlang
5. **"Initialize this repository with a README" ni belgilamang** (chunki kod allaqachon bor)
6. "Create repository" tugmasini bosing

### 2. Local repository'ni sozlash

```bash
# Git user sozlash (bir marta)
git config --global user.name "Sizning Ismingiz"
git config --global user.email "sizning@email.com"

# Loyiha papkasiga o'tish
cd D:\restocontrol_2

# Barcha o'zgarishlarni qo'shish
git add .

# Commit yaratish
git commit -m "Initial commit: RestoControl production ready"

# GitHub repository'ga ulanish
git remote add origin https://github.com/sizning-username/restocontrol_2.git

# Kodlarni yuklash
git push -u origin main
```

### 3. Agar `main` branch mavjud bo'lmasa

```bash
# Branch nomini o'zgartirish
git branch -M main

# Yoki master branch ishlatish
git push -u origin master
```

## ⚠️ .zip Fayl Sifatida Yuklash (Tavsiya etilmaydi)

Agar Git ishlatishni xohlamasangiz:

1. GitHub'da repository yaratish
2. "uploading an existing file" tugmasini bosing
3. .zip faylni yuklash

**Muammolar:**
- ❌ Versiya nazorati yo'q
- ❌ Yangilanishlar qiyin
- ❌ Kod tarixi saqlanmaydi
- ❌ Hamkorlik qiyin

## 📝 .gitignore Tekshirish

`.gitignore` faylida quyidagilar bo'lishi kerak:
- `.env` - maxfiy ma'lumotlar
- `node_modules/` - dependencies
- `logs/` - log fayllar
- `public/uploads/` - yuklangan fayllar (ixtiyoriy)

## 🔐 Maxfiy Ma'lumotlarni Himoya Qilish

**Muhim:** `.env` faylini GitHub'ga yuklamang!

```bash
# .gitignore tekshirish
cat .gitignore | grep .env

# Agar .env qo'shilmagan bo'lsa
echo ".env" >> .gitignore
```

## 📋 GitHub'ga Yuklashdan Oldin Checklist

- [ ] `.env` fayli `.gitignore`'da
- [ ] `node_modules/` `.gitignore`'da
- [ ] Maxfiy ma'lumotlar olib tashlangan
- [ ] README.md yangilangan
- [ ] Barcha fayllar tayyor

## 🔄 Keyingi Yangilanishlar

Yangi o'zgarishlar bo'lganda:

```bash
git add .
git commit -m "Yangilanish tavsifi"
git push
```

## 🆘 Muammolarni Hal Qilish

### Authentication xatosi
```bash
# Personal Access Token ishlatish
# GitHub Settings > Developer settings > Personal access tokens
git remote set-url origin https://token@github.com/username/repo.git
```

### Branch nomi xatosi
```bash
git branch -M main
git push -u origin main
```
