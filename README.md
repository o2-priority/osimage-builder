# artifact-builder
Build virtual machine images using packer

### Prerequisites
*building with docker*
* Working Docker installation with docker-compose
* Please configure aws credentials with enough IAM privaledges to create AMIs.
* Credentials should be located in the standard ~/.aws/credentials file.
* Use AWS_PROFILE environment variable to specify credentials other than default.

*building local vagrant boxes*
* Working packer install
* Working VirtualBox install

### Build AMI with Docker
Please make sure you have working AWS creds before you run this.
The docker compose configuration will try to mount your ~/.aws config files to use to comunicate with AWS.
If you dont have a ~/.aws folder or are using a CI tool then you can also set env vars for aws credentials
*Optional*
```
export AWS_ACCESS_KEY_ID="accesskey"
export AWS_SECRET_ACCESS_KEY="secretaccesskey"
export AWS_DEFAULT_REGION="eu-west-1" #defaults to eu-west-1
```
*Required*
```
export PROJECT="YourProject" #defaults to none
export OS_RELEASE="trusty-14.04" #defaults to trusty-14.04
export AWS_PROFILE=microdc-preprod #defaults to default
docker-compose up
```
*or in one line accepting the defaults*
```
PROJECT="YourProject" docker-compose up
```

### Build Vagrant images
#### 1. Build fresh virtualbox image
```
packer build ubuntu-trusty-14.04-amd64-virtualbox-fresh.json
```
This should output the following image:
packer-ubuntu-trusty-14.04-amd64-fresh-virtualbox/ubuntu-trusty-14.04-amd64-fresh.ovf

#### 2. Build roles using image from step 1
```
OS_RELEASE=trusty-14.04 packer build ubuntu-base-amd64-vagrant.json
```
This should give you the artifact ready for use with vagrant:
builds/base-ubuntu-trusty-14.04-amd64-vagrant.box

### Use vagrant to bring up a role locally
```
vagrant box add builds/base-ubuntu-trusty-14.04-amd64-vagrant.box
vagrant up
```
