
FROM debian:latest

RUN apt update && apt install -y apache2 elinks && rm -rf /var/lib/apt/lists/*

RUN echo "<h1>Pagina Creada desde Dockerfile por jared</h1>" > /var/www/html/jared.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]