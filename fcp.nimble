[Package]
name = "fcp"
version = "0.1.0"
author = "Ryan Gonzalez"
description = "A fast, multi-threaded file copy utility"
license = "MIT"
bin = "fcp"
InstallFiles = """
fcp.nim
fcp.nim.cfg
"""

[Deps]
requires = "nim >= 0.10.3"
