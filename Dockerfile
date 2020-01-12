FROM alpine
ENV VERSION=4_8
RUN wget https://github.com/squid-cache/squid/archive/SQUID_${VERSION}.tar.gz -O squid.tar.gz \
    && tar -xvf squid.tar.gz \
    && cd squid-SQUID_${VERSION}
RUN apk add libtool ed build-base autoconf 
RUN wget https://ftp.gnu.org/gnu/automake/automake-1.15.tar.gz \
    && tar -xzvf automake-1.15.tar.gz \
    && cd automake-1.15 \
    && ./bootstrap.sh \
    && ./configure \
    && make \
    && make install
WORKDIR squid-SQUID_${VERSION}
RUN ./bootstrap.sh \
    && ln -s /usr/bin/aclocal-1.16 /usr/bin/aclocal-1.15 \
    && ./configure --prefix=/usr/local/squid \
    && make all \
    && make install 

FROM alpine
ENV VERSION=4.8
COPY --from=0 /usr/local/squid /usr/local/squid
WORKDIR /usr/local/squid
CMD ['/usr/local/squid/sbin/squid']
