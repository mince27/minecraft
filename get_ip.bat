@ECHO OFF
aws ec2 describe-instances --filter Name=tag-value,Values=minecraft --query "Reservations[*].Instances[*].PublicIpAddress" --output text
