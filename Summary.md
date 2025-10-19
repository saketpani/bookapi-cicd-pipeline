CI/CD Pipeline Project : Built complete pipeline from .NET API to AWS ECS Fargate deployment with GitHub Actions and Octopus Deploy integration

Local Development : Created .NET 8 BookApi with 4 books, health endpoint, and Swagger UI, renamed from WeatherApi to BookApi

Docker Containerization : Built multi-stage Dockerfile, fixed HTTPS redirection and network binding issues, achieved 332s→7.6s build time improvement through caching

AWS Infrastructure : Set up ECR repository, ECS cluster with Fargate, task definitions, and ECS service with proper tagging strategy

IAM Security : Created programmatic IAM user with ECR/ECS permissions, generated access keys, tested CLI access with profiles

GitHub Setup : Created repository and configured secrets for AWS credentials

Key Insights
ECS Networking : Tasks get individual public IPs, not services - services manage multiple tasks

Docker Multi-stage : First build takes 332s (downloading images), subsequent builds 7.6s (cached layers)

AWS IAM Model : Users hold permissions, access keys are just authentication method - both needed together

AWS CLI Profiles : Multiple profiles don't override each other, stored in ~/.aws/ directory

GitHub Secrets : All values treated as "secrets" for security, but only AWS_SECRET_ACCESS_KEY is truly secret from AWS perspective

Resource Tagging : Implemented consistent tagging strategy (Project: BookAPI-CICD, Environment: Learning) for easy cleanup

Container Networking : Must bind to 0.0.0.0:80 not 127.0.0.1 for external access in containers
