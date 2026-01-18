# Hodim Nazorati - Xodimlar Boshqaruvi Tizimi

Zamonaviy va to'liq funksional hodimlar boshqaruvi tizimi. PostgreSQL va Node.js asosida qurilgan.

## Asosiy Funksiyalar

- ✅ **Foydalanuvchilar Boshqaruvi**: Admin va super admin rollari
- ✅ **Hodimlar Boshqaruvi**: Hodimlar ro'yxati, qo'shish, tahrirlash, o'chirish
- ✅ **Davomat Tizimi**: Hikvision terminallar bilan integratsiya
- ✅ **Ish Jadvali**: Hodimlar uchun ish jadvali sozlash
- ✅ **Maoshlar**: Kunlik, haftalik va oylik maoshlar
- ✅ **Bonuslar va Jarimalar**: Bonus va jarima boshqaruvi
- ✅ **KPI va Baholash**: KPI tizimi
- ✅ **Hodim Dashboard**: Hodimlar uchun shaxsiy dashboard
- ✅ **Mobil Responsive**: Barcha qurilmalarda to'liq ishlaydi

## O'rnatish

### 1. Talablar

- Node.js 14+ yoki 16+
- PostgreSQL 12+
- npm yoki yarn

### 2. Loyihani klonlash va dependencies o'rnatish

```bash
git clone <repository-url>
cd hodim_nazorati-6
npm install
```

### 3. PostgreSQL database yaratish

PostgreSQL'da yangi database yarating:

```sql
CREATE DATABASE hodim_nazorati;
```

### 4. Environment variables sozlash

`.env` faylini yarating va quyidagi ma'lumotlarni to'ldiring:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=hodim_nazorati
DB_USER=postgres
DB_PASSWORD=sizning_parolingiz

PORT=3000
NODE_ENV=development
```

### 5. Database sozlash

#### 5.1. Schema yuklash

```bash
psql -U postgres -d hodim_nazorati -f schema.sql
```

#### 5.2. Migration fayllarni yuklash

```bash
psql -U postgres -d hodim_nazorati -f migrations/create-attendance-logs.sql
psql -U postgres -d hodim_nazorati -f migrations/create-work-schedules.sql
psql -U postgres -d hodim_nazorati -f migrations/create-penalties-bonuses-kpi.sql
psql -U postgres -d hodim_nazorati -f migrations/add-admin-id-to-all-tables.sql
psql -U postgres -d hodim_nazorati -f migrations/migrate-day-of-week-to-1-7.sql
```

#### 5.3. Event type column qo'shish

```bash
node add-event-type-column.js
```

#### 5.4. Admin foydalanuvchi yaratish

```bash
npm run setup-db admin admin123 admin
```

Yoki super admin:

```bash
npm run setup-db superadmin admin123 super_admin
```

### 6. Serverni ishga tushirish

```bash
npm start
```

Yoki development mode:

```bash
npm run dev
```

Server `http://localhost:3000` manzilida ishlaydi.

## Foydalanish

### Login

1. Browser'da `http://localhost:3000` ni oching
2. Username va password ni kiriting
3. "Kirish" tugmasini bosing
4. Rolga qarab admin panel yoki hodim dashboard'ga yonaltiriladi

### Admin Panel

Admin panelda quyidagi funksiyalar mavjud:

- **Adminlar Boshqaruvi**: Adminlar ro'yxati, qo'shish, o'chirish
- **Hodimlar Boshqaruvi**: Hodimlar ro'yxati, qo'shish, tahrirlash, o'chirish
- **Terminallar**: Hikvision terminallar boshqaruvi
- **Davomat**: Keldi-ketdi yozuvlari
- **Maoshlar**: Hodimlar maoshlari
- **Bonuslar va Jarimalar**: Bonus va jarima boshqaruvi
- **Ish Jadvali**: Hodimlar ish jadvali sozlash

### Hodim Dashboard

Hodimlar uchun shaxsiy dashboard:

- **Boshqaruv**: Statistika, ish jadvali, davomat
- **Shaxsiy Ma'lumotlar**: Shaxsiy ma'lumotlar va tahrirlash
- **Maoshlar**: Maoshlar, bonuslar va jarimalar

## Fayl Tuzilishi

```
hodim_nazorati-6/
├── server.js                      # Node.js server
├── schema.sql                      # PostgreSQL schema
├── setup-db.js                     # Database setup script
├── package.json                    # Dependencies
├── README.md                       # Hujjatlar
├── DEPLOYMENT.md                   # Deployment qo'llanmasi
├── migrations/                     # Database migrations
│   ├── create-attendance-logs.sql
│   ├── create-work-schedules.sql
│   ├── create-penalties-bonuses-kpi.sql
│   ├── add-admin-id-to-all-tables.sql
│   └── migrate-day-of-week-to-1-7.sql
├── services/                       # Service fayllar
│   ├── attendance-sync.js
│   ├── hikvision-isapi.js
│   └── hikvision-manager.js
├── config/                         # Konfiguratsiya fayllar
│   └── hikvision-config.js
└── public/                         # Frontend fayllar
    ├── index.html                  # Login sahifasi
    ├── employee-login.html         # Hodim login sahifasi
    ├── admin.html                  # Admin panel
    ├── employee-dashboard.html     # Hodim dashboard
    ├── styles.css                  # Login CSS
    ├── admin-styles.css            # Admin CSS
    ├── utils.js                    # Umumiy utility funksiyalar
    ├── login-common.js             # Umumiy login funksiyalar
    ├── admin-script.js             # Admin panel JavaScript
    ├── employee-dashboard-script.js # Hodim dashboard JavaScript
    └── uploads/                    # Yuklangan fayllar
        ├── logos/                  # Logo fayllar
        └── faces/                  # Yuz rasmlari
```

## Texnologiyalar

- **Backend**: Node.js, Express
- **Database**: PostgreSQL
- **Frontend**: HTML, CSS, JavaScript (Vanilla)
- **Authentication**: bcrypt, session-based
- **File Upload**: Multer
- **Integration**: Hikvision ISAPI

## API Endpoints

### Authentication
- `POST /api/login` - Login qilish

### Users
- `GET /api/users` - Barcha foydalanuvchilarni olish
- `POST /api/users` - Yangi foydalanuvchi qo'shish
- `PUT /api/users/:id` - Foydalanuvchini yangilash
- `DELETE /api/users/:id` - Foydalanuvchini o'chirish

### Employees
- `GET /api/employees` - Barcha hodimlarni olish
- `POST /api/employees` - Yangi hodim qo'shish
- `PUT /api/employees/:id` - Hodimni yangilash
- `DELETE /api/employees/:id` - Hodimni o'chirish
- `GET /api/employees/:id/work-schedule` - Hodim ish jadvali
- `POST /api/employees/:id/work-schedule` - Hodim ish jadvali sozlash

### Attendance
- `GET /api/attendance` - Davomat yozuvlari
- `POST /api/attendance` - Davomat yozuvi yaratish
- `GET /api/attendance/today-stats` - Bugungi statistika

### Salaries
- `GET /api/salaries` - Maoshlar ro'yxati
- `POST /api/salaries` - Maosh qo'shish
- `PUT /api/salaries/:id` - Maoshni yangilash
- `DELETE /api/salaries/:id` - Maoshni o'chirish

### Terminals
- `GET /api/terminals` - Terminallar ro'yxati
- `POST /api/terminals` - Terminal qo'shish
- `PUT /api/terminals/:id` - Terminalni yangilash
- `DELETE /api/terminals/:id` - Terminalni o'chirish
- `POST /api/terminals/:id/test` - Terminal ulanishini test qilish
- `POST /api/terminals/:id/sync` - Terminal sinxronizatsiyasi

### Employee Dashboard
- `GET /api/employee/dashboard` - Hodim dashboard ma'lumotlari
- `GET /api/me` - Joriy foydalanuvchi ma'lumotlari

## Hikvision Integratsiyasi

Tizim Hikvision terminallar bilan integratsiya qilingan. Batafsil ma'lumot uchun `README-HIKVISION.md` va `HIKVISION_INTEGRATION.md` fayllarini ko'ring.

## Production Deployment

Production'ga qo'yish uchun `DEPLOYMENT.md` faylini ko'ring.

## Xavfsizlik

- Parollar bcrypt orqali hash qilinadi
- Session-based authentication
- SQL injection himoyasi (parameterized queries)
- XSS himoyasi (HTML escaping)
- File upload validation
- Role-based access control

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Muammolarni Hal Qilish

### Database ulanish muammosi

```bash
# PostgreSQL status
sudo systemctl status postgresql

# Connection test
psql -U postgres -d hodim_nazorati -h localhost
```

### Port band

```bash
# Portni tekshirish
sudo lsof -i :3000

# Processni to'xtatish
kill -9 PID
```

## Yordam va Qo'llab-quvvatlash

Muammo bo'lsa:
1. Server logs: `pm2 logs` yoki console output
2. Database logs: PostgreSQL log fayllari
3. Browser console: Frontend xatoliklari

## License

ISC

## Versiya

1.0.0