# Alan Adı Mimarisi

## Public
`atabari.live` yalnızca `/`, `/yayincilar`, `/yayinci/:slug`, statik varlıklar ve public API verilerini sunar. Panel rotaları ve özel API uçları 404 döndürür.

## Control
`control.atabari.live` kök rotada giriş ekranını gösterir. Auth, rol bazlı API'ler, şifre sıfırlama ve ekip paneli burada çalışır. Arama motoru indekslemesi engellenir.

## Not
Alt alan adını gizlemek güvenlik mekanizması değildir. Kimlik doğrulama ve yetkilendirme sunucu tarafında uygulanır.
