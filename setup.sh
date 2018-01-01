#!/usr/bin/env bash
command=`command -v aws | wc -m`

if [[ command -gt 0 ]]
then
   echo "AWS CLI already present"
else
   pip install awscli --upgrade --user
fi

echo "Creating s3 deployment bucket"
aws s3api create-bucket --bucket techgig.infra

echo "uploading Infrastructure cloudfomation scripts to bucket"
ls=`ls infrastructure/`

for files in $ls
do
files=`echo $files | xargs`

echo "Uploading $files"
aws s3 cp infrastructure/$files s3://techgig.infra/$files
done

echo "Deploying dev environment"
aws cloudformation create-stack --stack-name dev --template-body file://infrastructure/master.yaml

echo "Deploying stagging environment"
aws cloudformation create-stack --stack-name staging --template-body file://infrastructure/master.yaml

echo "Deploying Production environment"
aws cloudformation create-stack --stack-name production --template-body file://infrastructure/master.yaml

echo "Deploying Jenkins"
aws cloudformation create-stack --stack-name jenkins --template-body file://infrastructure/jenkins.yaml