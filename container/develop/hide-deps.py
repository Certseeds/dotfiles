#!/usr/bin/env python3
"""Usage: hide-deps <prefix> -- <pattern...>

Move all entries from <prefix>/bin/ into .hide-deps/,
keeping only those whose basename matches at least one fnmatch pattern.
"""
import os
import sys
from fnmatch import fnmatch
from pathlib import Path


def main() -> None:
    sep = sys.argv.index("--")
    prefix = Path(sys.argv[1])
    patterns = sys.argv[sep + 1:]

    bin_dir = prefix / "bin"
    hide = bin_dir / ".hide-deps"
    hide.mkdir(parents=True, exist_ok=True)

    for f in bin_dir.iterdir():
        if f.name == ".hide-deps":
            continue
        if any(fnmatch(f.name, p) for p in patterns):
            continue
        f.rename(hide / f.name)


if __name__ == "__main__":
    main()
