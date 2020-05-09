# go-TLS-demo
Run `docker-compose up` and to see TLS server starts, with which `curl` and golang client communicate over TLS.

## Under the hood
docker-compose wraps functionalities like:
- Create a root CA and have it issue a server certificate.
- Share the root CA certificate via docker volumes so that clients can use it when requesting.
- `curl` uses `--cacert` option to verify custom root CA certificate.
- Go client also verifies the custom root CA certificate using `crypto/tls` package.
