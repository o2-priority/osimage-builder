# artifact-builder
Build virtual machine images using packer

### Build an image
We currently only have one image so this is simply
```
export PROJECT="YourProject"
export OS_RELEASE="trusty-14.04"
packer build -var "project=${PROJECT}" -var "os_release=${OS_RELEASE}" ubuntu-amd64-aws-ebs.json
```

### Build with Docker
```
PROJECT="YourProject" OS_RELEASE="trusty-14.04" docker-compose up
```
