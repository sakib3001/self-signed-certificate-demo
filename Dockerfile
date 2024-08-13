# Base Stage
FROM ubuntu:22.04 as base

WORKDIR /base

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    iputils-ping \
    curl 

# Server Stage
FROM base as server

WORKDIR /server 
RUN apt-get install -y --no-install-recommends \
    nginx \
    openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -newkey rsa:2048 -keyout /etc/nginx/ssl/private.key -out /etc/nginx/ssl/certificate.crt -days 365 -nodes -subj "/CN=server"

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]

# Client Stage
FROM base as client 

WORKDIR /client 
RUN apt install -y ca-certificates
COPY --from=server /etc/nginx/ssl/certificate.crt .

CMD ["sleep", "infinity"]
