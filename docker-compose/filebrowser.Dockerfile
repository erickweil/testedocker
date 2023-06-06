FROM filegator/filegator



ARG UID=1000

ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data

USER root
RUN usermod -u ${UID} www-data
RUN groupmod -g ${UID} www-data

USER www-data
