#!/bin/bash
# Deployment script
# ===================================================

echo "**************************************************"
echo "*********** DEPLOYMENT SCRIPT ***********"
echo "**************************************************"

main(){
    echo "1: Deploy ( Install Docker & Docker-compose + Get Docker-compose file + pull & launch containers )"
    echo "2: Get Docker"
    echo "3: Specify Docker compose file"
    echo "4: Pull images"
    echo "5: Launch containers"
    echo "6: List of images"
    echo "7: List of containers"
    echo "8: Database migration"
    echo "9: Stop containers"
    echo "10: Delete all"
    echo "11: Delete all except volumes"
    echo "12: Uninstall Docker"
    echo "13: Uninstall Docker-compose"
    echo "14: Exit"

    echo "Select your option"
    read option

    case $option in 
        '1')  Deploy;;
        '2')  get_docker;;
        '3')  get_docker_compose_file;;
        '4')  pull_images;;
        '5')  launch_containers;;
        '6')  images_list;;
        '7')  containers_list;;
        '8')  database_migration;;
        '9')  stop_containers;;
        '10') remove_all;;
        '11') remove_all_except_volumes;;
        '12') uninstall_docker;;
        '13') uninstall_docker_compose;;
        '14') exit;;
        *) echo 'Invalid option' 
    esac
}

Deploy(){
    echo "*********** Step 1 : GET DOCKER ***********"
        get_docker
    echo "*********** Step 2 : GET DOCKER COMPOSE FILE ***********"
        get_docker_compose_file
    echo "*********** Step 3 : PULL IMAGES ***********"
        echo "Pull images"
        sudo docker-compose -f $path/$name pull
        echo "List of images"
        sudo docker images
    echo "*********** Step 4 : START THE APP ***********"
        echo "Launch container"
        sudo docker-compose -f $path/$name up -d
        echo "List of containers launched"
        sudo docker ps
}

get_docker(){
    if [[ $(which docker) && $(docker --version) ]]; then
        echo "Docker is installed"
    else
        echo "1 : Install docker"
        echo "1.1 : Update APT"
            sudo apt update
            sudo apt upgrade
        echo "1.2 : Download and Install Docker"
            sudo apt install docker.io
        echo "1.3 : Launch Docker"
            sudo systemctl enable --now docker
        echo "1.4 : Check Docker Version"
            docker --Version
        echo "Docker successfully installed"
    fi
   
    if [[ $(which docker-compose) && $(docker-compose --version) ]]; then
        echo "Docker-compose is installed"
    else 
        echo "2 : Install docker-compose"
            echo "2.1 : Upgrade and Update"
                sudo apt update
                sudo apt upgrade
            echo "2.2 : Install curl"
                sudo apt install curl
            echo "2.3 : Download the Latest Docker Version"
                sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            echo "2.4 : Change File Permission"   
                sudo chmod +x /usr/local/bin/docker-compose
            echo "2.5 : Check Docker Compose Version"
                docker–compose –version
            echo "Docker-compose successfully installed"  
    fi
    echo "3 : Docker login "
        #echo "$CI_DEPLOY_PASSWORD" | sudo docker login --username "$CI_DEPLOY_USER" --password-stdin registry.gitlab.com
        sudo docker login -u "$CI_DEPLOY_USER" -p "$CI_DEPLOY_PASSWORD" registry.gitlab.com
}

get_docker_compose_file(){
    echo "4 : You must copy docker-compose.yml to the server using FileZila if it's OK then "
    echo "5 : Specify docker-compose file path"
    read path 
    echo "6 : Specify docker-compose file name"
    read name
    if [ ! -e "${path}${name}" ] 
    then
        echo "${path}${name} file not found"
    fi
}

pull_images(){
    get_docker_compose_file
    echo "Pull images"
    sudo docker-compose -f $path/$name pull
    echo "List of images"
    sudo docker images
}

launch_containers() {
    get_docker_compose_file
    echo "docker-compose up to launch container"
    sudo docker-compose -f $path/$name up -d
    echo "*** List of containers launched ***"
    sudo docker ps
}

database_migration(){
    echo "Migration"
    echo "Enter server side image name"
    read image
    id=`sudo docker ps -a | grep $image -m 1 | awk '{ print $1 }'`
    sudo docker exec -it $id bash
}

stop_containers(){
    get_docker_compose_file
    echo "Stop containers"
    sudo docker-compose -f $path/$name down
    sudo docker ps
}

remove_all(){
    echo -e "WARNING! This will remove:
    \n all stopped containers
    \n all networks not used by at least one container
    \n all volumes not used by at least one container
    \n all images without at least one container associated to them
    \n all build cache"
    sudo docker system prune -a --volumes
    echo "List of images"
    sudo docker images
    echo "List of volumes"
    sudo docker volume ls
}

remove_all_except_volumes(){
    echo -e "WARNING! This will remove:
    \n all stopped containers
    \n all networks not used by at least one container
    \n all images without at least one container associated to them
    \n all build cache"
    sudo docker system prune -a
    echo "List of images"
    sudo docker images
    echo "List of volumes"
    sudo docker volume ls
}

uninstall_docker(){
    echo "Uninstall Docker on Ubuntu";
    sudo apt-cache policy docker.io
    sudo apt purge docker.io
    sudo apt autoremove
    echo "docker successfully uninstalled"
    docker
}

uninstall_docker_compose(){
    echo "Step 1: Delete the Binary"
    sudo rm /usr/local/bin/docker-compose
    echo "Step 2: Uninstall the Package"
    sudo apt remove docker-compose
    echo "Step 3: Remove Software Dependencies"
    sudo apt autoremove
    echo "docker-compose successfully uninstalled"
    docker-compose
}

containers_list(){
   echo "List of containers"
   sudo docker ps
}

images_list(){
   echo "List of images"
   sudo docker images
}

main
