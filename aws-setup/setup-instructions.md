# AWS Setup Instructions

## Step 1: Create ECR Repository

1. Go to AWS Console → ECR
2. Click "Create repository"
3. Repository name: `weather-api`
4. Visibility: Private
5. Click "Create repository"

## Step 2: Create ECS Cluster

1. Go to AWS Console → ECS
2. Click "Create Cluster"
3. Cluster name: `weather-api-cluster`
4. Infrastructure: AWS Fargate (serverless)
5. Click "Create"

## Step 3: Create Task Definition

1. In ECS Console → Task definitions
2. Click "Create new task definition"
3. Task definition family: `weather-api-task`
4. Launch type: AWS Fargate
5. Operating system: Linux/X86_64
6. CPU: 0.25 vCPU
7. Memory: 0.5 GB
8. Task role: ecsTaskExecutionRole (create if doesn't exist)
9. Container details:
   - Name: `weather-api`
   - Image URI: `<your-account-id>.dkr.ecr.us-east-1.amazonaws.com/weather-api:latest`
   - Port mappings: 80 (HTTP)
   - Environment variables: (none for now)
10. Click "Create"

## Step 4: Create ECS Service

1. In your cluster → Services tab
2. Click "Create"
3. Launch type: Fargate
4. Task Definition: weather-api-task
5. Service name: `weather-api-service`
6. Number of tasks: 1
7. VPC: Default VPC
8. Subnets: Select all available
9. Security group: Create new
   - Allow HTTP (port 80) from anywhere
   - Allow HTTPS (port 443) from anywhere
10. Public IP: ENABLED
11. Load balancer: None (for simplicity)
12. Click "Create Service"

## Step 5: Create IAM User for GitHub Actions

1. Go to IAM → Users
2. Click "Create user"
3. Username: `github-actions-user`
4. Attach policies:
   - `AmazonEC2ContainerRegistryPowerUser`
   - `AmazonECS_FullAccess`
   - Custom policy for ECS task definition updates:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:RegisterTaskDefinition",
                "ecs:UpdateService",
                "ecs:DescribeServices",
                "ecs:DescribeTaskDefinition",
                "iam:PassRole"
            ],
            "Resource": "*"
        }
    ]
}
```

5. Create access keys and save them securely

## Step 6: Configure GitHub Secrets

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

- `AWS_ACCESS_KEY_ID`: Your IAM user access key
- `AWS_SECRET_ACCESS_KEY`: Your IAM user secret key
- `OCTOPUS_URL`: Your Octopus Deploy server URL
- `OCTOPUS_API_KEY`: Your Octopus Deploy API key

## Step 7: Update ECR Repository URI

Replace `<your-account-id>` in the task definition with your actual AWS account ID.

## Verification

1. Push code to main branch
2. Check GitHub Actions workflow
3. Verify image in ECR
4. Check ECS service is running
5. Access the API using the public IP of the running task