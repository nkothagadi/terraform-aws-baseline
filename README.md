# terraform-aws-baseline

Small, reusable Terraform modules for an AWS foundation, with CI that formats and validates every change.

## What's inside

| Module | Purpose |
| --- | --- |
| `modules/state-backend` | Remote state for Terraform: private, versioned, encrypted S3 bucket (TLS-only policy) + DynamoDB lock table |
| `modules/vpc` | VPC with public and private subnets across AZs, route tables, optional single NAT gateway |
| `examples/basic` | Wires both modules together in a runnable example |

## Design choices

- **Secure by default:** public access blocked, encryption on, versioning on, insecure transport denied.
- **Cost-aware:** the NAT gateway is off by default (`enable_nat_gateway = false`).
- **CI on every PR:** `terraform fmt -check`, `init -backend=false`, and `validate` for each module and example (see `.github/workflows/terraform-ci.yml`).

## Usage

```bash
cd examples/basic
terraform init
terraform plan
```

Change `bucket_name` first: S3 bucket names are globally unique. Then, once the state bucket exists, uncomment the `backend "s3"` block to move state to it.

> Running `terraform apply` creates real AWS resources. Destroy the example when you're done.

## Requirements

- Terraform >= 1.5
- AWS provider >= 5.0
- AWS credentials with permission to create the resources above

## License

MIT
