"""
Setup borrowed from ruff:
https://github.com/astral-sh/ruff/blob/main/python/ruff/__main__.py
"""

import os
import subprocess
import sys
import sysconfig
from pathlib import Path


def find_x13_bin() -> Path:
    """Return the X13 ARIMA-SEATS binary path."""

    x13_exe = "x13ashtml" + sysconfig.get_config_var("EXE")

    path = Path(sysconfig.get_path("scripts")) / x13_exe
    if path.is_file():
        return path

    if sys.version_info >= (3, 10):
        user_scheme = sysconfig.get_preferred_scheme("user")
    elif os.name == "nt":
        user_scheme = "nt_user"
    elif sys.platform == "darwin" and sys._framework:
        user_scheme = "osx_framework_user"
    else:
        user_scheme = "posix_user"

    path = Path(sysconfig.get_path("scripts", scheme=user_scheme)) / x13_exe
    if path.is_file():
        return path

    raise FileNotFoundError(path)


if __name__ == "__main__":
    x13 = find_x13_bin()
    completed_process = subprocess.run([x13, *sys.argv[1:]])
    sys.exit(completed_process.returncode)
