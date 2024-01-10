import os
from pathlib import Path
import shutil
import ssl
import subprocess
import sys

def export_certs():
    pems = []
    cert_file = Path.home() / "windows_certs.pem"
    context = ssl.create_default_context()
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
    shutil.copy2(str(cert_bundle), "/usr/local/share/ca-certificates/windows.crt")
    subprocess.run(["sudo", "update-ca-certificates"])

if __name__ == "__main__":
    if sys.platform.startswith("win"):
        export_certs()
    else:
        import_certs()
