# PHP 5.6 Apache (patched)

PHP 5.6 reached end of life in December 2018. php.net no longer ships fixes for it, and the official Docker `php` image stopped at 5.6.40.

This image is for legacy projects that can't move to a supported PHP version yet. It builds PHP 5.6.40 from the official php.net source and adds the security fixes that [Ondřej Surý](https://deb.sury.org/) (deb.sury.org) has backported since 2019.

**This is not a substitute for upgrading.** Move to a [supported PHP version](https://www.php.net/supported-versions.php) as soon as you can.

## Differences from the official `php:5.6-apache` image

| | Official `php:5.6-apache` | This image |
|---|---|---|
| Base OS | Debian stretch (EOL) | Debian bookworm (`debian:bookworm-slim`) |
| Apache | 2.4.25 | 2.4.x from bookworm |
| OpenSSL | 1.0.2 | 3.0 |
| PHP source | php-5.6.40 | php-5.6.40 + 187 patches from deb.sury.org |
| Security fixes after Jan 2019 | None | Backported, including PHP2Shell (CVE-2026-109618, CVE-2026-109619) |
| Bundled SQLite | 3.8.10.2 | 3.28.0 |

`php -v` still reports `5.6.40`. The fixes are applied to the source, but the version number stays the same.

### Security fixes included

The patches in [`patches/`](patches/) are applied in the order listed in [`patches/series`](patches/series). They include:

- **PHP2Shell**, CVE-2026-109618 and CVE-2026-109619 (`0261`), plus the `max_multipart_body_parts` limit it relies on (`0263`, CVE-2023-0662)
- Fixes backported from PHP 7.x and 8.x for exif, phar, iconv, mbstring, SOAP, openssl, crypt/bcrypt, `password_verify`, `FILTER_VALIDATE_URL`, `parse_url`, cookie handling, file uploads, libxml2, PDO, mysqlnd, pgsql, firebird, ZipArchive, and FPM
- OpenSSL 1.1 and 3.0 compatibility (`0055`, `0193`, `0199`)

Some patches only touch tests or the `NEWS` file. They have no effect on the built image, but they keep later patches applying cleanly.

### Patches from sury not included

- **`0251` secure DNS telemetry**: adds an outbound DNS lookup from Apache and FPM to report the installed version. Left out on purpose.
- **`0165`, `0166`, `0169` packaging credits**: deb.sury.org branding in `phpinfo()`.
- **`0001`–`0054` and the build-system patches** (`0057`, `0070`–`0072`, `0077`, `0081`, `0094`, `0134`, `0155`, `0156`, `0162`, `0170`, `0242`–`0247`, `0250`): Debian packaging, autoconf, Windows, and LiteSpeed changes. This build doesn't need them.

## Behavior changes

- **Out-of-memory errors end the Apache worker.** When a request goes over `memory_limit`, the PHP2Shell fix calls `_exit(1)` instead of cleaning up, because the cleanup is what the attack exploits. The fatal error is still logged, but the client gets an empty response instead of a 500 page. Expect more worker restarts in the logs.
- **New INI setting `max_multipart_body_parts`.** Default is `-1`, meaning it's derived from `max_input_vars` + `max_file_uploads`. It limits how many parts a `multipart/form-data` request can have.
- **OpenSSL 3.0.** Legacy ciphers and weak keys or certificates that OpenSSL 1.x accepted may now be rejected. Check any code that does custom crypto or TLS.
- **Compiler flags.** PHP 5.6 doesn't compile cleanly with GCC 12, so the build uses relaxed `CFLAGS` (`-std=gnu99 -fpermissive ...`), a subset of the flags sury uses. They're exported as `PHP_CFLAGS`, so `docker-php-ext-install` uses them too.
- **Extension helper scripts.** `docker-php-ext-configure`, `docker-php-ext-install`, `docker-php-ext-enable` and `docker-php-source` come from the current [docker-library/php](https://github.com/docker-library/php) version, so `-j`, `--ini-name` and `docker-php-ext-enable` work the same way as on the 8.x images. One local change: `docker-php-ext-enable` writes `extension=foo.so` instead of `extension=foo`, because PHP 5.6 can't load an extension by its bare name. The patched source lives at `/usr/src/php.tar.xz` and is unpacked only while extensions are being built.

## Updating the patches

Sury publishes new php5.6 releases at <https://packages.sury.org/php/pool/main/p/php5.6/>. To pick up new fixes:

1. Download the latest `php5.6_5.6.40-*.debian.tar.xz` and extract it.
2. Check `debian/changelog` and compare `debian/patches/series` with [`patches/series`](patches/series).
3. Copy only the new security patches into `patches/` and add them to `patches/series` in the same order. Skip telemetry, branding, and packaging patches.
4. Rebuild. Each patch is applied with `patch -p1 -N`, and the build fails if one doesn't apply.

## Credits

- Security backports by **Ondřej Surý** and contributors at [deb.sury.org](https://deb.sury.org/). Issue tracker: <https://codeberg.org/oerdnj/deb.sury.org>. If this image helps you, consider supporting the work on [GitHub Sponsors](https://github.com/sponsors/oerdnj) or [Patreon](https://www.patreon.com/cw/oerdnj).
- PHP2Shell fix by Arnaud Le Blanc and Ilija Tovilo of the PHP security team, adapted for 5.6 by Ondřej Surý.
- PHP source from [php.net](https://www.php.net/).
