import os
from pathlib import Path
import shutil
import ssl
import subprocess
import sys
from typing import Dict

def export_certs():
    pems = []
    cert_file = Path.home() / "windows_certs.pem"
    for storename in ("CA", "ROOT"):
        for cert in ssl.enum_certificates(storename):
            pems.append(ssl.DER_cert_to_PEM_cert(cert[0]))
    if cert_file.exists():
        cert_data = cert_file.read_text()
    else:
        cert_data = ""
    pems = [pem for pem in pems if pem not in cert_data]
    cert_data = "\n".join([cert_data] + pems).strip()
    cert_file.write_text(cert_data)

def get_windows_home() -> Path:
    prefix = "/mnt/c/Users/"
    path = next(p for p in os.environ["PATH"].split(":") if p.startswith(prefix))
    user = Path(path[:path.index("/", len(prefix)+1)])
    return user

def import_certs():
    cert_bundle = get_windows_home() / "windows_certs.pem"
    target = "/usr/local/share/ca-certificates/windows.crt"
    shutil.copy2(str(cert_bundle), target)
    subprocess.run(["sudo", "update-ca-certificates"])
    wgetrc = Path.home() / ".wgetrc"
    config = read_wgetrc(wgetrc)
    config["ca_certificate"] = target
    write_wgetrc(wgetrc, config)

def read_wgetrc(file:Path) -> Dict[str,str]:
    if not file.exists():
        return {}
    data = {}
    with file.open("r") as f:
        for line in f.readlines():
            k,v = line.split("=", maxsplit=1)
            data[k.strip()] = v.strip()
    return data

def write_wgetrc(file:Path, config: Dict[str,str]) -> None:
    with file.open("w") as f:
        for pair in config.items():
            f.write(" = ".join(pair))
            f.write("\n")


if __name__ == "__main__":
    if sys.platform.startswith("win"):
        export_certs()
    else:
        import_certs()
