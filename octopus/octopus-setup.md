# Octopus Deploy Setup Guide

## Step 1: Create Octopus Deploy Account

1. Go to https://octopus.com/
2. Sign up for a free account (Octopus Cloud)
3. Create your instance (e.g., `yourcompany.octopus.app`)

## Step 2: Install Octopus CLI (Optional - for local management)

### Windows
```powershell
choco install octopustools
```

### Or download directly
Download from: https://octopus.com/downloads/octopuscli

## Step 3: Create Project in Octopus

1. Login to your Octopus instance
2. Go to Projects → Add Project
3. Project name: `Weather API`
4. Project group: Default
5. Lifecycle: Default lifecycle

## Step 4: Create Environment

1. Go to Infrastructure → Environments
2. Click "Add Environment"
3. Name: `Production`
4. Click "Save"

## Step 5: Create AWS Account in Octopus

1. Go to Infrastructure → Accounts
2. Click "Add Account"
3. Account Type: AWS Account
4. Name: `AWS Production`
5. Access Key: (Your AWS access key)
6. Secret Key: (Your AWS secret key)
7. Click "Save and Test"

## Step 6: Configure Deployment Process

1. Go to your project → Process
2. Click "Add Step"
3. Choose "Deploy an Amazon ECS Service"
4. Step name: `Deploy Weather API`
5. Configure:
   - AWS Account: AWS Production
   - Region: us-east-1
   - Cluster Name: weather-api-cluster
   - Service Name: weather-api-service
   - Task Definition Family: weather-api-task
   - Container Name: weather-api
   - Container Image: `#{AWS.ECR.Registry}/weather-api:#{ImageTag}`

## Step 7: Create Variables

1. Go to your project → Variables
2. Add these variables:
   - `AWS.ECR.Registry`: `<your-account-id>.dkr.ecr.us-east-1.amazonaws.com`
   - `ImageTag`: (This will be set by GitHub Actions)

## Step 8: Create API Key

1. Go to Profile → My API Keys
2. Click "New API Key"
3. Purpose: `GitHub Actions Integration`
4. Copy the API key (save it securely)

## Step 9: Test Deployment

1. Create a release manually
2. Deploy to Production environment
3. Verify the service updates in ECS

## Alternative: Octopus Deploy Process JSON

If you prefer to import the deployment process, use the JSON configuration in `deployment-process.json`.

## Troubleshooting

### Common Issues:
1. **IAM Permissions**: Ensure your AWS account has ECS and ECR permissions
2. **Network Access**: Verify security groups allow traffic
3. **Task Definition**: Ensure the task definition exists and is valid
4. **Image URI**: Verify the ECR image URI is correct

### Logs:
- Check Octopus deployment logs
- Check ECS service events
- Check CloudWatch logs for the container