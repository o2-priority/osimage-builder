#!/bin/bash

#Install the IAMauthorizedKeys script
#this is used by sshd to authorise iam ssh users

ubuntu_version="`lsb_release -r | awk '{print $2}'`"
major_version="`echo $ubuntu_version | awk -F. '{print $1}'`"

#install required tools
if ! which aws; then
  apt-get update
  apt-get install -y libyaml-dev python-dev python-pip
  pip install awscli
fi

cat > /usr/local/bin/IAMauthorizedKeys.sh << EOF
#!/bin/bash -e

err() {
  local MSG="\${@}"
  echo "[ERR] \${MSG}"
  exit 1
}

log() {
  local MSG="\${@}"
  echo "[LOG] \${MSG}"
}

if [ -z "\${1}" ]; then
  err "no user given"
fi

USER="\${1}"

aws iam list-ssh-public-keys --user-name "\${USER}" --query "SSHPublicKeys[?Status == 'Active'].[SSHPublicKeyId]" --output text | while read -r KeyId; do
  aws iam get-ssh-public-key --user-name "\${USER}" --ssh-public-key-id "\${KeyId}" --encoding SSH --query "SSHPublicKey.SSHPublicKeyBody" --output text
done
EOF

chmod +x /usr/local/bin/IAMauthorizedKeys.sh

if grep -q 'AuthorizedKeysCommand ' /etc/ssh/sshd_config; then
    sed -i 's#.*AuthorizedKeysCommand .*#AuthorizedKeysCommand /usr/local/bin/IAMauthorizedKeys.sh#' /etc/ssh/sshd_config
else
    echo "AuthorizedKeysCommand /usr/local/bin/IAMauthorizedKeys.sh" >> /etc/ssh/sshd_config
fi

if grep -q 'AuthorizedKeysCommandUser ' /etc/ssh/sshd_config; then
    sed -i 's#.*AuthorizedKeysCommandUser .*#AuthorizedKeysCommandUser root#' /etc/ssh/sshd_config
else
    echo "AuthorizedKeysCommandUser root" >> /etc/ssh/sshd_config
fi

