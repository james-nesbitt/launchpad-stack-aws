# Mirantis terraform launchpad provider : demo template

A terraform root module that demonstrates how to use the
Mirantis launchpad terraform provider to install the
Mirantis container products.

## Components

Note the following:

  1. The versions.tf file defines the launchpad provider
     plugin.
  2. The main.tf uses a Mirantis module to provision a
     number of machines in an AWS VPC, with infrastructure
	 needed to support an MCR/MKE cluster. The module also
	 outputs a list of host maps, and some load-balancer
	 urls.
  3. The main.tf uses the "launchpad_config" resource
     to install the Mirantis container products onto the
	 machines provisioned. We use terraform dynamic blocks
	 to translate the list of machine maps into host blocks
	 and parametrized variables to configure product
	 installation.
  4. A variables "config.auto.tfvars" file is used along
     with variables.tf defaults to configure the chart.

  5. The .terraform.lock.hcl file pins the terraform
     plugins.

## Usage

This terraform chart is nearly usable as is, but needs
a value for the cluster name (missing intentionally.)
You can add a cluster name to the tfvars file.

** NOTE this uses the AWS provider by default, which
   means that you will need authenticate for AWS access,
   which typically means that you have to set environment
   vars.

The tfvars file, and the module/resource attributes can
be tuned to adapt the terraform chart to your needs.

Initialize the terraform chart, downloading the needed
terraform plugins and modules.
```
$/> terraform init
```

Apply the chart, provisioning the resources and installing
the containers products.
```
$/> terraform apply
```