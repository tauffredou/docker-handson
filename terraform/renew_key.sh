#!/bin/sh

if [ $# -lt 1 ];then
  echo "Usage: renew_key.sh <private_key>"
  exit 1
else
  SSH_KEY=$1
fi
CWD=$(pwd $(dirname $0))
KEY=docker-janvier
DATA_DIR=$CWD/../data

# Create keys
cd $CWD/private
rm $KEY*
ssh-keygen -f $KEY -N "" -q -C "$KEY@xebia"

if [ -f "$CWD/public_keys/$KEY.pub" ];then
  if [ ! -d $CWD/revoked_keys ];then
    mkdir $CWD/revoked_keys
  fi
  mv $CWD/public_keys/$KEY.pub $CWD/revoked_keys/$KEY-$(date +%Y%M%d%H%m%S).pub
fi
mv $KEY.pub $CWD/public_keys

mv $KEY $DATA_DIR/$KEY.pem
puttygen $DATA_DIR/$KEY.pem -o $DATA_DIR/$KEY.ppk -O private
chmod 600 $DATA_DIR/docker-janvier.{pem,ppk}

# Apply
cd $CWD
export ANSIBLE_HOST_KEY_CHECKING=False
node terraform2ansible.js terraform.tfstate private/inventory
ansible-playbook -i private/inventory --private-key=$SSH_KEY docker.playbook

cat << EOF

To publish the new keys into github, copy/paste the following :

git add $DATA_DIR/docker-janvier.{pem,ppk} $CWD/public_keys/$KEY.pub
git commit  -m "Renew keys" $DATA_DIR/docker-janvier.{pem,ppk} $CWD/public_keys/$KEY.pub
git push

EOF
