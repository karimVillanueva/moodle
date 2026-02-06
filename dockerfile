FROM moodlehq/moodle-php-apache:8.2-bullseye

# En Debian/Apache solo puede haber 1 MPM activo.
# Para mod_php el recomendado es prefork.
RUN a2dismod mpm_event mpm_worker || true \
 && a2enmod mpm_prefork
