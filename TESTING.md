# Testing Qo'llanmasi

Bu qo'llanma loyihaning barcha funksiyalarini test qilish uchun yordam beradi.

## Test Checklist

### 1. Authentication va Authorization

- [ ] Admin login ishlaydi
- [ ] Super admin login ishlaydi
- [ ] Hodim login ishlaydi
- [ ] Noto'g'ri parol bilan login qilish mumkin emas
- [ ] To'xtatilgan foydalanuvchi login qila olmaydi
- [ ] Logout ishlaydi
- [ ] Session to'g'ri ishlaydi

### 2. Admin Panel

- [ ] Adminlar ro'yxati ko'rsatiladi
- [ ] Yangi admin qo'shish ishlaydi
- [ ] Adminni o'chirish ishlaydi
- [ ] Adminni yangilash ishlaydi
- [ ] Super admin barcha adminlarni ko'radi
- [ ] Admin faqat o'z ma'lumotlarini ko'radi

### 3. Hodimlar Boshqaruvi

- [ ] Hodimlar ro'yxati ko'rsatiladi
- [ ] Yangi hodim qo'shish ishlaydi
- [ ] Hodimni tahrirlash ishlaydi
- [ ] Hodimni o'chirish ishlaydi
- [ ] Hodim qidirish ishlaydi
- [ ] Hodim filtrlash ishlaydi
- [ ] Hodim rasmi yuklash ishlaydi

### 4. Ish Jadvali

- [ ] Ish jadvali ko'rsatiladi
- [ ] Ish jadvali sozlash ishlaydi
- [ ] Bir haftalik ma'lumotlar ko'rsatiladi
- [ ] Davomat ma'lumotlari to'g'ri ko'rsatiladi

### 5. Davomat

- [ ] Davomat yozuvlari ko'rsatiladi
- [ ] Davomat filtrlash ishlaydi
- [ ] Davomat qidirish ishlaydi
- [ ] Davomat eksport ishlaydi
- [ ] Bugungi statistika ko'rsatiladi

### 6. Maoshlar

- [ ] Maoshlar ro'yxati ko'rsatiladi
- [ ] Maosh qo'shish ishlaydi
- [ ] Maoshni tahrirlash ishlaydi
- [ ] Maoshni o'chirish ishlaydi
- [ ] Maosh filtrlash ishlaydi
- [ ] Maosh statistika to'g'ri

### 7. Bonuslar

- [ ] Bonuslar ro'yxati ko'rsatiladi
- [ ] Bonus qo'shish ishlaydi
- [ ] Bonusni tahrirlash ishlaydi
- [ ] Bonusni o'chirish ishlaydi
- [ ] Bonus statistika to'g'ri

### 8. Jarimalar

- [ ] Jarimalar ro'yxati ko'rsatiladi
- [ ] Jarima qo'shish ishlaydi
- [ ] Jarimani tahrirlash ishlaydi
- [ ] Jarimani o'chirish ishlaydi
- [ ] Jarima statistika to'g'ri

### 9. Terminallar

- [ ] Terminallar ro'yxati ko'rsatiladi
- [ ] Terminal qo'shish ishlaydi
- [ ] Terminalni tahrirlash ishlaydi
- [ ] Terminalni o'chirish ishlaydi
- [ ] Terminal ulanishini test qilish ishlaydi
- [ ] Terminal sinxronizatsiyasi ishlaydi

### 10. Hodim Dashboard

- [ ] Dashboard ma'lumotlari yuklanadi
- [ ] Statistika to'g'ri ko'rsatiladi
- [ ] Ish jadvali ko'rsatiladi
- [ ] Davomat ko'rsatiladi
- [ ] Maoshlar ko'rsatiladi
- [ ] Bonuslar ko'rsatiladi
- [ ] Jarimalar ko'rsatiladi
- [ ] Shaxsiy ma'lumotlarni tahrirlash ishlaydi

### 11. Mobil Responsive

- [ ] Desktop'da to'liq ishlaydi
- [ ] Tablet'da to'liq ishlaydi
- [ ] Mobil'da to'liq ishlaydi
- [ ] Menyu mobil'da to'g'ri ishlaydi
- [ ] Formalar mobil'da to'g'ri ko'rsatiladi
- [ ] Jadvalar mobil'da scroll qilinadi

### 12. File Upload

- [ ] Logo yuklash ishlaydi
- [ ] Yuz rasmi yuklash ishlaydi
- [ ] File validation ishlaydi
- [ ] File size limit ishlaydi
- [ ] File type validation ishlaydi

### 13. API Endpoints

- [ ] Barcha GET endpoint'lar ishlaydi
- [ ] Barcha POST endpoint'lar ishlaydi
- [ ] Barcha PUT endpoint'lar ishlaydi
- [ ] Barcha DELETE endpoint'lar ishlaydi
- [ ] Error handling to'g'ri ishlaydi
- [ ] Authentication middleware ishlaydi
- [ ] Authorization middleware ishlaydi

### 14. Database

- [ ] Database ulanish ishlaydi
- [ ] Query'lar to'g'ri ishlaydi
- [ ] Transaction'lar ishlaydi
- [ ] Foreign key constraint'lar ishlaydi
- [ ] Unique constraint'lar ishlaydi

### 15. Performance

- [ ] Sahifalar tez yuklanadi
- [ ] API response tez
- [ ] Database query'lar optimallashtirilgan
- [ ] Image optimization ishlaydi

## Manual Test Scripts

### 1. Login Test

```bash
# Admin login
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Hodim login
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"employee1","password":"password123"}'
```

### 2. API Test

```bash
# Get employees (token kerak)
curl -X GET http://localhost:3000/api/employees \
  -H "Authorization: Bearer YOUR_TOKEN"

# Get attendance
curl -X GET http://localhost:3000/api/attendance \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Browser Test

### Chrome DevTools

1. F12 ni bosing
2. Console'da xatoliklarni tekshiring
3. Network tab'da request'larni tekshiring
4. Application tab'da localStorage va sessionStorage'ni tekshiring

### Mobile Test

1. Chrome DevTools'da Device Toolbar'ni oching
2. Turli qurilmalarni tanlang (iPhone, Android, tablet)
3. Responsive dizaynni tekshiring

## Database Test

```sql
-- Hodimlar soni
SELECT COUNT(*) FROM employees;

-- Davomat yozuvlari soni
SELECT COUNT(*) FROM attendance_logs;

-- Maoshlar soni
SELECT COUNT(*) FROM salaries;

-- Database size
SELECT pg_size_pretty(pg_database_size('hodim_nazorati'));
```

## Performance Test

```bash
# Server status
pm2 status

# Memory usage
pm2 monit

# Logs
pm2 logs hodim-nazorati
```

## Security Test

- [ ] SQL injection test
- [ ] XSS test
- [ ] CSRF test
- [ ] Authentication bypass test
- [ ] Authorization bypass test

## Production Test

- [ ] Environment variables to'g'ri sozlangan
- [ ] Database connection to'g'ri
- [ ] SSL/HTTPS ishlaydi
- [ ] Error logging ishlaydi
- [ ] Backup ishlaydi
