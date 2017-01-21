# docker-adminer-gen

An adminer plugin that adds a list of persistent logins to tagged database containers.

This image provides two files in `/data`: the plugin file, and the json data for the containers. This json file is every 30 seconds. Make sure this file is not in a location that is web-reachable, as it contains passwords.

In addition, if the environment variable `MOUNT_AT` is set, the plugin file and the container data will be copied to the given path. This can be used to make them available on shared volumes from your adminer container.

## Usage

It is advised to use this image in conjunction with [maienm/adminer](https://hub.docker.com/r/maienm/adminer).  This image makes it easy to add plugins (such as this one), and it contains everything necessary for the database types supported by this image.

### Example with maienm/adminer

```bash
docker run \
--name adminer \
--restart unless-stopped \
-d \
-e "ENABLED_PLUGINS=AdminerDockerLinks" \
maienm/adminer

docker run \
--name adminer-gen \
--restart unless-stopped \
-d \
--link adminer:adminer \
--volumes-from adminer \
-v /var/run/docker.sock:/var/run/docker.sock:ro \
-e "MOUNT_AT=/plugins/docker-gen" \
maienm/adminer-gen
```

## Detection

The following environment variables, set on the database container, are used to detect database containers:

name               | description
---                | ---
`ADMINER_NAME`     | Required. The name displayed in the adminer interface.
`ADMINER_TYPE`     | Autodetect. The database type. Valid options: firebird, mongodb, mssql, mysql, oracle, postgres.
`ADMINER_HOST`     | Autodetect. Hostname/ip that the adminer container can use to access the database.
`ADMINER_PORT`     | Autodetect. Port that the adminer container can use to access the database.
`ADMINER_USER`     | Autodetect. Username for the database.
`ADMINER_PASS`     | Autodetect. Password for the database.
`ADMINER_DATABASE` | Autodetect. For database types that support having multiple databases in one instance, the database to default to.

The autodetected fields are based on environment variables use by some of the more popular/the official images for the databases. If autodetection does not seem to work for you, just set the `ADMINER_*` environment variable.
