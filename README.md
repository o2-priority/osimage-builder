# artifact-builder
Build virtual machine images using packer

### Prerequisites
* Working Docker installation with docker-compose
* Please configure aws credentials with enough IAM privaledges to create AMIs.
* Credentials should be located in the standard ~/.aws/credentials file.
* Use AWS_PROFILE environment variable to specify credentials other than default.

### Build with Docker
Please make sure you have working AWS creds before you run this.
The docker compose configuration will try to mount your ~/.aws config files to use to comunicate with AWS.
```
export PROJECT="YourProject"
export OS_RELEASE="trusty-14.04"
export AWS_PROFILE=microdc-preprod
docker-compose up
```
