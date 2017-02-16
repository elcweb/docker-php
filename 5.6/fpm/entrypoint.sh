#!/bin/bash

if [ "$SMTP_ENABLE" -eq "1" ]; then
  ### Postfix configuration
  postconf -e "myhostname = ${SMTP_MYHOSTNAME}"
  postconf -e "relayhost = [${SMTP_HOST}]"
  postconf -e 'smtp_sasl_auth_enable = yes'
  postconf -e 'smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd'
  postconf -e 'smtp_sasl_security_options = noanonymous'

  echo "${SMTP_HOST}   ${SMTP_USER}:${SMTP_PASSWORD}" > /etc/postfix/sasl_passwd
  chown root:root /etc/postfix/sasl_passwd
  chmod 600 /etc/postfix/sasl_passwd
  postmap /etc/postfix/sasl_passwd
  service postfix restart
fi

### Start PHP
php-fpm5.6
