FROM moodlehq/moodle-php-apache:8.2-bullseye

# Entrypoint propio: corre DESPUÉS de los scripts y asegura 1 solo MPM
RUN set -eux; \
  cat > /usr/local/bin/railway-entrypoint.sh <<'EOF' ; \
#!/usr/bin/env bash
set -e

# 1) Corre los scripts estándar (los que ya ves en logs)
if [ -d /docker-entrypoint.d ]; then
  for f in /docker-entrypoint.d/*; do
    case "$f" in
      *.sh)
        if [ -x "$f" ]; then
          "$f"
        else
          . "$f"
        fi
        ;;
    esac
  done
fi

# 2) BLINDAJE: deja SOLO prefork en mods-enabled (elimina cualquier otro MPM)
rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf || true
ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

# 3) Arranca Apache en foreground
exec apache2-foreground
EOF
  chmod +x /usr/local/bin/railway-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
