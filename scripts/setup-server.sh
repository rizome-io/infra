#!/bin/bash
set -euxo pipefail
# TODO: configure swap size

USERNAME='lovelace'
INTERACTIVE='Y'

SSH_PORT=2222
CARDANO_NODE_PORT=3001

display_help() {
  echo "Usage: sudo $0 [option...] {start|stop|restart}" >&2
  echo
  echo "   -u, --username               username to be created"
  echo "   -m, --monitoring-host        monitoring host"
  echo "   -M, --main-host              allowed to ssh"
  echo "   -i, --non-interactive        disable interactions (password change)"
  echo
  # echo some stuff here for the -a or --add-options
  exit 1
}


while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -u|--username)
      USERNAME="$2"
      shift # past argument
      shift # past value
      ;;
    -M|--main-host)
      MAIN_HOST="$2"
      shift # past argument
      shift # past value
      ;;
    -i|--non-interactive)
      INTERACTIVE="N"
      shift # past argument
      ;;
    -m|--monitoring-host)
      MONITORING_HOST="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help|*)  # No more options
      display_help
      break
      ;;
  esac
done

# Login as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Update and install needed packages
apt update
apt -y upgrade
apt -y install git tmux ufw htop chrony curl rsync

# Create the $USERNAME user (do not switch user)
groupadd -g 1024 $USERNAME
useradd -m -u 1001 -g $USERNAME -s /bin/bash $USERNAME
usermod -aG sudo $USERNAME
if [ $INTERACTIVE = 'Y' ]
  then passwd $USERNAME
fi

# Configure chrony (use the Google time server)
cat > /etc/chrony/chrony.conf << EOM
server time.google.com prefer iburst minpoll 4 maxpoll 4
keyfile /etc/chrony/chrony.keys
driftfile /var/lib/chrony/chrony.drift
maxupdateskew 5.0
rtcsync
makestep 0.1 -1
leapsectz right/UTC
local stratum 10
EOM
timedatectl set-timezone UTC
systemctl stop systemd-timesyncd
systemctl disable systemd-timesyncd
systemctl restart chrony
# TODO: if not for pi
# hwclock -w

# Setup the Swap File
# fallocate -l 2G /swapfile
dd if=/dev/zero of=/swapfile bs=1024 count=2M
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab.back
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Setup SSH
cp -r ~/.ssh /home/$USERNAME
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
sed -i.bak1 "s/#Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
sed -i.bak2 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config
systemctl restart ssh

# Setup the firewall
ufw allow $CARDANO_NODE_PORT/tcp  # cardano-node port
ufw allow from $MAIN_HOST to any port $SSH_PORT proto tcp
ufw allow from $MONITORING_HOST to any port 9100 proto tcp
ufw allow from $MONITORING_HOST to any port 12798 proto tcp
ufw enable

cat > env <<EOF
CARDANO_NODE_PORT=$CARDANO_NODE_PORT
EOF

# Reboot
shutdown -r 0                                                                                                                                                                                                                         87        87,14         Bot
