import os
from pathlib import Path
import re
import shutil
import ssl
import subprocess
import sys
from tempfile import TemporaryDirectory

def export_certs():
    pems = []
    cert_file = Path.home() / "windows_certs.pem"
    # context = ssl.create_default_context()
    for storename in ("CA", "ROOT"):
        for cert in ssl.enum_certificates(storename):
            cert_text = ssl.DER_cert_to_PEM_cert(cert[0])
            if cert_text not in pems:
                pems.append(cert_text)
    if cert_file.exists():
        cert_data = cert_file.read_text()
    else:
        cert_data = ""
    pems = [pem for pem in pems if pem not in cert_data]
    cert_data = "\n".join([cert_data] + pems).strip()
    _ = cert_file.write_text(cert_data)

def get_windows_home() -> Path:
    prefix = "/mnt/c/Users/"
    path = next(p for p in os.environ["PATH"].split(":") if p.startswith(prefix))
    user = Path(path[:path.index("/", len(prefix)+1)])
    return user

def import_certs():
    cert_bundle = get_windows_home() / "windows_certs.pem"
    certificates = re.split(r"\r?\n\r?\n", cert_bundle.read_text(),)
    destination = Path('/usr/local/share/ca-certificates/')
    with TemporaryDirectory() as tmpdir:
        td = Path(tmpdir)
        for i, cert in enumerate(certificates):
            out_file = td / f'windows_{i}.crt'
            _ = out_file.write_text(cert)
            _ = subprocess.run(["sudo", "cp", str(out_file), str(destination / out_file.name)])
    _ = subprocess.run(["sudo", "update-ca-certificates"])
    _ = shutil.copy2(str(cert_bundle), str(Path.home() / "windows_certs.crt"))

if __name__ == "__main__":
    if sys.platform.startswith("win"):
        export_certs()
    else:
        import_certs()
