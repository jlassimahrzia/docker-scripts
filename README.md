## How to run the app using Docker

0. Install docker on your machine

1. Clone the whole project, or download this file [docker-compose.yml]

2. Pull the images
Open the command terminal on the same path of docker-compose.yml and run the following command:
`docker-compose pull`

3. Start the app : to create and run the containers, run the following command 
`docker-compose up -d`
To lists running containers, run the following command:
`docker ps`

4. Migration :
`docker exec -it <SERVERSIDE-CONTAINER-ID> bash`
( Get <SERVERSIDE-CONTAINER-ID> by running: `docker ps`)
php artisan migrate:fresh --seed

5. To access the clientside, open [http://localhost](http://localhost) 

6. To access the serverside, open [http://localhost:8000](http://localhost:8000)

7. Database :
```
docker exec -it [mysql-container-id] mysql -u root -p
SHOW DATABASES;
Use nextgrc;
SHOW TABLES;
ect
```

8. To kill and remove the container, run the following command:
`docker-compose down`

## Use this to delete everything:

`docker system prune -a --volumes`
Remove all unused containers, volumes, networks and images

**WARNING!** This will remove:

- all stopped containers
- all networks not used by at least one container
- all volumes not used by at least one container
- all images without at least one container associated to them
- all build cache

## How to deploy app in vps server

0. Connect to the server

1. Install docker 
```
- Step 1: Update APT
    sudo apt update
    sudo apt upgrade
- Step 2: Download and Install Docker
    sudo apt install docker.io
- Step 3: Launch Docker
    sudo systemctl enable --now docker
    To disable it again, simply type in the following command `sudo systemctl disable --now docker`
- Step 4: Check Docker Version
    docker --version
- Step 5: Test Docker
    docker run hello-world
```

2. Install docker-compose
```
- Step 1: Upgrade and Update
    sudo apt update
    sudo apt upgrade
- Step 2: Install curl 
    sudo apt install curl
- Step 3: Download the Latest Docker Version
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

change 1.29.2 by the latest version you can check from here https://docs.docker.com/compose/release-notes/
- Step 4: Change File Permission
    sudo chmod +x /usr/local/bin/docker-compose
- Step 5: Check Docker Compose Version
    docker–compose –version
```

3. Docker login :
`docker login -u "$CI_DEPLOY_USER" -p "$CI_DEPLOY_PASSWORD" registry.gitlab.com`

3. Download this file docker-compose.server.yml and rename it by  docker-compose.yml

4. Copy docker-compose.yml to the server using FileZila

5. Go the same path of docker-compose.yml and run the following command:
`sudo docker-compose pull`

6.  Start the app : to create and run the containers, run the following command 
`sudo docker-compose up -d`

7. Migration :
`sudo docker exec -it <SERVERSIDE-CONTAINER-ID> bash`
( Get <SERVERSIDE-CONTAINER-ID> by running: `docker ps`)
php artisan migrate:fresh --seed

5. To access the clientside, open [http://IP_address](http://IP_address) 

6. To access the serverside, open [http://IP_address:8000](http://IP_address:8000)

7. Database :
```
docker exec -it [mysql-container-id] mysql -u root -p
SHOW DATABASES;
Use nextgrc;
SHOW TABLES;
ect
```
