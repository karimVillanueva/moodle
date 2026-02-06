FROM moodlehq/moodle-php-apache:8.2-bullseye

# Script que fuerza 1 solo MPM justo antes de arrancar Apache
RUN set -eux; \
  cat > /usr/local/bin/railway-start.sh <<'EOF' ; \
#!/usr/bin/env bash
set -e

# Forzar 1 solo MPM: prefork (recomendado con mod_php)
a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

# Arranque estándar de la imagen (respeta su entrypoint)
exec apache2-foreground
EOF
  chmod +x /usr/local/bin/railway-start.sh
