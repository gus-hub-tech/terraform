## How to use Terraform with AWS? [Authentication-Options]
To use your IAM credentials to authenticate the Terraform AWS provider, set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. how do i set this in the terminal?

#### Note:These only last for the current terminal session. Close the terminal and they're gone.

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
```
#### To verify it worked:
```bash
echo $AWS_ACCESS_KEY_ID
```
#### If you want it to persist across terminal sessions.
You can add the export commands to your shell's profile file (e.g., `~/.bashrc`, `~/.bash_profile`, or `~/.zshrc`), and then run `source ~/.bashrc` (or the appropriate file) to apply the changes.


1. Open the file in a text editor from the terminal:
```bash
nano ~/.bashrc
```

2. Scroll to the bottom of the file
3. Add these two lines at the bottom:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
```
4. Save and exit: 

In nano: Ctrl+O (writes the file), then Enter to confirm the filename, then Ctrl+X to exit.

5. Reload the file so it takes effect immediately:
```bash
source ~/.bashrc
```

6. Verify it worked:
```bash
echo $AWS_ACCESS_KEY_ID
```

If that prints your key, you're set. From now on, every new terminal session will automatically have those variables loaded.

#### Alternative without an editor
You can append the lines directly with echo, no editor needed:

```bash
echo 'export AWS_ACCESS_KEY_ID="your-access-key-id"' >> ~/.bashrc
echo 'export AWS_SECRET_ACCESS_KEY="your-secret-access-key"' >> ~/.bashrc
source ~/.bashrc
```
The >> appends to the end of the file without overwriting anything already there. Just be careful with that operator — a single > would wipe the whole file.


#### Better alternative for real use.

Rather than exporting raw long-term credentials, consider using ~/.aws/credentials with named profiles (via aws configure) and pointing Terraform at a profile with AWS_PROFILE=your-profile,

#### Named profiles via aws configure
 Create a named profile:
```bash
aws configure --profile your-profile
```
 Enter your access key, secret key, region, and output format when prompted.

```bash
AWS Access Key ID [None]: your-access-key-id
AWS Secret Access Key [None]: your-secret-access-key
Default region name [None]: af-south-1
Default output format [None]: json
```

This writes to two files: ~/.aws/credentials (the keys) and ~/.aws/config (region/output settings), both under a [your-profile] section instead of the default one.

 Point Terraform at that profile. Two ways:
```bash
export AWS_PROFILE=your-profile
terraform plan
```
Or reference it directly in your Terraform provider block:
```hcl
provider "aws" {
  profile = "your-profile"
  region  = "af-south-1"
}
```
 Verify it's working:

```bash
aws sts get-caller-identity --profile your-profile
```
This should return your account ID and user ARN if the credentials are valid.

### Why this better than raw env vars:

#### crdentials still sit in a plaintext file (~/.aws/credentials), but they're scoped to a named profile instead of floating in your shell's environment, so you're less likely to leak them into scripts, logs, or accidentally commit them.


Or tter yet using AWS SSO / temporary credentials via aws sts assume-role. Long-lived access keys sitting in env vars or shell history are one of the more common ways credentials leak

Option 2: Temporary credentials via assume-role (or SSO)

This is the stronger approach — no long-lived keys stored anywhere.

A. If your org uses AWS SSO (IAM Identity Center):
```bash
aws configure sso
```
Follow the prompts to log in and select your account/role. This will create a profile in ~/.aws/config that uses temporary credentials.

```bash
aws sso login --profile your-sso-profile
export AWS_PROFILE=your-sso-profile
terraform plan
```
Credentials refresh automatically and expire — nothing permanent sits on disk.

B. If you're assuming a role manually with sts assume-role:
```bash 
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/YourRoleName \
  --role-session-name terraform-session
```

This returns JSON with an AccessKeyId, SecretAccessKey, and SessionToken — all temporary (expire in ~1 hour by default). You'd export all three:

```bash
export AWS_ACCESS_KEY_ID="ASIA..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
```
Note the extra AWS_SESSION_TOKEN — temporary credentials always need that third variable alongside the usual two, or Terraform's auth will fail.

To avoid copy-pasting JSON by hand, jq makes this scriptable:
```bash

CREDS=$(aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/YourRoleName \
  --role-session-name terraform-session \
  --query 'Credentials' --output json)

export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r '.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r '.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r '.SessionToken')
```