# Provision Amazon ECS cluster

## Create bucket for storing the Terraform state

Enter into the **s3** subfolder:

```console
$ cd s3/
```

Open **main.tf** file and change the value of:

```hcl
  bucket = "terraform-state-it-sunnyvale"
```
with a unique bucket name. Then note this name down, you will use it again later.

Once ready, create the S3 bucket on AWS.

```console
$ terraform init && \
  terraform apply -target=aws_s3_bucket.terraform_state -auto-approve
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## Provision Amazon ECS cluster

Enter into the **ecs** subfolder:

```console
$ cd ecs/
```
Open **backend.tf** file and set the value of:

```hcl
  bucket = "terraform-state-it-sunnyvale"
```
with the bucket name you used up above.

Once ready, create the ECS cluster on AWS.

```console
$ terraform init && \
  terraform apply -target=aws_ecs_cluster.ecs-cluster -auto-approve
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

