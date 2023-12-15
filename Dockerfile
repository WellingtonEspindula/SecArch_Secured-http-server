FROM ubuntu:22.04

# Update repo 
RUN apt-get update

# Install openssl
RUN apt install -y openssl

# Create new user and group
RUN useradd -s /bin/bash -U user1
RUN --mount=type=secret,id=user1_password,target=/run/secrets/user1_password \ 
    echo "user1:$(cat /run/secrets/user1_password | openssl passwd -6 -stdin)" | chpasswd -e

# Create new user and group
RUN useradd -m -s /bin/bash -U user2
RUN --mount=type=secret,id=user2_password,target=/run/secrets/user2_password \ 
    echo "user2:$(cat /run/secrets/user2_password | openssl passwd -6 -stdin)" | chpasswd -e

# Create new user and group
RUN useradd -m -s /bin/bash -U user3
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

RUN adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx
RUN chown -R nginx:nginx /var/log/nginx && \
    chmod -R 00660 /var/log/nginx && \
    chmod 770 /var/log/nginx

RUN chown -R nginx:nginx /var/lib/nginx && \
    chmod -R 00660 /var/lib/nginx && \
    chmod 770 /var/lib/nginx 


# RUN chown -R nginx:nginx /var/cache/nginx \
#  && chmod -R g+w /var/cache/nginx \
#  && touch /var/run/nginx.pid \
#  && chown -R nginx:nginx /var/run/nginx.pid \
#  && ln -sf /dev/stdout /var/log/nginx/access.log \
#  && ln -sf /dev/stderr /var/log/nginx/error.log

RUN usermod -aG nginx user1

# RUN apt install -y openssh-server
# RUN mkdir /var/run/sshd

# RUN rm -f /home/user1/.ssh/id*
# COPY .ssh/id_rsa.pub /home/user1/.ssh/authorized_keys

# RUN chmod 600 /home/user1/.ssh/authorized_keys && \
#     chown user1:user1 /home/user1/.ssh/authorized_keys

# RUN sed -i 's/^#Port.*/Port 22/' /etc/ssh/sshd_config
# RUN sed -i 's/^#AddressFamily.*/AddressFamily any/' /etc/ssh/sshd_config
# RUN sed -i 's/^#ListenAddress 0.0.0.0.*/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
# RUN sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
# RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
# RUN sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config


# COPY ./libModSecurity.sh /tmp/libModSecurity.sh

# RUN cd /tmp && \
#     chmod +x libModSecurity.sh && \
#     ./libModSecurity.sh

# Add supervisor to run HTTP and SSH in the same container
RUN apt install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN touch /supervisor.log && \
    chown user1:user1 /supervisor.log && \
    chmod 660 /supervisor.log

RUN touch /supervisord.log && \
    chown user1:user1 /supervisord.log && \
    chmod 660 /supervisord.log

RUN touch /supervisord.pid && \
    chown user1:user1 /supervisord.pid && \
    chmod 660 /supervisord.pid

RUN apt update \
    && apt -y upgrade \
    && apt purge -y --auto-remove \
    && apt clean

# Expose ports
EXPOSE 22 8080 4443

# Start Nginx and SSH in the foreground
CMD ["/usr/bin/supervisord","-c", "/etc/supervisor/conf.d/supervisord.conf"]

USER user1