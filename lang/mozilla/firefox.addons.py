#!/usr/bin/env python3
"""Update firefox.addons.json versions from the live Firefox profile."""

import json
import os
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
TRACKED = SCRIPT_DIR / "firefox.addons.json"


def _find_profile() -> Path:
    yaml_path = SCRIPT_DIR.parent / "install.win.yaml"
    with open(yaml_path, encoding="utf-8") as f:
        lines = f.read().split("\n")

    for i, line in enumerate(lines):
        if line.strip() != "path: mozilla/firefox.user.js":
            continue
        # Walk up to find the parent key (target path, less indented)
        for j in range(i - 1, -1, -1):
            parent = lines[j].rstrip()
            if not parent or parent.startswith("-") or parent.strip() in ("link:",):
                continue
            if ":" in parent:
                # e.g. "    ~/scoop/persist/firefox-conf/profile/user.js:"
                target = parent.strip().rstrip(":")
                profile_dir = Path(os.path.expanduser(target)).parent
                addons = profile_dir / "addons.json"
                if addons.exists():
                    return addons
                sys.exit(f"addons.json not found at {addons}")

    sys.exit(f"firefox.user.js link not found in {yaml_path}")


def main() -> None:
    profile_path = _find_profile()

    with open(profile_path, encoding="utf-8") as f:
        profile_data = json.load(f)

    addons: list[dict[str, str]] = []
    for a in profile_data.get("addons", []):
        aid = a.get("id")
        if aid:
            addons.append({
                "id": aid,
                "name": a.get("name", ""),
                "amoListingURL": a.get("amoListingURL", ""),
            })

    addons.sort(key=lambda x: x.get("amoListingURL", ""))

    with open(TRACKED, "w", encoding="utf-8") as f:
        json.dump(addons, f, ensure_ascii=False, indent=4)
        f.write("\n")



if __name__ == "__main__":
    main()
