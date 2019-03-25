
pilot_inputs = {
  name = "validity-homework"  # name of this project; will be used to create a CNAME for the ALB hostname
  site = "Ireland"            # aws region name for the deployment
  cpu  = "0.25 vCPU"          # container compute allocation
  ram  = "0.5GB"              # container memory allocation
  hzid = "*************"      # hosted zone id for the CNAME
  domain = "*************"    # hosted zone domain name
}