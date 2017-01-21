# docker-adminer-gen

An adminer plugin that adds a list of persistent logins to tagged database containers.

This image provides two files in `/data`: the plugin file, and the json data for the containers. This json file is
every 30 seconds. Make sure this file is not in a location that is web-reachable, as it contains passwords.

In addition, if the environment variable `MOUNT_AT` is set, the plugin file and the container data will be copied to
the given path. This can be used to make them available on shared volumes from your adminer container.

## Usage

It is advised to use this image in conjunction with [MaienM/docker-adminer](https://github.com/MaienM/docker-adminer).
This image makes it easy to add plugins (such as this one), and it contains everything necessary for the database
types supported by this image.

### Example with MaienM/docker-adminer

```bash
docker run \
--name adminer \
--restart unless-stopped \
-d \
-e "ENABLE_PLUGINS=AdminerDockerLinks" \
-v ${PWD}/plugins.php:/plugins/load.php:ro \
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
