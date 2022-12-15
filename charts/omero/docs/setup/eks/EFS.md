# setup/EKS/EFS.md

* https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

## Create an IAM policy and role

eksctl template file snippet

```
iam:
  serviceAccounts:
    - metadata:
        name: efs-csi-controller-sa
        namespace: kube-system
      wellKnownPolicies:
        efsCSIController: true
```

## Install the Amazon EFS driver

GitOps Flux: /infrastructure/aws/sources/aws-efs-csi-driver.yaml

```
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: aws-efs-csi-driver
  namespace: flux-system
spec:
  interval: 5m0s
  url: https://kubernetes-sigs.github.io/aws-efs-csi-driver/
```

* https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
* GitOps Flux
  * /infrastructure/aws/base/aws-efs-csi-driver.yaml
  * infrastructure/aws/base/kustomization.yaml

## Create an Amazon EFS file system

```bash
EKS_CLUSTER_NAME='template'

VPC_ID=$(aws eks describe-cluster --name $EKS_CLUSTER_NAME \
  --query "cluster.resourcesVpcConfig.vpcId" \
  --output text)

CIDR_RANGE=$(aws ec2 describe-vpcs --vpc-ids $VPC_ID \
  --query "Vpcs[].CidrBlock" \
  --output text)

aws cloudformation create-stack --stack-name eks-${EKS_CLUSTER_NAME}-EFS --template-body file://./setup/efs.cf.yaml \
  --parameters \
    ParameterKey=EksClusterName,ParameterValue=${EKS_CLUSTER_NAME} \
    ParameterKey=EksClusterVpcCidrBlock,ParameterValue=${CIDR_RANGE} \
    ParameterKey=EksClusterVpcId,ParameterValue=${VPC_ID}

#aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
#  --query 'Subnets[*].{SubnetId: SubnetId,AvailabilityZone: AvailabilityZone,CidrBlock: CidrBlock}' \
#  --output table

eval $( \
  aws cloudformation describe-stacks --stack-name eks-${EKS_CLUSTER_NAME}-EFS --query 'Stacks[0].Outputs' \
    |jq -r '.[]|[.OutputKey,.OutputValue]|join("=")' \
)

aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[*].SubnetId' --output text |xargs -n1 \
  aws efs create-mount-target --file-system-id $EfsFileSystemId --security-groups $EfsSecurityGroupId --subnet-id
```
