#! /bin/bash
#
# Copyright © 2019 Maestro Creativescape
#
# SPDX-License-Identifier: GPL-3.0
#
# CI Runner Script for Generation of blobs

function sendTG() {
    curl -s "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendmessage" --data "text=${*}&chat_id=-1001427544283&disable_web_page_preview=true&parse_mode=Markdown" > /dev/null
}

ssh_keys() {
  echo "**MaestroCI Flashable Vendor Extractor**"
  mkdir -p /home/ci/.ssh
  curl -sL -u baalajimaestro:$GH_PERSONAL_TOKEN -o /home/ci/.ssh/id_ed25519 https://raw.githubusercontent.com/baalajimaestro/keys/master/id_ed25519
  chmod 600 ~/.ssh/id_ed25519
  echo "SSH Keys Set!"

}

build_env() {
    cd ~
    sendTG "\`Vendor Extraction Job Rolled!\`"
    sudo apt install python3 python3-pip -y &> /dev/null
    sudo pip3 install requests pyYaml  &> /dev/null
    git clone https://github.com/XiaomiFirmwareUpdater/xiaomi-flashable-firmware-creator.py
    mv /app/get_rom.py xiaomi-flashable-firmware-creator.py/xiaomi_flashable_firmware_creator/
    cd xiaomi-flashable-firmware-creator.py/xiaomi_flashable_firmware_creator/
}

push_flashable_zip()
{
  python3 create_flashable_firmware.py -V rom.zip

  if [ "$1" == "davinci" ]; then
    mv fw-vendor* "fw-vendor_davinci-$2-$(cat /tmp/version).zip"
    if [ "$2" == "EA" ]; then
      sed -i 's/P/Q/g' /tmp/version
    fi
  elif [ "$1" == "davinciin" ]; then
    mv fw-vendor* "fw-vendor_davinciin-$2-$(cat /tmp/version).zip"
    sed -i 's/P/Q/g' /tmp/version
  elif [ "$1" == "raphaelin" ]; then
    mv fw-vendor* "fw-vendor_raphaelin-$2-$(cat /tmp/version).zip"
  elif [ "$1" == "raphael" ]; then
    mv fw-vendor* "fw-vendor_raphael-$2-$(cat /tmp/version).zip"
  fi
  if [ "$1" == "davinci" ]; then
  scp  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r fw-vendor_davinci* baalaji20@storage.osdn.net:/storage/groups/b/ba/baalajimaestrobuilds/vendor/davinci/
  else
  scp  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r fw-vendor_raphael* baalaji20@storage.osdn.net:/storage/groups/b/ba/baalajimaestrobuilds/vendor/raphael/
  fi
  rm -rf rom.zip
  rm -rf fw-vendor*
}


davinci()
{
   echo "davinci1"
   python3 get_rom.py davinci EA
   push_flashable_zip davinci EA
   echo "davinci2"
   python3 get_rom.py davinci CN
   push_flashable_zip davinci CN
   echo "davinci3"
   python3 get_rom.py davinci GB
   push_flashable_zip davinci GB
}

davinciin()
{
  python3 get_rom.py davinciin IN
  push_flashable_zip davinciin IN
}

raphael()
{
  python3 get_rom.py raphael EA
  push_flashable_zip raphael EA
  python3 get_rom.py raphael CN
  push_flashable_zip raphael CN
  python3 get_rom.py raphael GB
  push_flashable_zip raphael GB
}

raphaelin()
{
  python3 get_rom.py raphaelin IN
  push_flashable_zip raphaelin IN
}

ssh_keys
build_env
davinci
davinciin
raphael
raphaelin
sendTG "[Flashable Vendors have been pushed](https://osdn.net/projects/baalajimaestrobuilds/storage/vendor/)"
