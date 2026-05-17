# AWS How To's

Self-contained AWS CLI recipes and operational notes, organized into two comprehensive guides.

## Quick Navigation

### 1. **AWS-CLI-Quick-Reference.md**
Essential AWS CLI commands for common operations:
- **IAM and Authentication**: Role/profile switching, caller identity checks, policy management
- **CloudFormation**: Stack listing, describing, and deletion
- **Route 53**: Hosted zone and resource record set management
- **Container Registry (ECR)**: Repository deletion and management
- **Network Operations**: IPv4 prefix queries, secondary IP address listing, availability zones
- **AWS Quota Checker**: VPC and quota verification utilities
- **gcloud Utilities**: Version management

### 2. **AWS-EC2-Kubernetes-Guide.md**
EC2 instance management and Kubernetes integration:
- **EC2 Instance Types**: Finding ARM-based instances, querying network bandwidth per instance type
- **EC2 Instance Information**: Retrieving instance IDs and names via AWS CLI and Kubernetes
- **Kubernetes Node Architecture**: Checking processor architecture of cluster nodes
- **EKS Operations**: Enabling EBS CSI driver for persistent volumes
- **EC2 Metadata Retrieval**: Region/availability zone queries, IMDSv2 token-based metadata access

## Working with these guides

Each guide contains:
- **Clear command examples** ready to copy and adapt
- **Expected output** samples for validation
- **Prerequisites** and setup instructions where applicable
- **Use cases** explaining when and why to use each command

All commands are compatible with AWS CLI v2 and can be integrated into automation pipelines or scripts.
