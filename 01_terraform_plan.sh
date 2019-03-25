####################################################################################################

{ cd "$(dirname "$0")" && cd ./tf

} && {

terraform init -backend-config='../pilot_secrets.tfvars'

} && {

terraform plan -out ../tf.plan \
  -no-color \
  -var-file='../pilot_inputs.tfvars' \
  -var-file='../pilot_secrets.tfvars' \
  -input=false | tee ../tf_plan.log

}
cd "$(dirname "$0")"

####################################################################################################
