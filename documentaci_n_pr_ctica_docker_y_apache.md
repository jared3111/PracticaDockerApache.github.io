<img width="776" height="341" alt="Captura de pantalla 2026-10-09 184803" src="https://github.com/user-attachments/assets/d299a711-5a9d-4976-be28-ecbb7d49d513" />
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
<img width="776" height="341" alt="Captura de pantalla 2026-10-09 184803" src="https://github.com/user-attachments/assets/f476d3e2-c35d-4871-8183-9caf08823fa3" />


---

## 3. Arrancar contenedor interactivo, desacoplado y con terminal
Se inició un contenedor asignándole el nombre `servidor_apache`, mapeando el puerto 8080 del anfitrión al puerto 80 del contenedor, de forma interactiva (`-i`), con TTY (`-t`) y en modo desvinculado/desacoplado (`-d`):

```bash
docker run -d -i -t --name servidor_apache -p 8080:80 debian:latest
```
<img width="776" height="344" alt="Captura de pantalla 2026-10-09 185036" src="https://github.com/user-attachments/assets/2cecf322-e4a9-407c-80ee-61d0d97db7a1" />

---

## 4. Ejecutar una shell Bash en el contenedor
Se accedió a la terminal interactiva del contenedor en ejecución mediante:

```bash
docker exec -it servidor_apache bash
```
<img width="780" height="347" alt="Captura de pantalla 2026-10-09 185133" src="https://github.com/user-attachments/assets/0623a211-bb1c-4c9e-96b3-aaaa8fb111d9" />

---

## 5. Instalar el paquete de Apache2
Una vez dentro del contenedor (`root@...:/#`), se actualizaron los repositorios locales y se realizó la instalación del servidor web Apache:

```bash
apt update && apt install -y apache2
```
<img width="776" height="321" alt="Captura de pantalla 2026-10-09 185308" src="https://github.com/user-attachments/assets/a1b89431-6314-4e36-9f1e-a7f2ef6ee3e2" />

---

## 6. Arrancar el servicio Apache
Se procedió a iniciar el servicio de Apache2 dentro de la instancia de Debian:

```bash
service apache2 start
```
<img width="777" height="151" alt="Captura de pantalla 2026-10-09 185356" src="https://github.com/user-attachments/assets/313962eb-ee7e-474f-924a-e937946d9eb8" />

---

## 7. Comprobar la respuesta del servidor web desde el navegador
Desde el navegador del sistema anfitrión, se verificó el acceso a la página por defecto de Apache cargando la URL:

```text
http://localhost:8080
```
<img width="952" height="1039" alt="Captura de pantalla 2026-10-09 185435" src="https://github.com/user-attachments/assets/a0d641f5-cf44-4583-ac6f-aadb053e4439" />

---

## 8. Crear una página HTML personalizada
Dentro de la raíz de documentos de Apache (`/var/www/html`), se generó un archivo HTML con un título personalizado:

```bash
echo "<h1>Pagina Creada por jared</h1>" > /var/www/html/jared.html
```
<img width="773" height="54" alt="Captura de pantalla 2026-10-09 190231" src="https://github.com/user-attachments/assets/ff8902d2-d9f9-435e-8fd4-f81ee840b2ef" />

---

## 9. Acceder a la página desde el navegador gráfico
Se comprobó la correcta renderización del archivo creado ingresando en el navegador del equipo host a:

```text
http://localhost:8080/jared.html
```
<img width="953" height="1010" alt="Captura de pantalla 2026-10-09 190323" src="https://github.com/user-attachments/assets/1911f5fa-7ac3-45b6-bdf9-9decd46c43eb" />

---

## 10. Acceder a la página mediante el navegador en línea de comandos `elinks`
Para verificar la respuesta HTTP directamente desde la terminal del contenedor:

1. Se instaló el navegador de texto `elinks`:
   ```bash
   apt update && apt install -y elinks
   ```
   <img width="772" height="338" alt="Captura de pantalla 2026-10-09 190441" src="https://github.com/user-attachments/assets/508938d0-3ca8-4770-baee-c26ddd141b98" />

2. Se consultó la página HTML creada (en el puerto 80 interno):
   ```bash
   elinks http://localhost/jared.html
   ```
<img width="790" height="314" alt="Captura de pantalla 2026-10-09 19041" src="https://github.com/user-attachments/assets/399d8454-d70c-4e4a-989a-75a7628c14ec" />
<img width="628" height="40" alt="Captura de pantalla 2026-10-09 190836" src="https://github.com/user-attachments/assets/10d5c033-1d7b-4ba8-94e2-4dfd8891bc74" />


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
<img width="863" height="323" alt="Captura de pantalla 2026-10-09 191331" src="https://github.com/user-attachments/assets/4f31124a-969b-45d0-ad30-0c7d40e2af19" />

---

## 12. Crear la imagen a partir del `Dockerfile`
Desde la terminal del equipo host (PowerShell) en la carpeta del proyecto, se construyó la imagen asignándole el nombre y etiqueta `mi_apache_jared:1.0`:

```powershell
docker build -t mi_apache_jared:1.0 .
```
<img width="782" height="317" alt="Captura de pantalla 2026-10-09 191939" src="https://github.com/user-attachments/assets/9faa8efb-76c7-4940-990d-9e35c8417112" />

---

## 13. Ejecutar el contenedor basado en la nueva imagen
Se desplegó un nuevo contenedor denominado `apache_dockerfile` exponiendo el servicio en el puerto `8081` del host:

```powershell
docker run -d -p 8081:80 --name apache_dockerfile mi_apache_jared:1.0
```
<img width="779" height="70" alt="Captura de pantalla 2026-10-09 192107" src="https://github.com/user-attachments/assets/4c549e75-a293-483b-b9a7-bdb756deb554" />

Se verificó el acceso abriendo en el navegador:
```text
http://localhost:8081/jared.html
```
<img width="872" height="604" alt="Captura de pantalla 2026-10-09 194737" src="https://github.com/user-attachments/assets/42ee1a00-6e4a-4343-b507-0dc5b2e34427" />

---

## 14. Copiar un archivo local a un contenedor (`docker cp`)
Para transferir un archivo desde el sistema de archivos de Windows hacia el interior de un contenedor en ejecución:

1. Se creó localmente el archivo `jared.html`:
   ```powershell
   echo "<h1>Pagina local creada en Windows por jared</h1>" > jared.html
   ```
   <img width="653" height="71" alt="Captura de pantalla 2026-10-09 192455" src="https://github.com/user-attachments/assets/fbc7d80a-4c4a-43b1-b75b-bf0bbfa2b5e0" />

2. Se envió el archivo al contenedor `servidor_apache`:
   ```powershell
   docker cp jared.html servidor_apache:/var/www/html/jared_copiado.html
   ```
  <img width="772" height="102" alt="Captura de pantalla 2026-10-09 192300" src="https://github.com/user-attachments/assets/91b69f1d-b80e-4de5-9fe9-1cfaf62f36d3" />

3. Se verificó desde el navegador accediendo a `http://localhost:8080/jared_copiado.html`.

---
<img width="953" height="1007" alt="Captura de pantalla 2026-10-09 192548" src="https://github.com/user-attachments/assets/8663c5c0-dcbd-4474-8dcd-e4d5b9d8cc0e" />

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
<img width="951" height="578" alt="Captura de pantalla 2026-10-09 192640" src="https://github.com/user-attachments/assets/95ddb394-131c-42d5-9240-cf5feda51115" />

Se inició el entorno con Docker Compose:

```powershell
docker compose up -d
```
<img width="772" height="131" alt="Captura de pantalla 2026-10-09 192741" src="https://github.com/user-attachments/assets/1386ba03-6496-4e2b-b277-685e00e64479" />

Se comprobó la vinculación del volumen accediendo a `http://localhost:8082/jared.html`.

<img width="950" height="1013" alt="Captura de pantalla 2026-10-09 192844" src="https://github.com/user-attachments/assets/6ddddd8b-f43b-4a21-99df-329d763125f2" />
