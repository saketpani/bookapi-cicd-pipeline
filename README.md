# .NET API CI/CD Pipeline with GitHub Actions, ECR, ECS Fargate & Octopus Deploy

This project demonstrates a complete CI/CD pipeline for a .NET API using:
- GitHub Actions for CI/CD
- Amazon ECR for container registry
- Amazon ECS with Fargate for deployment
- Octopus Deploy for deployment orchestration

## Project Structure
```
├── src/
│   └── WeatherApi/
│       ├── Controllers/
│       ├── Program.cs
│       ├── WeatherApi.csproj
│       └── Dockerfile
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── octopus/
│   ├── deployment-process.json
│   └── variables.json
└── aws-setup/
    └── setup-instructions.md
```

## Prerequisites
- AWS Account
- GitHub Account
- Octopus Deploy Account (free tier available)
- Docker Desktop
- .NET 8 SDK
- AWS CLI
- Octopus CLI

## Quick Start
1. Follow AWS setup instructions in `aws-setup/setup-instructions.md`
2. Configure GitHub secrets
3. Set up Octopus Deploy
4. Push code to trigger pipeline

## Architecture
```
GitHub → GitHub Actions → Build → ECR → Octopus Deploy → ECS Fargate
```