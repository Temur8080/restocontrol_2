# Hikvision Terminal Integratsiyasi

Bu hujjat Hikvision DS-K1T343MFWX terminalini web ilovaga integratsiya qilish bo'yicha qo'llanma.

## Xususiyatlar

- ✅ Terminal boshqaruvi (qo'shish, tahrirlash, o'chirish)
- ✅ Avtomatik keldi-ketdi yozuvlarini olish (polling)
- ✅ Real-time keldi-ketdi yozuvlarini ko'rish
- ✅ Filtrlash (hodim, terminal, sana, tur bo'yicha)
- ✅ Webhook endpoint terminaldan voqealar qabul qilish uchun

## O'rnatish

### 1. Terminalni sozlash

Hikvision terminalni tarmoqka ulang va quyidagi ma'lumotlarni yozib oling:
- IP manzil (masalan: 192.168.1.100)
- Username (odatda: admin)
- Password (odatda: admin12345)

### 2. Terminalni web ilovaga qo'shish

1. Admin panelga kiring
2. "Terminallar" bo'limiga o'ting
3. "Yangi terminal qo'shish" tugmasini bosing
4. Quyidagi ma'lumotlarni kiriting:
   - **Terminal Nomi**: Masalan "Asosiy Kirish Terminali"
   - **IP Manzil**: Terminal IP manzili (192.168.1.100)
   - **Terminal Turi**: "Kirish" yoki "Chiqish"
   - **Username**: Terminal username (ixtiyoriy)
   - **Password**: Terminal password (ixtiyoriy)
   - **Joylashuv**: Terminal joylashgan joy (ixtiyoriy)
   - **Izoh**: Qo'shimcha ma'lumotlar (ixtiyoriy)

### 3. Environment o'zgaruvchilari

`.env` faylga quyidagi o'zgaruvchini qo'shing (ixtiyoriy):

```env
# Hikvision polling interval (soniyalarda, default: 30)
HIKVISION_POLL_INTERVAL=30
```

## Ishlash prinsipi

### Polling xizmati

Server har 30 soniyada (yoki `.env` da belgilangan interval) barcha faol terminallardan yangi keldi-ketdi yozuvlarini so'raydi.

1. Server Hikvision ISAPI orqali terminalga ulanadi
2. Oxirgi 5 daqiqadagi voqealarni so'raydi
3. Topilgan yozuvlarni bazaga saqlaydi
4. Duplikatlarni tekshiradi va o'tkazib yuboradi

### Webhook endpoint

Agar terminal to'g'ridan-to'g'ri webhook yubora olsa, quyidagi endpointdan foydalaning:

```
POST /api/attendance/webhook
```

**Request body:**
```json
{
  "employee_id": 1,
  "terminal_id": 1,
  "event_type": "entry",
  "event_time": "2024-01-15T10:30:00Z",
  "face_match_score": 95.5,
  "verification_mode": "Face"
}
```

## Hodimlarni terminalga qo'shish

Hodimlarni terminalga qo'shish uchun `employee_faces` jadvalidan foydalaning. Bu jadvalda:
- `employee_id`: Hodim ID
- `terminal_id`: Terminal ID
- `face_template_id`: Terminalda saqlangan yuz template ID

**Eslatma**: Hozircha hodimlarni terminalga qo'shish funksiyasi keyingi versiyada qo'shiladi. Hozirda terminaldan kelgan `face_template_id` yoki `employeeNoString` orqali hodimlarni avtomatik aniqlashga harakat qilinadi.

## Keldi-ketdi yozuvlarini ko'rish

1. Admin panelga kiring
2. "Hodimlar" → "Keldi-ketdi" bo'limiga o'ting
3. Filtrlardan foydalaning:
   - **Hodim**: Ma'lum hodimning yozuvlarini ko'rish
   - **Terminal**: Ma'lum terminaldan kelgan yozuvlar
   - **Tur**: Kirish yoki Chiqish
   - **Boshlang'ich sana**: Sana oralig'i boshlanishi
   - **Tugash sana**: Sana oralig'i tugashi
4. "Qidirish" tugmasini bosing

## API Endpointlar

### Terminallar

- `GET /api/terminals` - Barcha terminallarni olish
- `GET /api/terminals/:id` - Bitta terminalni olish
- `POST /api/terminals` - Yangi terminal qo'shish
- `PUT /api/terminals/:id` - Terminalni yangilash
- `DELETE /api/terminals/:id` - Terminalni o'chirish

### Keldi-ketdi yozuvlari

- `GET /api/attendance` - Keldi-ketdi yozuvlarini olish
  - Query parametrlar: `employee_id`, `terminal_id`, `event_type`, `start_date`, `end_date`, `limit`
- `POST /api/attendance/webhook` - Webhook endpoint (terminaldan voqealar uchun)
- `POST /api/attendance` - Qo'lda yozuv yaratish (adminlar uchun)

## Xatoliklarni tuzatish

### Terminalga ulanib bo'lmayapti

1. Terminal IP manzilini tekshiring
2. Terminal va server bir xil tarmoqda ekanligini tekshiring
3. Terminal username va password to'g'ri ekanligini tekshiring
4. Terminal ISAPI protokoli yoqilganligini tekshiring

### Yozuvlar saqlanmayapti

1. Server loglarini tekshiring
2. Terminal faol ekanligini tekshiring
3. Hodim ID terminalda to'g'ri ekanligini tekshiring
4. Database ulanishini tekshiring

### Polling ishlamayapti

1. Server loglarida "Hikvision polling xizmati ishga tushdi" xabari borligini tekshiring
2. `.env` faylda `HIKVISION_POLL_INTERVAL` o'zgaruvchisi to'g'ri ekanligini tekshiring
3. `hikvision-service.js` fayli mavjudligini tekshiring

## Texnik ma'lumotlar

- **ISAPI versiyasi**: v1.0 va v2.0 qo'llab-quvvatlanadi
- **Polling interval**: Default 30 soniya (sozlash mumkin)
- **Vaqt oralig'i**: Oxirgi 5 daqiqadagi voqealar tekshiriladi
- **Duplikat tekshiruvi**: ±1 daqiqa oralig'ida bir xil yozuvlar o'tkazib yuboriladi

## Keyingi versiyalar

- [ ] Hodimlarni terminalga qo'shish/boshqarish UI
- [ ] Real-time WebSocket orqali yangilanishlar
- [ ] Terminal holatini monitoring
- [ ] Statistika va hisobotlar
- [ ] Ko'p terminal qo'llab-quvvatlash


