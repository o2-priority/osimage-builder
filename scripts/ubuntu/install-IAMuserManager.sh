#!/bin/bash

#Install the IAMuserManager script and systemd jobs
#The script gets a list of iam users in the group ssh-access using the aws cli then adds them as local users if they dont exist
#any users that have been removed from the ssh-access group are deleted.

ubuntu_version="`lsb_release -r | awk '{print $2}'`"
major_version="`echo $ubuntu_version | awk -F. '{print $1}'`"

#install required tools
if ! which aws  || ! which jq; then
  apt-get update
  apt-get install -y libyaml-dev python-dev python-pip jq
  pip install awscli
fi

cat > /usr/local/bin/IAMuserManager.sh << EOF
#!/bin/bash

err() {
  local MSG="\${@}"
  echo "[ERR] \$MSG"
  exit 1
}

log() {
  local MSG="\${@}"
  echo "[LOG] \$MSG"
}

get_public_key() {

aws iam get-ssh-public-key --user-name aplatt --ssh-public-key-id APKAJ5QAX2E7AQEGE73A --encoding SSH
}

IAM_USERS="\$(aws iam get-group --group-name ssh-access | jq -r '.Users[] | .UserName')" || err "Cant get list of users from IAM"
LOCAL_USERS=\$(grep IAMuser /etc/passwd | cut -f 1 -d ':') || err "Cant get list of local IAM users"

for user in \$IAM_USERS; do
  if ! echo \$LOCAL_USERS | grep -q \$user; then
    id \$user >/dev/null 2>&1 || \
    log "adding local user \${user} found in IAM" && \
    useradd --create-home -m -G sudo -c "IAMuser" "\${user}"  > /dev/null 2>&1
  fi
done

for user in \$LOCAL_USERS; do
  if ! echo \$IAM_USERS | grep -q \$user; then
    log "removing \${user} as they are no longer in IAM"
    userdel -rf "\${user}" > /dev/null 2>&1
  fi
done
EOF

chmod +x /usr/local/bin/IAMuserManager.sh

ubuntu_version="`lsb_release -r | awk '{print $2}'`"
major_version="`echo $ubuntu_version | awk -F. '{print $1}'`"

output() {
  echo "$1"
}

if [ "$major_version" -eq "16" ]; then

cat > /etc/systemd/system/iam-user-management.service << EOF
[Unit]
Description=Add/remove Users in IAM ssh-access group

[Service]
TimeoutStartSec=60
Type=oneshot
User=root
ExecStart=/usr/local/bin/IAMuserManager.sh

[Install]
WantedBy=multi-user.target

EOF

cat > /etc/systemd/system/iam-user-management.timer << EOF
[Unit]
Description=Add/remove Users in IAM ssh-access group

[Timer]
OnBootSec=0min
OnCalendar=*:0/5
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl enable iam-user-management.timer
systemctl start iam-user-management.timer

else
  echo '*/15 * * * * root /usr/local/bin/IAMuserManager.sh' > /etc/cron.d/IAMuserManager
fi
