# Push your image to Amazon ECR repository

## Prerequisites

The following labs have to be completed:

- 16 - Setup Amazon Account
- 18 - Provision Amazon ECR repository



The following softwares must be installed on your PC:

- AWS cli tool must be installed on your computer (more at https://aws.amazon.com/it/cli/)
- Docker (more at https://www.docker.com)

## 

Configure the AWS cli (remember to type your AWS Access Key and AWS Secret Access Key with the one created in lab 16)

```console
$ aws configure
AWS Access Key ID [None]: XXXXXXXXXXXXXXXXXXX
AWS Secret Access Key [None]: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
Default region name [None]: eu-west-1
Default output format [None]: json
```

Obtain the `docker login` command to authenticate to ECR

```console
$ aws ecr get-login --region eu-west-1 --no-include-email
docker login -u AWS -p jhGGDEDEHHDHHDWHKKWHBDKEBDEKH https://238764214477.dkr.ecr.eu-west-1.amazonaws.com
```

Type the `docker login` command (remember to change the value of -p flag with your AWS provided password)


```console
$ docker login -u AWS -p jhGGDEDEHHDHHDWHKKWHBDKEBDEKH https://238764214477.dkr.ecr.eu-west-1.amazonaws.com
Login Succeeded
```

Build your image (remember to change the tag with your ECR name)

```console
$ docker build -t 238764214477.dkr.ecr.eu-west-1.amazonaws.com/friendlyhello:1.0 .
...
Successfully tagged 238764214477.dkr.ecr.eu-west-1.amazonaws.com/friendlyhello:1.0
```

Push the image (remember to change the tag with your ECR name)

```console
$ docker push 238764214477.dkr.ecr.eu-west-1.amazonaws.com/friendlyhello:1.0  
The push refers to repository [238764214477.dkr.ecr.eu-west-1.amazonaws.com/friendlyhello]
b4fdc744d578: Pushed 
640a99287685: Pushed 
df50c2a6d175: Pushed 
7a287aad297b: Pushed 
7ea2b60b0a08: Pushed 
568944187d93: Pushed 
b60e5c3bcef2: Pushed 
1.0: digest: sha256:e24cdf14d1ce8be9a579299bf5c60e3a913d30a4952ed869d817b662cc836866 size: 1788
```