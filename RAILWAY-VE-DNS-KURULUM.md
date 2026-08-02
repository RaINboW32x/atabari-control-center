# Railway ve Natro DNS kurulumu — atabari.live

## Kullanılacak adresler

- Herkese açık site: `https://atabari.live`
- Control Center: `https://control.atabari.live`
- Şifre sıfırlama bağlantıları: `https://control.atabari.live/reset-password/...`

## Railway Variables

Uygulama servisinin **Variables** bölümünde aşağıdaki değerleri kullanın:

```env
PUBLIC_HOST=atabari.live
CONTROL_HOST=control.atabari.live
APP_URL=https://control.atabari.live
NODE_ENV=production

ADMIN_USERNAME=owner
ADMIN_PASSWORD=GUCLU_BIR_ILK_SIFRE
ADMIN_EMAIL=yonetim@atabari.live
SESSION_SECRET=UZUN_RASTGELE_BIR_DEGER
```

Mevcut `DATABASE_URL` ve SMTP değişkenlerini koruyun.

Natro e-posta hesabınız farklı bir adresteyse `ADMIN_EMAIL`, `SMTP_USER` ve `EMAIL_FROM` alanlarında gerçek posta adresinizi kullanın.

## Railway özel alan adları

Uygulama servisi içinde **Settings → Networking → Custom Domain** bölümüne iki alan adı ekleyin:

1. `atabari.live`
2. `control.atabari.live`

Railway her alan adı için eklenmesi gereken DNS hedefini gösterecektir. Natro DNS paneline Railway'in gösterdiği kayıtları aynen girin.

## Natro DNS kayıtları

`control` alt alan adı için genel yapı şöyledir:

```text
Tür: CNAME
Ad/Host: control
Hedef: Railway'in verdiği hedef
TTL: Otomatik veya varsayılan
```

Kök alan adı `atabari.live` için Railway ve Natro panelinin desteklediği yönteme göre `CNAME flattening`, `ALIAS` veya Railway'in verdiği kayıt kullanılmalıdır. Railway ekranındaki hedef esas alınmalıdır.

Mevcut e-posta hizmetinin bozulmaması için MX, SPF, DKIM ve DMARC kayıtlarını silmeyin veya değiştirmeyin.

## Deploy sonrası test

Aşağıdaki adresleri kontrol edin:

```text
https://atabari.live
https://control.atabari.live
https://control.atabari.live/api/health
```

Beklenen davranış:

- `atabari.live`: herkese açık ziyaretçi sitesi, giriş bağlantısı yok.
- `control.atabari.live`: ekip giriş ekranı.
- `/api/health`: uygulama ve PostgreSQL durumu.

## Şifre sıfırlama

E-posta bağlantılarının doğru alan adından oluşturulması için:

```env
APP_URL=https://control.atabari.live
```

mutlaka tanımlı olmalıdır.
