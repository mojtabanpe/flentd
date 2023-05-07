FROM fluent/fluentd:v1.16-1

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
    sudo build-base ruby-dev \
    && sudo gem install fluent-plugin-elasticsearch \
    && sudo gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY fluent.conf /fluentd/etc/fluent.conf

USER fluent

FROM nginx:1.18
RUN apt-get update 
# RUN apt-get install apache2-utils -y
#     && apt-get install -qqy curl python apt-transport-https apt-utils gnupg1 procps 
# RUN  echo 'deb https://packages.amplify.nginx.com/debian/ stretch amplify-agent' > /etc/apt/sources.list.d/nginx-amplify.list \
#     && curl -fs https://nginx.org/keys/nginx_signing.key | apt-key add - > /dev/null 2>&1 
# RUN apt-get update \
#     && apt-get install -qqy nginx-amplify-agent 
# RUN apt-get purge -qqy curl apt-transport-https apt-utils gnupg1 \
#     && rm -rf /etc/apt/sources.list.d/nginx-amplify.list \
#     && rm -rf /var/lib/apt/lists/*


RUN unlink /var/log/nginx/access.log \
    && unlink /var/log/nginx/error.log \
    && touch /var/log/nginx/access.log \
    && touch /var/log/nginx/error.log \
    && chown nginx /var/log/nginx/*log \
    && chmod 644 /var/log/nginx/*log

# COPY ./nginx/etc/conf.d/stub_status.conf /etc/nginx/conf.d

# COPY ./entrypoint.sh /entrypoint.sh

# RUN ["chmod", "+x", "/entrypoint.sh"]
# RUN ["chmod", "755", "/entrypoint.sh"]
# ENTRYPOINT ["/entrypoint.sh"]
# RUN htpasswd -cb /etc/nginx/.htpasswd mojtaba Chibezaramkhob@
EXPOSE 80/tcp
EXPOSE 443/tcp
WORKDIR /usr/share/nginx/html

