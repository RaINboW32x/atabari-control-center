# ATABARI Control Center v4.0 Alpha — Ayrı Public Site ve Control Center

Bu depo tek bir Node.js/Railway servisi üzerinde iki farklı alan adı sunar:

- `https://atabari.live` — izleyicilere açık site; giriş bağlantısı içermez.
- `https://control.atabari.live` — ekip girişi ve rol bazlı Control Center.

İki alan adı aynı PostgreSQL verisini kullanır. Host tabanlı yönlendirme sayesinde public alan adında özel API uçları ve panel sayfaları sunulmaz. Control alan adı `X-Robots-Tag: noindex` ve ayrı `robots.txt` ile arama motorlarından gizlenir. Bu ayrım güvenliği destekler; gerçek koruma güçlü parolalar, güvenli oturumlar, hız sınırları ve güncel yazılım ile sağlanır.

## Roller

- **Owner**: kullanıcı ve rol yönetimi dahil tam yetki.
- **Administrator**: yayın, sponsor ve operasyon yönetimi.
- **Moderator**: operasyon ve sponsor takibi.
- **Streamer**: kendi yayınları, profili ve Sponsor Asistanı.
- **Visitor**: giriş yapmadan public siteyi görür.

## Railway değişkenleri

```env
DATABASE_URL=${{Postgres.DATABASE_URL}}
PUBLIC_HOST=atabari.live
CONTROL_HOST=control.atabari.live
APP_URL=https://control.atabari.live
ADMIN_USERNAME=owner
ADMIN_PASSWORD=GUCLU_BIR_ILK_SIFRE
ADMIN_EMAIL=yonetim@atabari.live
SESSION_SECRET=uzun-rastgele-deger
NODE_ENV=production
```

Natro SMTP kullanırken `.env.example` içindeki SMTP değişkenlerini Railway'e ekleyin.

## Domain kurulumu

Railway uygulama servisinde **Settings → Networking → Custom Domain** bölümüne hem `atabari.live` hem `control.atabari.live` eklenir. Natro DNS panelinde Railway'in verdiği CNAME/ALIAS kayıtları tanımlanır.

## İlk Owner

Uygulama ilk kez açılırken `ADMIN_USERNAME`, `ADMIN_PASSWORD` ve `ADMIN_EMAIL` değerlerinden bir Owner oluşturur. Veritabanında aynı kullanıcı zaten varsa parolası otomatik değiştirilmez; e-posta sıfırlama kullanılır.

## Güncelleme

ZIP içeriğini GitHub deposunun köküne kopyalayın, commit ve push yapın. Railway otomatik deploy eder.
