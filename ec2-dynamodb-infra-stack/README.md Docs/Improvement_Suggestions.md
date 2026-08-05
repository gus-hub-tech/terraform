# Terraform Infrastructure - Improvement Suggestions

This document outlines potential improvements for the current Terraform configuration, categorized by priority and domain.

---

## Security Improvements

### High Priority
- **Replace SSH access with SSM Session Manager** - Eliminate SSH port 22 exposure entirely by using AWS Systems Manager Session Manager for secure instance access
- **Move EC2 to private subnet** - Deploy instance in private subnet with NAT Gateway for outbound internet access, removing direct public IP exposure

### Medium Priority
- **Restrict HTTP/HTTPS ingress** - Limit `0.0.0.0/0` to specific CIDR ranges or use ALB with WAF
- **Restrict egress traffic** - Replace `0.0.0.0/0` egress with specific destination CIDRs (e.g., DynamoDB VPC endpoints, package repositories)
- **Enable DynamoDB encryption at rest** - Add `server_side_encryption` block to `aws_dynamodb_table`
- **Enable DynamoDB Point-in-Time Recovery (PITR)** - Add `point_in_time_recovery { enabled = true }` for backup protection
- **Add IAM policy conditions** - Include condition keys like `aws:SourceVpc`, `aws:SourceIp` to restrict policy usage

### Low Priority
- **Implement VPC endpoints** - Add Gateway/Interface endpoints for DynamoDB, S3 to keep traffic off public internet

---

## Architecture Improvements

### High Priority
- **Add NAT Gateway** - Required for private subnet instances to access internet (updates, package installs)
- **Implement Auto Scaling Group + ALB** - Replace single EC2 with ASG behind Application Load Balancer for HA

### Medium Priority
- **Add third Availability Zone** - Current config uses only `af-south-1a` and `af-south-1b`; add `af-south-1c` for improved HA
- **Separate public/private subnet routing** - Ensure private subnets route through NAT, public through IGW

### Low Priority
- **Consider multi-region DR** - Replicate DynamoDB to secondary region for disaster recovery

---

## Terraform Best Practices

### High Priority
- **Configure remote state backend** - Add S3 bucket + DynamoDB locking for state management
- **Create `terraform.tfvars.example`** - Document all configurable variables with examples

### Medium Priority
- **Parameterize hardcoded values** - Move to variables:
  - VPC CIDR (`10.0.0.0/16`)
  - Subnet CIDRs
  - Availability Zones
  - DynamoDB read/write capacity
  - Instance type, AMI filters
- **Add variable validation** - Use `validation` blocks for input validation (e.g., CIDR format, instance type allowlist)
- **Use data sources for AMI** - Already using `aws_ami` data source; ensure architecture matches instance type (ARM64 for t4g)

### Low Priority
- **Pin provider versions exactly** - Use exact versions instead of `~> 5.92` for reproducible builds
- **Add module version constraints** - Already pinned VPC module to `5.19.0`

---

## Operational Improvements

### Medium Priority
- **Add pre-commit hooks** - Configure `terraform fmt`, `terraform validate`, `tflint` in `.pre-commit-config.yaml`
- **Enable cost estimation** - Integrate `infracost` in CI/CD pipeline
- **Add `terraform plan -out` workflow** - Save plan artifacts for review before apply

### Low Priority
- **Add drift detection** - Schedule periodic `terraform plan` runs to detect manual changes
- **Implement tagging strategy** - Standardize tags across all resources (Environment, Owner, CostCenter, etc.)
- **Add resource deletion protection** - Enable `prevent_destroy` on critical resources (DynamoDB, VPC)

---

## Quick Wins Priority Matrix

| Priority | Improvement | Effort | Impact |
|----------|-------------|--------|--------|
| 🔴 High | Move EC2 to private subnet + NAT + SSM | Medium | High |
| 🔴 High | Add DynamoDB encryption + PITR | Low | High |
| 🟡 Medium | Parameterize CIDRs, AZs, capacities | Low | Medium |
| 🟡 Medium | Add S3 backend + DynamoDB locking | Medium | High |
| 🟡 Medium | Restrict egress to required endpoints | Medium | Medium |
| 🟢 Low | Add pre-commit hooks (fmt, validate, tflint) | Low | Medium |
| 🟢 Low | Create terraform.tfvars.example | Low | Low |
| 🟢 Low | Add infracost to CI | Medium | Low |

---

## Implementation Notes

### SSM Session Manager Setup
```hcl
# Add to IAM role policy
{
  "Effect": "Allow",
  "Action": [
    "ssm:StartSession",
    "ssm:SendCommand",
    "ssm:GetCommandInvocation"
  ],
  "Resource": "*"
}
```

### DynamoDB Encryption + PITR
```hcl
resource "aws_dynamodb_table" "my_table" {
  # ... existing config ...
  
  server_side_encryption {
    enabled = true
  }
  
  point_in_time_recovery {
    enabled = true
  }
}
```

### S3 Backend Configuration
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "af-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

---

*Generated on: 2026-07-29*
*Review and prioritize based on your team's requirements and compliance needs.*