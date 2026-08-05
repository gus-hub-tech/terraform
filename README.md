# HashiCorp -Terraform

## Simple projects (single environment)
For small-to-medium projects keep the core .tf files in the project root. This is the simplest approach and works well for single environments.

## What is Terraform?
Terraform is an open-source infrastructure as code software tool created by HashiCorp. It allows users to define and provision data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON.

## How does Terraform work?
Terraform uses binary plugins called providers to manage your resources by calling your cloud provider's APIs.

## Initialize your workspace
Before you can apply your configuration, you must initialize your Terraform workspace with the terraform init command. As part of initialization, Terraform downloads and installs the providers defined in your configuration in your current working directory.

Terraform downloaded the aws provider and installed it in a hidden .terraform subdirectory of your current working directory. Terraform also created a file named .terraform.lock.hcl which specifies the exact provider versions used with your workspace, ensuring consistency between runs.

## Create infrastructure
Terraform makes changes to your infrastructure in two steps.
Terraform creates an execution plan for the changes it will make. Review this plan to ensure that Terraform will make the changes you expect.
Once you approve the execution plan, Terraform applies those changes using your workspace's providers.

This workflow ensures that you can detect and resolve any unexpected problems with your configuration before Terraform makes changes to your infrastructure.


## Inspect state
When you applied your configuration, Terraform wrote data about your infrastructure into a file called terraform.tfstate. Terraform stores data about your infrastructure in its state file, which it uses to manage resources over their lifecycle.

List the resources and data sources in your Terraform workspace's state with the terraform state list command.

```bash
terraform state list
```
Even though the data source is not an actual resource, Terraform tracks it in your state file. Print out your workspace's entire state using the terraform show command.

```bash
terraform show  
```

When you use Terraform to plan and apply changes to your workspace's infrastructure, Terraform compares the last known state in your state file, your current configuration, and data returned by your providers to create its execution plan.

Your state file can include sensitive information about your infrastructure, such as passwords or security keys, so you must store your state file securely and restrict access to only those who need to manage your infrastructure with Terraform. By default, Terraform creates your state file locally. As your infrastructure operations mature, storing your state remotely using HCP Terraform will let you collaborate with your team more easily and keep your state file secure.

## Notes!
When you initialize an existing workspace, Terraform detects and installs any new providers and modules. 
Terraform tracks the current versions of the providers used with your configuration in the .terraform.lock.hcl file in your workspace's directory.

## A terraform.tfstate file is Terraform's 
A record of what infrastructure it has actually created and how that maps to your configuration. It's JSON, and it's the source of truth Terraform uses to figure out what to create, update, or destroy on each apply.

## Plan and apply changes
AWS does not support moving an existing resources, Terraform will plan to replace your existing resources rather than updating it in place. Approve Terraform's plan to add your new resources.

How to create a key pair in AWS - example command to create a key pair in AWS using the AWS CLI. You can also create a key pair using the AWS Management Console.

```bash
aws ec2 create-key-pair --key-name learn-terraform-key --region af-south-1 --query 'KeyMaterial' --output text > learn-terraform-key.pem
chmod 400 learn-terraform-key.pem
```


