#!/bin/bash
#

set -e

BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)
WORK_PATH=${BIN_PATH}/../

SSH_KEYS='
---start
ubuntu
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMQ0sgNiT0KpQtonlsXeBJ9nLYaFSzX6ZOEDB9p4cY2 ubuntu@ef93a962cdb9
xavier
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDI/wKo1TKfYVeIaj4IKb1oiHTFuy+gfuEfuAVTAfzhbtsFK3XHfEQGlykdDJZHAib1UbwNhNAzKrPmXc36JLdf22vRmEieYQCFfccys7xHdWG4xtnCwp2VeHWIODjGMNaKmglhghIER6sZlkuzflPhhS8plUG1SpkS3s/J2kRYdk2vXPCIp7zuzh8LJn5SF8x+UeaYsUyV288mxTYwCZPtYpJyEU90rDeuiA3H94+B0jcdBZHAQZEUhGtYyUNm/0v8oJKqD6wRAiqrNtVMcR5hkGLrgaK5r5+Tjq8IkHn6AfxfdEbMYJolRygaXyG0opNQHPiOTpTbqiuKt5jS5L1j xavier@inv.cafe
fewensa
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUtxwehmQ4PoLzR6uVwtyCfinijs8KW6HWpzAJxe5S1gJjhffFXInD9md8hRr+41a792rQVVy2HAmNBWIc4DJkPQ3tptf4n2xf+Sdv5DQOP83/f+74aW2JWjg5U/v9B4WxcbIE+qrPJ4VutuOXHOcm2c7KVv2YfdU7qCEh5r+jUA1s1Ee6ZcVUfZ3HT3uo1G0PoofbHEUWSCVY9zypVU78MXGjEc8r2mABvVW2OZgkIzazI4Qg6c9xTy1vAU7ZTRBKD8SurU7+kSQepk7faWgnPOC6LZLuHmmQnNEUFzb6zIPlciDtkNg14/7wPQoKhvF0S1z9c4i/rBgjbqAyhUlnm4VfD77UjVTinsQE+/RUFkSk8vpqW6mbb8QEY1f6eN08ANysl0xkKtd0c4pw0Fi4V3H3aLThUjOZI9wLVpvUZiRGrC3aB0yVIMvlhmhvGSUQNI54NdCVnayrFyvsJu/8AW/KU99oBrrtoSFhw2td/2rlkSph9LM8vaVKBgxQ3zk= fewensa@akafw
ansible
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMROHpqaz28Olg19wo5fF6LtbSC7aSU8G0Nk2i3YTmav ansible@08b9c3fbaaf1
---end
'

IFS=$'\n'

PROCESSING=false
FJUMP=1
USERNAME=
NEWUSER=false

for LINE in $SSH_KEYS; do
  if [ "${LINE}" == "---end" ]; then
    break
  fi
  if [ "${LINE}" == "---start" ]; then
    PROCESSING=true
    continue
  fi
  if [ "${PROCESSING}" == "false" ]; then
    continue
  fi

  if [ "${FJUMP}" == "1" ]; then
    USERNAME=${LINE}
    if id "$LINE" &>/dev/null; then
      NEWUSER=fasle
      echo "${LINE} exists"
    else
      useradd -m ${LINE}
      echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
      mkdir -p /home/$USERNAME/.ssh
      NEWUSER=true
      echo 'created '${LINE}
    fi

    FJUMP=2
  else
    if [ "${NEWUSER}" == "true" ]; then
      echo ${LINE} >> /home/$USERNAME/.ssh/authorized_keys
      chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh/
      chmod 700 /home/$USERNAME/.ssh/
      chmod 600 /home/$USERNAME/.ssh/authorized_keys
    fi
    FJUMP=1
    USERNAME=''
    NEWUSER=fasle
  fi
done

