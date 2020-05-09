FROM golang:1.14.2

WORKDIR /workspace
COPY conf/openssl.cnf .
RUN cat openssl.cnf >> /etc/ssl/openssl.cnf

# Generates custom root CA
RUN openssl genrsa -out ca.key 2048 \
  && openssl req -new -sha256 -key ca.key -out ca.csr -config /etc/ssl/openssl.cnf -subj /C=DE/ST=Berlin/L=Berlin/O=com.sato11 \
  && openssl x509 -in ca.csr -days 365 -req -signkey ca.key -sha256 -out ca.crt -extfile /etc/ssl/openssl.cnf -extensions CA \
  && rm ca.csr

# Generates server secret key and certificate authenticated by custom root CA
# Note that CN=server is provided. This comes from the service name specified in docker-compose.yml.
RUN openssl genrsa -out server.key 2048 \
  && openssl req -new -nodes -sha256 -key server.key -out server.csr -config /etc/ssl/openssl.cnf -subj /C=DE/ST=Berlin/L=Berlin/O=com.sato11/CN=server \
  && openssl x509 -req -days 365 -in server.csr -sha256 -out server.crt -CA ca.crt -CAkey ca.key -CAcreateserial -extfile /etc/ssl/openssl.cnf -extensions Server \
  && rm server.csr

COPY ./docker-entrypoint.sh /usr/local/bin

EXPOSE 18443

ENTRYPOINT [ "docker-entrypoint.sh" ]
