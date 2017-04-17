@ECHO OFF

@FOR /f "delims=" %%i in ('aws elb describe-load-balancers --load-balancer-name minecraft --query "LoadBalancerDescriptions[*].CanonicalHostedZoneName" --output text') do SET DNS=%%i
IF "%DNS%"=="" (
 @ECHO No DNS record found.  The server is probably not deployed.
) ELSE (
 @ECHO DNS is: %DNS%
)

@FOR /f "delims=" %%i in ('aws ec2 describe-instances --filter "Name=tag-value,Values=minecraft" --query "Reservations[].Instances[].PublicIpAddress" --output text') do SET IP=%%i
IF "%IP%"=="" (
 @ECHO No IP detected. The server is scheduled to start at 6:45PM CDT
) ELSE (
 @ECHO IP is: %IP%
)
