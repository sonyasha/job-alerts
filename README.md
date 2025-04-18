# Job Alerts Infrastructure

This project defines and deploys a serverless job alerting system using **Terraform**, **AWS Lambda**, **EventBridge**, **DynamoDB**, and **SES**. It periodically fetches search results (e.g. job openings) from the Google Custom Search API and sends email alerts based on user-defined criteria.

---

## 📦 Project Structure

```
terraform/
├── main.tf                 # Root Terraform configuration
├── variables.tf            # Input variable definitions
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable values (excluded from git)
├── modules/                # Module definitions
│   ├── backend-setup/      # (Optional) Used to bootstrap the backend infra
│   ├── iam/                # IAM role, policy, and attachment
│   ├── lambda/             # Lambda deployment and environment variables
│   ├── dynamodb/           # DynamoDB table for deduplication
│   └── eventbridge/        # Scheduled trigger
lambda/
├── lambda_function.py      # Core logic to fetch jobs and send emails
├── requirements.txt        # Lambda dependencies
├── build.sh                # Builds zip package for deployment
```

---

## 🚀 Setup Instructions

### 1. 📬 Verify Email Addresses in AWS SES

Before deploying:
- Go to **SES > Verified Identities** in the AWS Console
- Add both `SENDER_EMAIL` and `RECIPIENT_EMAIL`
- You must confirm via a link emailed to each address

> SES must be in **sandbox mode** unless your account is approved for production

---

### 2. 🛠 Local Development

#### ⚙️ Initialize and Plan
```bash
cd terraform
terraform init -reconfigure
terraform plan
```

#### 📄 Set up `terraform.tfvars`
Create a `terraform.tfvars` file in the `terraform/` directory with values like:
```hcl
sender_email     = "you@example.com"
recipient_email  = "you@example.com"
search_query     = "(developer OR engineer) remote"
google_api_key   = "your-google-api-key"
cse_id           = "your-cse-id"
```
> ✅ This file is ignored by Git and used only for local development.

#### 🚀 Apply Infrastructure
```bash
terraform apply
```

#### 🧪 Test Lambda Locally (Optional)
You can invoke the Lambda function directly using test event data or AWS Console.

---

### 3. 🤖 CI/CD Deployment

CI/CD is handled by GitHub Actions and split into two workflows:

#### 🔍 `.github/workflows/ci.yml`
- Runs on every push / PR
- Validates formatting, builds Lambda package, lints Python

#### 🚀 `.github/workflows/cd.yml`
- Manual deploy workflow
- Only deploys from `main` if user enters `YES`

#### 🔐 Required GitHub Secrets:
| Name                    | Description                  |
|-------------------------|------------------------------|
| `AWS_ACCESS_KEY_ID`     | IAM user with deploy rights  |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key          |
| `AWS_REGION`            | (e.g. `us-west-1`)           |
| `GOOGLE_API_KEY`        | Google CSE API key           |
| `CSE_ID`                | Google CSE ID                |
| `SENDER_EMAIL`          | Verified SES email address   |
| `RECIPIENT_EMAIL`       | Verified SES email address   |
| `SEARCH_QUERY`          | Google search string         |

---

## 🧹 Resetting Infrastructure

If Terraform state is corrupted or out of sync:
- Run `terraform state rm module.backend_setup` (if backend was previously managed)
- Manually delete S3 bucket and DynamoDB lock table **only if necessary**
- Rebuild infra using `backend_setup` module temporarily, then remove it

---

## 🧠 Notes
- Terraform backend is configured with S3 + DynamoDB locking
- `terraform.tfstate` is stored remotely and shared across local and CI/CD
- Lambda environment variables are securely managed through Terraform and GitHub Secrets

---
