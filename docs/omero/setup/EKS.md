# setup/EKS.md

## ACK

Ref.
* https://aws-controllers-k8s.github.io/community/docs/user-docs/install/

Helm charts
* gallery.ecr.aws/aws-controllers-k8s/$SERVICENAME-chart

* gallery.ecr.aws/aws-controllers-k8s/s3-chart
* gallery.ecr.aws/aws-controllers-k8s/rds-chart

```bash
# https://github.com/aws/aws-cli/issues/5917
aws ecr-public get-login-password --region us-east-1
```
