# artifact-builder
Build virtual machine images using packer

### Build an image
We currently only have one image so this is simply
```
export PROJECT="YourProject"
packer build -var "project=${PROJECT}" ubuntu-16.04-amd64-aws-ebs.json
```

### Build with Docker
```
export PROJECT="YourProject"
docker-compose up
```
