# EKS setup

https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

Pre-req.

* OR
  * pre-provisioned EKS cluster
  * VPC + subnet + EKS cluster using pre-config. settings

Create external database and set credentials

```bash
eks_cluster_name='omerodev'
uuidv4=$(uuidgen)
master_password=$(uuidgen)

db_subnet_group_name=""
vpc_security_group=""

# https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-cluster.html
# aws rds describe-db-engine-versions --engine postgres --query "DBEngineVersions[].EngineVersion"
aws rds create-db-cluster --database-name omerodev \
 --backup-retention-period 1 \
 --database-name $eks_cluster_name \
 --db-cluster-identifier "${eks_cluster_name}-${uuidv4}" \
 --vpc-security-group-ids "string" "string" \
 --engine aurora-postgresql \
 --engine-version "14.5" \
 --port 5432 \
 --master-username omerodev-master \
 --master-user-password $master_password \
 --preferred-backup-window "" \
 --preferred-maintenance-window "" \
 --tags "Key=String,Value=string" \
 --storage-encrypted \
 --no-enable-iam-database-authentication \
 --enable-cloudwatch-logs-exports postgresql \
 --engine-mode provisioned \
 --no-deletion-protection \
 --copy-tags-to-snapshot \
 --no-publicly-accessible \
 --auto-minor-version-upgrade \
 --monitoring-interval 0 \
 --no-enable-performance-insights \
 --network-type IPV4 
```

```bash
eks_cluster_name='omerodev'

vpc_id=$(aws eks describe-cluster \
 --name $eks_cluster_name \
 --query "cluster.resourcesVpcConfig.vpcId" --output text)

cidr_range=$(aws ec2 describe-vpcs \
 --vpc-ids $vpc_id \
 --query "Vpcs[].CidrBlock" --output text)

security_group_id=$(aws ec2 create-security-group \
 --group-name MyEfsSecurityGroup \
 --description "My EFS security group" \
 --vpc-id $vpc_id \
 --output text)

aws ec2 authorize-security-group-ingress \
 --group-id $security_group_id \
 --protocol tcp \
 --port 2049 \
 --cidr $cidr_range

# --encrypted
file_system_id=$(aws efs create-file-system \
 --performance-mode generalPurpose \
 --throughput-mode bursting \
 --tags 'Key=sydney.edu.au/ResTek/project,Value=omero' \
 --query 'FileSystemId' --output text)

flux 
echo "fileSystemId: $file_system_id"

# https://docs.aws.amazon.com/efs/latest/ug/lifecycle-management-efs.html
aws efs put-lifecycle-configuration \
 --file-system-id $file_system_id \
 --lifecycle-policies '[{"TransitionToIA": "AFTER_60_DAYS"},{"TransitionToPrimaryStorageClass": "AFTER_1_ACCESS"}]'

subnet_id=$()

aws efs create-mount-target \
 --file-system-id $file_system_id \
 --security-groups $security_group_id \
 --subnet-id $subnet_id
```
