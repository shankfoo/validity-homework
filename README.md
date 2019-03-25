# validity-homework

* Tested on an clean Ubuntu 18.04 image.

Step 0: bootstrap the workspace

0.0 - Download the files to a local directory, keeping the relative directory structure intact.
  suggested path: ~/validity-homework

0.1 - Run `00_config_console.sh` to install the required components if needed, which are:  unzip, terraform, python, aws cli.

0.2 - Edit `pilot_secret.tfvars` to contain a valid amazon access key and secret key.
```
# this is used for backend and provider
access_key="A******************A"
secret_key="*************************************XyZ"
```

0.3 - Edit `pilot_inputs.tfvars` to specify the hosted zone id and domain name of a public Route53 zone.
  You should not need to edit any other inputs.
```
pilot_inputs = {
  name = "validity-homework"  # name of this project; will be used to create a CNAME for the ALB hostname
  site = "Ireland"            # aws region name for the deployment
  cpu  = "0.25 vCPU"          # container compute allocation
  ram  = "0.5GB"              # container memory allocation
  hzid = "*************"      # hosted zone id for the CNAME
  domain = "***********"      # hosted zone domain name
}
```

0.4 - Edit the `./tf/backend_s3.tf` file to specify valid S3 bucket and key path for the S3 backend, OR
  Delete or replace the `./tf/backend_s3.tf` file to use the local backend or another desired backend.
```
# terraform {
#   backend "s3" {
#     bucket      = "<some-valid-bucket-name>"
#     key         = "<some-valid>/<key-path>/terraform.tfstate"
#     region      = "us-east-2"
#   }
# }
```

Step 1: plan

1.1 - Execute `01_terraform_plan.sh`.  It should run successfully, performing a terraform init and terraform plan, and generating the following files, in the same dir as the script file:
- `tf.plan`
- `tf_plan.log`

Step 2: apply

2.1 - Execute `02_terraform_apply.sh`.  It should run successfully, performing a terraform init and terraform apply, and generating the following files, in the same dir as the script file:
- `tf_apply.log`
- `az_count.log`
- `try_this_address.log`

2.2 - `try_this_address.log` should contain the URL that matches the values in the pilot inputs, similar to `http://validity-homework.infra.ac:80`.  Clicking or CURL'ing to this URL repeatedly should produce output similar to the following...

    `I'm 4171eb990bc8 running on linux/amd64`

... with a finite number (3) or different IDs showing up in the responses, one for each available Availablity Zone in `Ireland/eu-west-1` at the time of deployment.  Check the output of `az_count.log` to view the available AZs.

2.3 - (optional) Use the AWS CLI or log in to the AWS web console and inspect the deployed resources.

Step 3: show

3.1 - (optional) Execute `03_terraform_show.sh`.  It should run successfully, performing a terraform init and terraform show, and generating `tf_show.log` in the same dir as the script file.

3.3 - (optional) inspect the `terraform show` output file.

Step 4: destroy

4.1 - Execute `03_terraform_show.sh`.  You will be prompted to confirm terraform destroy. It should run successfully, performing a terraform init and terraform show, and generating
`tf_destroy.log` in the same dir as the script file.

4.2 - (optional) Use the AWS CLI or log in to the AWS web console and confirm resource destruction.
