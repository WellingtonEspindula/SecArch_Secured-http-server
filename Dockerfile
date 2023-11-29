FROM ubuntu:22.04

# Update repo 
RUN apt-get update

# Install openssl
RUN apt install -y openssl

# # Mounts the secret, hash it and save the new hashed passworrd
# RUN --mount=type=secret,id=private_user_password,target=/run/secrets/private_user_password echo "user1:$(cat /run/secrets/private_user_password | openssl passwd -6 -stdin)" >&2

# Create new user and group
RUN useradd -m -s /bin/bash -U user1 -p paV/D3AVahtYk
# RUN --mount=type=secret,id=user1_password,target=/run/secrets/user1_password \ 
#     echo "user1:$(cat /run/secrets/user1_password | openssl passwd -6 -stdin)" >&2

RUN --mount=type=secret,id=user1_password,target=/run/secrets/user1_password \ 
    echo "user1:$(cat /run/secrets/user1_password | openssl passwd -6 -stdin)" | chpasswd -e

# Create new user and group
RUN useradd -m -s /bin/bash -U user2 -p paV/D3AVahtYk
RUN --mount=type=secret,id=user2_password,target=/run/secrets/user2_password \ 
    echo "user2:$(cat /run/secrets/user2_password | openssl passwd -6 -stdin)" | chpasswd -e

# Create new user and group
RUN useradd -m -s /bin/bash -U user3 -p paV/D3AVahtYk
RUN --mount=type=secret,id=user3_password,target=/run/secrets/user3_password \ 
     echo "user3:$(cat /run/secrets/user3_password | openssl passwd -6 -stdin)" | chpasswd -e
 
# Join user3 to group user1 and user2  
RUN usermod -aG user1 user3
RUN usermod -aG user2 user3

# Ngnix install and config
RUN apt install -y nginx

# Create directories for public and protected pages
RUN mkdir -p /var/www/public /var/www/protected

# Copy the public and protected pages to the respective directories
COPY pages/public_page/ /var/www/public
COPY pages/protected_page/ /var/www/protected

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Create the htpasswd file for basic authentication
RUN --mount=type=secret,id=private_user_password,target=/run/secrets/private_user_password \ 
    echo "private_user:$(cat /run/secrets/private_user_password | openssl passwd -6 -stdin)" > /etc/nginx/.htpasswd

# Create a directory for certificates
RUN mkdir -p /etc/nginx/certs

# Copy the self-signed certificates
COPY certs/server.crt /etc/nginx/certs/
COPY certs/server.key /etc/nginx/certs/

# Expose ports
EXPOSE 80
EXPOSE 443

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]