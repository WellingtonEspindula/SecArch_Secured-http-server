# HTTP Server with Basic Authentication

As an assignment of Security Architectures, this project aims to set up an HTTP server with two main pages: a regular public access page and a protected page/service that requires basic authentication. The protected page allows access only to users with valid credentials.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Accessing the Pages](#accessing-the-pages)
- [Configuration Details](#configuration-details)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before getting started, make sure you have the following installed:

- [Docker](https://www.docker.com/)

## Getting Started

First, you should generate the SSL certificate files using the following script. Make sure you have OpenSSL installed.

```bash
./generate_certs.sh
```

To use Docker Compose for running the container and managing secrets:

1. Create password files:
   - `.secrets/user1_password.txt`
   - `.secrets/user2_password.txt`
   - `.secrets/user3_password.txt`
   - `.secrets/private_user_password.txt`

2. Build and run the Docker Compose services:

   ```bash
   docker-compose up --build -d
   ```

## Accessing the Pages

- Regular Public Access Page: [http://localhost](http://localhost)
- Protected Page (Basic Authentication):
  - URL: [http://localhost/protected](http://localhost/protected)
  - Username: `private_user`
  - Password: [private_user_password]

## Configuration Details

The Nginx server is configured with two main pages:

- **Regular Public Access Page:**
  - Location: `/var/www/public`
  - URL: [http://localhost](http://localhost)

- **Protected Page with Basic Authentication:**
  - Location: `/var/www/protected`
  - URL: [http://localhost/protected](http://localhost/protected)
  - Username: `private_user`
  - Password: [private_user_password]

## Troubleshooting

If you have trouble accessing the pages or setting up the server, please refer to the [Troubleshooting](#troubleshooting) section in this README.

## Contributing

Feel free to contribute to this project by opening issues or submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
