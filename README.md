
udistrital\_core\_db
====================

Repositorio para la unificación de migraciones de base de datos usando Flyway.

Scope
-----

 - DDL para tablas
   - CREATE TABLE
   - ALTER TABLE
 - DML para inicialización de tablas
   - INSERT INTO
   - SELECT INTO

Fuera de scope
--------------

 - DCL
   - GRANT USER
   - REVOKE USER
 - DDL para esquemas
   - CREATE SCHEMA
 - DML bulk
   - COPY

Requerimientos
--------------

Para ejecución local.

 - Docker
 - Docker Compose

Revisar documento (InstallRequirements.md) para la instalación del Docker y Docker Compose.

Requerimientos para MacOs X
----------------------------

 - `wget --version`
 - `md5sum --version`
 - `psql --version`

Instalación con [Homebrew](http://brew.sh):

 - wget
   - `brew install wget`
 - md5sum
   - `brew install coreutils`
   - `ln -s /usr/local/bin/gmd5sum /usr/local/bin/md5sum`
 - psql
   - `brew install postgresql`

Alternativas a Homebrew.

 - [Macports](https://www.macports.org/)
 - [Fink](http://www.finkproject.org/)
 - Compilación manual (`./configure ; make ; make install`)

¿Cómo funciona esto?
--------------------

### Pruebas locales

Para realizar pruebas locales ejecutar el comando interactivo:

```
./start.sh
```

Esto crea un contenedor Postgres. Y migrará el esquema seleccionado, hasta la versión definida en el archivo `migraciones.conf`.

### Integración continua

El sistema de integración contínua migrará todos los esquemas listados en el directorio `migraciones` uno a la vez en orden lexicográfico y hasta las versiones definidas en el archivo `migraciones.conf`.

#### Ramas procesadas

Las ramas procesadas son:

  - `develop`
  - `master`
  - `ambiente_<<ambiente>>`

La rama `develop` crea el contenedor que se usará en las demás ramas.

La rama `master` se mantiene para pruebas, cada rama `ambiente_<<ambiente>>` se usa para desplegar a ambientes reales.

#### Archivos

Ver:

 - `.drone.yml`
 - `migraciones.conf`
 - `migraciones/###_<<esquema>>.conf`

#### Secretos

##### Generar nuevos secretos

Para generar secretos siga los siguientes pasos:

 1. Importe la llave publica GPG de drone en su keyring (la llave publica está en este repositorio).

    ```
    gpg --import < public.key
    ```

 2. Encriptar

    ```
    echo -n 'SECRETO_AQUI' | gpg -e -r drone@udistritaloas.edu.co - | base64 -w0 ; echo
    ```

 3. Copiar el resultado y utilizarlo en la configuración:

    ```
    COREDB_<<branch>>_PASSWORD="$(enc 'SALIDA_DE_GPG')"
    ```

 4. *Nota*: Solo el poseedor de la llave privada GPG puede desencriptar estos valores.

#### Variables de entorno que afectan la ejecución

 - `COREDB_URL` - Url JDBC a la que Flyway se conectará
 - `COREDB_USER` - Usuario de la base de datos
 - `COREDB_PASSWORD` - Contraseña del usuario de la base de datos
 - `COREDB_SCHEMA_NAME` - Esquema de la base de datos que se va a migrar
 - `COREDB_${SCHEMA_NAME}_TARGET` - Versión en la que se desea tener el esquema indicado

#### Notas sobre implementación

 - El usuario debe tener suficientes privilegios sobre el esquema
 - El administrador de la base de datos debe preparar el esquema y el usuario para ejecutar la migración
 - Se recomienda seguir la siguiente convención:

   ```
   CREATE GROUP <<admin_aplicacion>>;
   CREATE USER <<migraciones_aplicacion>> IN GROUP <<admin_aplicacion>> PASSWORD <<password_migraciones>> ;
   CREATE SCHEMA IF NOT EXISTS <<nombre_aplicacion>> AUTHORIZATION <<admin_aplicacion>>;
   ```

   Reemplazando los valores entre `<<>>` por lo que corresponda.

   Por ejemplo:

   ```
   CREATE GROUP admin_app1;
   CREATE USER migraciones_app1 IN GROUP admin_app1 PASSWORD 'migraciones_app1';
   CREATE SCHEMA IF NOT EXISTS app1 AUTHORIZATION admin_app1;
   ```

#### Volver a comenzar

Ejecutar.

```
./clean.sh
```

#### Errores

*Problema*: `gzip: stdin: unexpected end of file`

*Solución*: Eliminar `./cache/`

```
rm -rf cache
```
