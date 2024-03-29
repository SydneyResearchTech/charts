# omero/docs/smtp-aws.md

```bash
APP=###########
UUID=$(uuidgen |tr '[:upper:]' '[:lower:]'); UUID="${UUID##*-}"
USER_NAME="${APP}-${UUID}"

# Sanity check
echo $USER_NAME

# Create a system user
aws iam create-user --path "/" --user-name $USER_NAME \
--tags '[
{"Key": "sydney.edu.au/restek/created-by", "Value": "dean.taylor@sydney.edu.au"}
]'

# Attach policy to the user account allowing SMTP send
POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AmazonSesSendingAccess`].Arn' --output text)

# Sanity check
echo $USER_NAME
echo $POLICY_ARN

aws iam attach-user-policy \
--policy-arn $POLICY_ARN \
--user-name $USER_NAME

# Create an access key
read KEY_ID SECRET < <(aws iam create-access-key --user-name $USER_NAME --output json |jq -r '.AccessKey|.AccessKeyId,.SecretAccessKey' |tr \\n ' ')

echo "omero.mail.host = email-smtp.ap-southeast-2.amazonaws.com"
echo "omero.mail.password = $(~/bin/aws-ses-smtp-creds $SECRET ap-southeast-2)"
echo "omero.mail.port = 25"
echo "omero.mail.smtp.auth = true"
echo "omero.mail.smtp.starttls.enabled = true"
echo "omero.mail.username = $KEY_ID"
```

## Cleanup

```bash
aws iam list-access-keys --user-name $APPLICATION --query 'AccessKeyMetadata[].AccessKeyId' --output text \ 
|xargs -n1 aws iam delete-access-key --user-name $APPLICATION --access-key-id
```
