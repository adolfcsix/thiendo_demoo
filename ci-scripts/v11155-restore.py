#!/usr/bin/env python3
"""Restore the V11.155 candidate delta into a temporary CI checkout, never write to repository."""
from pathlib import Path
from zipfile import ZipFile
from hashlib import sha256
import base64
import io
import json

encoded = Path("ci-source-v11155/source-delta.zip.base64").read_bytes()
archive_bytes = base64.b64decode(b"".join(encoded.split()), validate=True)
assert sha256(archive_bytes).hexdigest() == "5ca39dc37d9af76e82407d2b5bb890b7a1d384d7779cf71100102bdc3792e272", "V11.155 delta signature mismatch"
with ZipFile(io.BytesIO(archive_bytes)) as archive:
    manifest = json.loads(archive.read("V11_155_PATCH_MANIFEST.json"))
    assert manifest["base"] == "V11.154.5-candidate" and manifest["target"] == "V11.155.0-candidate"
    items = manifest["files"]
    assert len(items) == 20
    assert set(archive.namelist()) == {entry["path"] for entry in items} | {"V11_155_PATCH_MANIFEST.json"}
    for entry in items:
        name = entry["path"]
        assert name and not name.startswith("/") and ".." not in Path(name).parts and "\\" not in name
        dst = Path("source") / name
        old = dst.read_bytes() if dst.is_file() else None
        current_hash = sha256(old).hexdigest() if old is not None else None
        assert current_hash == entry["oldSha256"], "Source drift: " + name
        content = archive.read(name)
        assert sha256(content).hexdigest() == entry["newSha256"], "Payload corruption: " + name
        dst.parent.mkdir(parents=True, exist_ok=True)
        dst.write_bytes(content)
print("PASS: V11.155 20 source changes independently hash-verified and restored")
