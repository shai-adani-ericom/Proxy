FROM securebrowsing/es-proxy-base:200708-23.41

ENV CONTAINERPILOT_VERSION=3.6.2
ENV CONTAINERPILOT_URL="https://github.com/joyent/containerpilot/releases/download/$CONTAINERPILOT_VERSION/containerpilot-$CONTAINERPILOT_VERSION.tar.gz"
ENV CONSULTEMPLATE_VERSION=0.19.5
ENV CONSULTEMPLATE_URL="https://releases.hashicorp.com/consul-template/$CONSULTEMPLATE_VERSION/consul-template_${CONSULTEMPLATE_VERSION}_linux_amd64.tgz"


RUN apk --update-cache upgrade \
    && apk add apache2-utils tzdata && cp /usr/share/zoneinfo/UTC /etc/localtime && echo "UTC" >/etc/timezone \
    && curl --progress-bar -w '%{url_effective}\n' -J -L -o containerpilot-$CONTAINERPILOT_VERSION.tar.gz $CONTAINERPILOT_URL \
    && tar -xzf containerpilot-$CONTAINERPILOT_VERSION.tar.gz -C /usr/bin \
    && rm containerpilot-$CONTAINERPILOT_VERSION.tar.gz \
    && curl --progress-bar -w '%{url_effective}\n' -J -L -o consul-template_$CONSULTEMPLATE_VERSION_linux_amd64.tgz $CONSULTEMPLATE_URL \
    && tar -xzf consul-template_$CONSULTEMPLATE_VERSION_linux_amd64.tgz -C /usr/bin \
    && rm consul-template_$CONSULTEMPLATE_VERSION_linux_amd64.tgz \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/apk/* 

RUN chown -R squid:squid /var/run
RUN chown -R squid:squid /etc
 
COPY configFiles/squid.conf /etc/squid/squid.conf
COPY configFiles/passwords /etc/squid/passwords
ADD config /config

RUN /usr/bin/htpasswd -b /etc/squid/passwords ericom Ericom123$
RUN /usr/bin/htpasswd -b /etc/squid/passwords internal Ericom123$
RUN /usr/bin/htpasswd -b /etc/squid/passwords external Ericom123$
RUN chmod o+w /dev/stdout
EXPOSE 3128
USER squid

ENTRYPOINT ["/bin/sh", "/config/run_squid.sh"]
