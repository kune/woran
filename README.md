Watch OCR Rename move and Announce to NextCloud

Volumes: 

/input: The input directory to watch
/nextcloud_root: The nextcloud data root directory, e.g. /var/www/html/data
/var/run/docker.sock: The docker socket, needs to be mapped to host's /var/run/docker.sock
/etc/localtime: The timezone config, needs to be mapped to host's /etc/localtime

Environment: 

NEXTCLOUD_TARGET_DIR: The relative directory in nextcloud to move files to, e.g. /marvin/files/Document/Inbox
NEXTCLOUD_OCC_COMMAND: The name of the nextcloud OCC command, e.g. docker exec -u 33 $NEXTCLOUD_CONTANER_NAME ./occ


Example: 

```
docker run -it --rm -v /etc/localtime:/etc/localtime:ro -v /var/run/docker.sock:/var/run/docker.sock -v /srv/sidekick/nextcloud/nextcloud/data:/nextcloud_root -v /backup/other/shared/processed-scans:/input -e NEXTCLOUD_TARGET_DIR=/alexander/files/Documents/Inbox/ -e NEXTCLOUD_OCC_COMMAND="docker exec -u 33 nextcloud ./occ" kune/wran
```

Run bash: 
```
docker run -it --rm -v /etc/localtime:/etc/localtime:ro -v /var/run/docker.sock:/var/run/docker.sock -v /srv/sidekick/nextcloud/nextcloud/data:/nextcloud_root -v $(pwd)/test-input:/input -e NEXTCLOUD_TARGET_DIR=/alexander/files/Documents/Test-Inbox/ -e NEXTCLOUD_OCC_COMMAND="docker exec -u 33 nextcloud ./occ" --entrypoint bash kune/woran
```

Docker Compose

```
version: "3.3"
services:

  wran: 
    image: kune/woran
    restart: unless-stopped
    environment:
      - NEXTCLOUD_TARGET_DIR="/alexander/files/Documents/Inbox/"
      - NEXTCLOUD_OCC_COMMAND="docker exec -u 33 nextcloud ./occ"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock
      - /srv/sidekick/nextcloud/nextcloud/data:/nextcloud_root
      - /backup/other/shared/processed-scans:/input
```

