FROM ubuntu:22.04

# Create new user and group
RUN useradd -m -s /bin/bash -U user1 -p paV/D3AVahtYk
RUN echo "user1:$(echo '12345678' | openssl passwd -1 -stdin)" | chpasswd -e

# Create new user and group
RUN useradd -m -s /bin/bash -U user2 -p paV/D3AVahtYk
RUN echo "user2:$(echo '12345678' | openssl passwd -1 -stdin)" | chpasswd -e
# Create new user and group
RUN useradd -m -s /bin/bash -U user3 -p paV/D3AVahtYk
RUN echo "user3:$(echo '12345678' | openssl passwd -1 -stdin)" | chpasswd -e
 
# Join user3 to group user1 and user2  
RUN usermod -aG user1 user3
RUN usermod -aG user2 user3

# Update repo 
RUN apt-get update

# Ngnix install and config
RUN apt install -y nginx openssl

# Create directories for public and protected pages
RUN mkdir -p /var/www/public /var/www/protected

# Copy the public and protected pages to the respective directories
COPY pages/public_page/ /var/www/public
COPY pages/protected_page/ /var/www/protected

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Create the htpasswd file for basic authentication
RUN echo "user1:$(openssl passwd -apr1 '12345678')" > /etc/nginx/.htpasswd

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