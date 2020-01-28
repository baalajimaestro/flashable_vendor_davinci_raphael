from requests import get
from datetime import datetime as dt
import yaml
import sys

yaml_name = sys.argv[1]+".yml"
edition = sys.argv[2]

if edition == "EA":
   array_index = 3
elif edition == "GB":
    array_index = 0
elif edition =="IN":
    array_index =0

with open(yaml_name, 'wb') as load:
    load.write(get("https://raw.githubusercontent.com/XiaomiFirmwareUpdater/xiaomifirmwareupdater.github.io/master/data/devices/latest/"+yaml_name).content)
fw = yaml.safe_load(open(yaml_name).read())
if edition == "CN":
    stable_date = dt.strptime(fw[1]["date"], "%Y-%m-%d")
    weekly_date = dt.strptime(fw[3]["date"], "%Y-%m-%d")
    if stable_date > weekly_date:
        URL="https://bigota.d.miui.com/"
        version=fw[1]["versions"]["miui"]
        with open('/tmp/version','wb') as load:
            load.write(str.encode(version))
        URL+=version
        URL+="/"
        file=fw[1]["filename"]
        file=file[11:]
        URL+=file
        print("Fetching Stable China ROM......")
    else:
        if edition == "CN":
            URL="https://bigota.d.miui.com/"
            version=fw[2]["versions"]["miui"]
            with open('/tmp/version','wb') as load:
                load.write(str.encode(version))
            URL+=version
            URL+="/"
            file=fw[2]["filename"]
            file=file[11:]
            URL+=file
            print("Fetching Weekly China ROM......")
else:
    URL="https://bigota.d.miui.com/"
    version=fw[array_index]["versions"]["miui"]
    with open('/tmp/version','wb') as load:
        load.write(str.encode(version))
    URL+=version
    URL+="/"
    file=fw[array_index]["filename"]
    file=file[11:]
    URL+=file
    print("Fetching Stable ROM......")

with open('rom.zip', 'wb') as load:
    load.write(get(URL).content)
