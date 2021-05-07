docker run -d \
    --name nextcloud \
    -v nextcloud:/var/www/html \
    -v apps:/var/www/html/custom_apps \
    -v config:/var/www/html/config \
    -v data:/var/www/html/data \
    -p 1280:80 \
    nextcloud
