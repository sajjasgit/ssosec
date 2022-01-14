#!/bin/bash

create_docker_compose_files() {
    echo "Writing docker-compose-app to file"
    cat > "/tmp/docker-compose-app.yml" << EOF
version: "2.0"
services: 
  web-app:
    image: ${APP_ECR_REPO_URL}:latest
    ports:
      - "80:80"
    restart: always
EOF
}

echo "running yum update"
sudo yum -y update
sleep 5

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -v 19.03.13-ce -y
sudo chkconfig docker on
sudo usermod -aG docker ec2-user
sudo service docker start
sleep 5

echo "Installing docker-compose"
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version

echo "Setting up docker-compose files"
create_docker_compose_files

echo "Executing docker-compose for app"
REPO_URL=$(echo ${APP_REPO_URL} | cut -d'/' -f 1)
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin $REPO_URL

docker-compose -f /tmp/docker-compose-app.yml down
docker-compose -f /tmp/docker-compose-app.yml pull
docker-compose -f /tmp/docker-compose-app.yml up -d