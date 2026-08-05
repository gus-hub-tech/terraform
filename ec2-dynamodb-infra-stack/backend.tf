###########################################################################################################################################################################################################################################################################
# Terraform backend configuration Note: For production or team environments, you'd typically use a remote backend (like S3, Consul, Terraform Cloud) for state locking and team collaboration. The local backend is appropriate here for a learning/exercise environment.
# Terraform would default to storing state as terraform.tfstate in the current directory if no backend was configured, explicitly defining:
###########################################################################################################################################################################################################################################################################

# Backend configuration for terraform state file

terraform {
  backend "local" {
    path = "tmp/terraform.tfstate"
  }
}

# Organization: Keeps state files in the conventional tmp directory rather than cluttering your project root
# Explicitness: Makes it clear where state is stored (avoids confusion about default behavior)
# Consistency: Ensures all team members (if this were a team project) use the same state location
# Cleanliness: Separates infrastructure state from source code