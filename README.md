# HTTP Server with Basic Authentication

As an assignment of Security Architectures, this project aims to setup an HTTP server with two main pages: a regular public access page and a protected page/service that requires basic authentication. The protected page allows access only to users with valid credentials.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Building the Docker Image](#building-the-docker-image)
  - [Running the Docker Container](#running-the-docker-container)
- [Accessing the Pages](#accessing-the-pages)
- [Configuration Details](#configuration-details)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before getting started, make sure you have the following installed:

- [Docker](https://www.docker.com/)

## Getting Started

### Building the Docker Image

First, you should generate the SSL certificate files using the following script. Make sure you have OpenSSL installed.

```bash
./generate_certs.sh
```

```bash
docker build -t my-nginx-image .
```

### Running the Docker Container

```bash
docker run -p 80:80 -p 443:443 --secret nginx_htpasswd my-nginx-image
```

## Accessing the Pages

- Regular Public Access Page: [http://localhost](http://localhost)
- Protected Page (Basic Authentication):
  - URL: [http://localhost/protected](http://localhost/protected)
  - Username: `username`
  - Password: `12345678`

## Configuration Details

The Nginx server is configured with two main pages:

- **Regular Public Access Page:**
  - Location: `/var/www/public`
  - URL: [http://localhost](http://localhost)

- **Protected Page with Basic Authentication:**
  - Location: `/var/www/protected`
  - URL: [http://localhost/protected](http://localhost/protected)
  - Username: `username`
  - Password: `12345678`

## Troubleshooting

If you have trouble accessing the pages or setting up the server, please refer to the [Troubleshooting](#troubleshooting) section in this README.

## Contributing

Feel free to contribute to this project by opening issues or submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

