#!/bin/sh

function checkEnv(){
    [ -z $(eval echo \${$1}) ] && (
        echo $1 environnement variable is missing
        echo
        echo export $1=$2
    ) && exit 1;
}

function usage(){
    echo "Usage: provision.sh"
}
checkEnv AWS_ACCESS_KEY "change me"
checkEnv AWS_SECRET_KEY "change me"
checkEnv AWS_REGION "eu-west-1"
checkEnv AWS_PRIVATE_KEY "/path/to/the/private/key"
checkEnv DOCKER_TRAINING_PASSWORD "\"password for docker user\""

CWD=$(pwd $(dirname $0))

cd $CWD/terraform
terraform apply --input=false && (
    export ANSIBLE_HOST_KEY_CHECKING=False
    node $CWD/tools/terraform2ansible.js $CWD/terraform/terraform.tfstate $CWD/data/private/inventory
    ansible-playbook -i $CWD/data/private/inventory --private-key=$AWS_PRIVATE_KEY $CWD/ansible/site.yml
)
