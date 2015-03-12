# Prérequis

installer terraform à la main
```shell
brew install node
brew install ansible
brew install putty
```


# Démarrer l'infrastructure

##Définir les variables d'environnements suivantes

```
export AWS_ACCESS_KEY=change-me
export AWS_SECRET_KEY=change-me
export AWS_REGION=eu-west-1
```
##Modifier le nombre d'instances à démarrer en éditant le fichier docker.tf`

```
variable "docker_count" {
  description = "Number of instances to spawn"
  default = "2"
}
```

## Le script suivant lance la création de l'infrastructure sur AWS et éxécute le provisionning avec ansible

```shell
./spawn.sh ~/Downloads/docker-initiation.pem
```

# Réinitialiser la clé ssh

```shell
./renew_key.sh ~/Downloads/docker-initiation.pem
```

# Détruire l'infrastructure

```shell
terraform destroy
```

