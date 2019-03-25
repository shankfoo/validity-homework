####################################################################################################

{ cd "$(dirname "$0")" && cd ./tf

} && {

terraform init -backend-config='../pilot_secrets.tfvars'

} && {

# terraform apply -no-color -auto-approve ../tf.plan | tee ../tf_apply.log

terraform apply \
  -no-color \
  -auto-approve \
  -var-file='../pilot_inputs.tfvars' \
  -var-file='../pilot_secrets.tfvars' \
  -input=false | tee ../tf_apply.log

}

####################################################################################################

# # run this in a separate window/pane
# cd ~/validity-homework/tf
# watch terraform show -no-color

