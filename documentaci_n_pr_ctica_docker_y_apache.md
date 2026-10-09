# Pasos Realizados: Práctica de Docker y Apache

**Alumno:** Jared  
**Módulo:** Implantación de Aplicaciones Web (IAW)  

---

## 1. Documentar los pasos seguidos
Este documento recopila de manera detallada todos los procedimientos, comandos e instrucciones ejecutados a lo largo de la práctica en el archivo `Pasos-realizados.md`.

---

## 2. Descargar la imagen de Debian desde Docker Hub
Se descargó la última versión oficial de la imagen base de Debian ejecutando en el equipo host:

```bash
docker pull debian:latest
```

---

## 3. Arrancar contenedor interactivo, desacoplado y con terminal
Se inició un contenedor asignándole el nombre `servidor_apache`, mapeando el puerto 8080 del anfitrión al puerto 80 del contenedor, de forma interactiva (`-i`), con TTY (`-t`) y en modo desvinculado/desacoplado (`-d`):

```bash
docker run -d -i -t --name servidor_apache -p 8080:80 debian:latest
```

---

## 4. Ejecutar una shell Bash en el contenedor
Se accedió a la terminal interactiva del contenedor en ejecución mediante:

```bash
docker exec -it servidor_apache bash
```

---

## 5. Instalar el paquete de Apache2
Una vez dentro del contenedor (`root@...:/#`), se actualizaron los repositorios locales y se realizó la instalación del servidor web Apache:

```bash
apt update && apt install -y apache2
```

---

## 6. Arrancar el servicio Apache
Se procedió a iniciar el servicio de Apache2 dentro de la instancia de Debian:

```bash
service apache2 start
```

---

## 7. Comprobar la respuesta del servidor web desde el navegador
Desde el navegador del sistema anfitrión, se verificó el acceso a la página por defecto de Apache cargando la URL:

```text
http://localhost:8080
```

---

## 8. Crear una página HTML personalizada
Dentro de la raíz de documentos de Apache (`/var/www/html`), se generó un archivo HTML con un título personalizado:

```bash
echo "<h1>Pagina Creada por jared</h1>" > /var/www/html/jared.html
```

---

## 9. Acceder a la página desde el navegador gráfico
Se comprobó la correcta renderización del archivo creado ingresando en el navegador del equipo host a:

```text
http://localhost:8080/jared.html
```

---

## 10. Acceder a la página mediante el navegador en línea de comandos `elinks`
Para verificar la respuesta HTTP directamente desde la terminal del contenedor:

1. Se instaló el navegador de texto `elinks`:
   ```bash
   apt update && apt install -y elinks
   ```
2. Se consultó la página HTML creada (en el puerto 80 interno):
   ```bash
   elinks http://localhost/jared.html
   ```

---

## 11. Crear un `Dockerfile` para automatizar los pasos anteriores
En la carpeta local del proyecto (`Practica IAW Docker y apache`), se creó un archivo llamado `Dockerfile` con la siguiente configuración:

```dockerfile
FROM debian:latest

# Actualizar e instalar Apache2 y elinks en una sola capa
RUN apt update && apt install -y apache2 elinks && rm -rf /var/lib/apt/lists/*

# Crear la página web personalizada dentro de la imagen
RUN echo "<h1>Pagina Creada desde Dockerfile por jared</h1>" > /var/www/html/jared.html

# Exponer el puerto web
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apache2ctl", "-D", "FOREGROUND"]
```

---

## 12. Crear la imagen a partir del `Dockerfile`
Desde la terminal del equipo host (PowerShell) en la carpeta del proyecto, se construyó la imagen asignándole el nombre y etiqueta `mi_apache_jared:1.0`:

```powershell
docker build -t mi_apache_jared:1.0 .
```

---

## 13. Ejecutar el contenedor basado en la nueva imagen
Se desplegó un nuevo contenedor denominado `apache_dockerfile` exponiendo el servicio en el puerto `8081` del host:

```powershell
docker run -d -p 8081:80 --name apache_dockerfile mi_apache_jared:1.0
```

Se verificó el acceso abriendo en el navegador:
```text
http://localhost:8081/jared.html
```

---

## 14. Copiar un archivo local a un contenedor (`docker cp`)
Para transferir un archivo desde el sistema de archivos de Windows hacia el interior de un contenedor en ejecución:

1. Se creó localmente el archivo `jared.html`:
   ```powershell
   echo "<h1>Pagina local creada en Windows por jared</h1>" > jared.html
   ```
2. Se envió el archivo al contenedor `servidor_apache`:
   ```powershell
   docker cp jared.html servidor_apache:/var/www/html/jared_copiado.html
   ```
3. Se verificó desde el navegador accediendo a `http://localhost:8080/jared_copiado.html`.

---

## 15. Crear el archivo `docker-compose.yml` con volumen mapeado
Se creó el archivo de orquestación `docker-compose.yml` para enlazar el directorio local del host directamente con la raíz de documentos de Apache (`/var/www/html`):

```yaml
services:
  web:
    image: debian:latest
    container_name: apache_compose
    ports:
      - "8082:80"
    volumes:
      - .:/var/www/html
    command: >
      bash -c "apt update && 
               apt install -y apache2 && 
               apache2ctl -D FOREGROUND"
```

Se inició el entorno con Docker Compose:

```powershell
docker compose up -d
```

Se comprobó la vinculación del volumen accediendo a `http://localhost:8082/jared.html`.