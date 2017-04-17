#!/bin/bash
#
set -e

dns=$(aws elb describe-load-balancers --load-balancer-name minecraft --query "LoadBalancerDescriptions[*].CanonicalHostedZoneName" --output text)
if [[ "${dns}" == "" ]]; then
  echo 'No DNS record found. The server is probably not deployed.'
else
  echo "DNS Name is: ${dns}"
fi

ip=$(aws ec2 describe-instances --filter Name=tag-value,Values=minecraft --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
if [[ "${ip}" == "" ]]; then
  echo 'No IP detected. The server is scheduled to start at 6:45PM CDT'
else
  echo "IP is: ${ip}"
fi
