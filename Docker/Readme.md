# Comandos de Docker-Compose

Para levantar un entorno de `docker-compose` usaremos el atributo `up`

```powershell
docker-compose up -d
```

Para apagar el entorno usaremos el atributo `down`
> Si queremos eliminar también los volumenes creados, usaremos `-v`

```powershell
docker-compose down -v
```