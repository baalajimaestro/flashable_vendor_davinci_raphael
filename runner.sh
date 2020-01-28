#! /bin/bash
# CI Runner Script for Generation of blobs

# We need this directive
# shellcheck disable=1090

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
    git clone https://github.com/XiaomiFirmwareUpdater/xiaomi-flashable-firmware-creator.py
    mv /app/get_rom.py xiaomi-flashable-firmware-creator.py/xiaomi_flashable_firmware_creator/
    cd xiaomi-flashable-firmware-creator.py/xiaomi_flashable_firmware_creator/
}

push_flashable_zip()
{
  python3 create_flashable_firmware.py -V rom.zip
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
   sendTG "\`Extracting Vendor for Davinci EEA!\`"
   python3 get_rom.py davinci EA
   push_flashable_zip davinci
   sendTG "\`Extracting Vendor for Davinci CN!\`"
   python3 get_rom.py davinci CN
   push_flashable_zip davinci
   sendTG "\`Extracting Vendor for Davinci EEA!\`"
   python3 get_rom.py davinci GB
   push_flashable_zip davinci
}

davinciin()
{
  sendTG "\`Extracting Vendor for Davinci IN!\`"
  python3 get_rom.py davinciin
  push_flashable_zip davinci
}

raphael()
{
  sendTG "\`Extracting Vendor for Raphael EEA!\`"
  python3 get_rom.py raphael EA
  push_flashable_zip raphael
  sendTG "\`Extracting Vendor for Raphael CN!\`"
  python3 get_rom.py raphael CN
  push_flashable_zip raphael
  sendTG "\`Extracting Vendor for Raphael GB!\`"
  python3 get_rom.py raphael GB
  push_flashable_zip raphael
}

raphaelin()
{
  sendTG "\`Extracting Vendor for Raphael IN!\`"
  python3 get_rom.py raphaelin
  create_flashable_zip raphael
}

ssh_keys
build_env
davinci
davinciin
raphael
raphaelin
sendTG "[Flashable Vendors have been pushed](https://osdn.net/projects/baalajimaestrobuilds/storage/vendor/)"
