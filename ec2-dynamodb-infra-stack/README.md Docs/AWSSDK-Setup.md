# AWS SDK Setup

# Installing AWS CLI v2 on Instance

sudo apt remove -y awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install -y unzip
unzip awscliv2.zip
sudo ./aws/install

Download the ARM64 version instead:

curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

Or use apt:

sudo apt update && sudo apt install awscli

# Verify installation

aws --version

### Removing the installation

To remove the AWS CLI v2, delete the its installation and symlinks:
```
$ sudo rm -rf /usr/local/aws-cli
$ sudo rm /usr/local/bin/aws
$ sudo rm /usr/local/bin/aws_completer
```

#### Setup happens on the EC2 instance itself, after it launches — not in Terraform (that only handles permissions/infrastructure). 

Here's the flow:

Where: SSH into the instance:

```bash
ssh -i your-key.pem ec2-user@<instance-public-ip>
```
### What is boto3?

A Python SDK for AWS. It allows Python developers to write software that makes use of services like Amazon S3 and Amazon EC2.

Python (boto3)

```bash
# Amazon Linux 2023 / most AMIs ship with Python3
sudo yum install -y python3-pip   # Amazon Linux
# or: sudo apt install -y python3-pip   # Ubuntu
```

```bash
pip3 install boto3
```

Then your app code (the boto3.resource('dynamodb', ...) snippet from earlier) just works — boto3 automatically picks up credentials from the instance's IAM role via the instance metadata service. No config file, no access keys needed.

Quick test:

```bash
python3 -c "import boto3; print(boto3.client('sts').get_caller_identity())"
```

If this prints your account/role ARN, the SDK is authenticated correctly.


## Automating it (recommended)

Instead of SSHing in manually every time, bake the setup into user_data on your aws_instance so it's ready on boot: Has to be added to terrform code for the instance resource option.

```bash
resource "aws_instance" "app" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.app_profile.name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum install -y python3-pip
    pip3 install boto3
  EOF

  tags = {
    Name        = "my-app"
    Terraform   = "true"
    Environment = "staging"
  }
}
```

This runs once on first boot — so by the time you SSH in (or your deployment pipeline drops the app code), boto3's already installed and ready to authenticate via the instance role.


# Writing to DynamodDb table

```bash
aws dynamodb put-item \
  --table-name my-table \
  --item '{"id": {"N": "1"}, "name": {"S": "test entry"}}' \
  --region af-south-1
```
