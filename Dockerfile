FROM moodlehq/moodle-php-apache:8.2-bullseye

# Crea un entrypoint propio que fuerza 1 solo MPM y luego llama al entrypoint original
RUN set -eux; \
  cat > /usr/local/bin/railway-entrypoint.sh <<'EOF' ; \
#!/usr/bin/env bash
set -e

# Fuerza un solo MPM (prefork)
a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

# Llama al entrypoint original de la imagen (PHP) con el comando original
exec /usr/local/bin/docker-php-entrypoint "$@"
EOF
  chmod +x /usr/local/bin/railway-entrypoint.sh

# Sobrescribe ENTRYPOINT para garantizar que SIEMPRE corra primero
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]

# Mantén el CMD original (apache2-foreground)
CMD ["apache2-foreground"]
