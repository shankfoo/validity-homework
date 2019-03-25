####################################################################################################

# init

echo '... configuring this console'
cd ~

# if [[ $EUID -ne 0 ]]; then
#    printf "\n** ERROR ** this script requires elevation. user=${USER} euid=${EUID}\n\n"
#    exit 1
# fi

# update package lists
# sudo apt-get update

# install terraform
TF_VERSION='0.11.13'
TF_ZIPFILE="terraform_${TF_VERSION}_linux_amd64.zip"
ver=$(terraform -v)
echo $ver
if [[ $ver =~ ${TF_VERSION} ]]; then
  echo '... terraform OK'
else
  sudo apt-get -y install unzip
  sudo curl https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_ZIPFILE} \
    --output ${TF_ZIPFILE}
  ls ./ter*
  sudo unzip -o ./${TF_ZIPFILE} -d /usr/bin
  ls /usr/bin/ter*
  ver=$(terraform -v 2>nul)
  if [[ $ver =~ ${TF_VERSION} ]]; then
    echo '... terraform installed'
    terraform -v
  else
    (>&2 printf "\n** ERROR ** terraform install failed\n\n")
    exit 1
  fi
fi

# install aws cli
ver=$(aws --version 2>&1)
echo $ver
if [[ $ver =~ aws-cli\/1.1 ]]; then
  echo '... aws cli OK'
else
  sudo apt-get -y install python
  echo '... installing aws cli'
  sudo curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
  sudo unzip awscli-bundle.zip
  sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
  ver=$(aws --version 2>&1)
  if [[ $ver =~ aws-cli\/1.1 ]]; then
    echo '... aws cli installed'
    aws --version
  else
    (>&2 printf "\n** ERROR ** aws cli install failed\n\n")
    # exit 2
  fi
fi

####################################################################################################
