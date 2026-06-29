#!/usr/bin/env python3
"""Fetch latest versions from npmmirror and write to version files."""

import json
import re
import sys
from pathlib import Path
from urllib.request import urlopen

NPM_MIRROR = "https://registry.npmmirror.com"
ADOPTIUM_MIRROR = "https://mirrors.tuna.tsinghua.edu.cn/Adoptium"
JDK_LTS_VERSIONS = [25, 21, 17, 11, 8]
MAVEN_MIRROR = "https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3"
GOLANG_MIRROR = "https://mirrors.aliyun.com/golang"
SCRIPT_DIR = Path(__file__).resolve().parent


def fetch_python_version() -> tuple[str, str, str]:
    """
    Return (version, build_date, binary_type).

    Logic: find the latest build date directory, list all python versions in it,
    pick the highest stable minor, subtract 2, and take the max patch for that minor.
    """
    binary_type = "x86_64_v3"

    # Get latest build date directory
    index_html = urlopen(f"{NPM_MIRROR}/-/binary/python-build-standalone/").read().decode()
    dates = re.findall(r'(\d{8})/', index_html)
    latest_date = max(dates)

    # Get all cpython versions for our target arch in this build
    dir_url = f"{NPM_MIRROR}/-/binary/python-build-standalone/{latest_date}/"
    listing = urlopen(dir_url).read().decode()

    pattern = re.compile(
        r'cpython-(\d+\.\d+\.\d+)\+' + latest_date + r'-x86_64_v3-unknown-linux-gnu-install_only\.tar\.gz'
    )
    versions = pattern.findall(listing)

    # Group by major.minor, keep max patch
    minor_map: dict[str, str] = {}
    for v in versions:
        parts = v.split(".")
        key = f"{parts[0]}.{parts[1]}"
        if key not in minor_map or v > minor_map[key]:
            minor_map[key] = v

    sorted_minors = sorted(minor_map.keys(), key=lambda x: tuple(map(int, x.split("."))))
    latest_minor = sorted_minors[-1]
    major, minor = map(int, latest_minor.split("."))
    target_minor = f"{major}.{minor - 2}"

    if target_minor not in minor_map:
        sys.exit(f"Python {target_minor} not found in build {latest_date}. Available: {sorted_minors}")

    return minor_map[target_minor], latest_date, binary_type


def fetch_node_lts() -> str:
    """Return the latest LTS node version (with v prefix)."""
    data = json.loads(urlopen(f"{NPM_MIRROR}/-/binary/node/index.json").read())

    lts_versions = [
        tuple(map(int, v["version"].lstrip("v").split(".")))
        for v in data if v.get("lts")
    ]
    latest = max(lts_versions, key=lambda x: (x[0], x[1], x[2]))
    return f"v{latest[0]}.{latest[1]}.{latest[2]}"


def fetch_pnpm_version() -> str:
    """Return the latest pnpm version."""
    data = json.loads(urlopen(f"{NPM_MIRROR}/pnpm/latest").read())
    return data["version"]


def fetch_jdk_lts() -> tuple[int, str]:
    """Return (major_version, full_version) for the latest available LTS JDK on Adoptium."""
    index_html = urlopen(f"{ADOPTIUM_MIRROR}/").read().decode()
    available = set(map(int, re.findall(r'href="(\d+)/"', index_html)))

    major = next((v for v in JDK_LTS_VERSIONS if v in available), None)
    if major is None:
        sys.exit(f"No LTS JDK found. Available versions: {available}")

    listing_url = f"{ADOPTIUM_MIRROR}/{major}/jdk/x64/linux/"
    listing = urlopen(listing_url).read().decode()

    pattern = re.compile(rf'OpenJDK{major}U-jdk_x64_linux_hotspot_(\d+\.\d+\.\d+_\d+)\.tar\.gz')
    versions = pattern.findall(listing)

    if not versions:
        sys.exit(f"No JDK {major} releases found at {listing_url}")

    def _version_key(v: str) -> tuple[int, ...]:
        return tuple(map(int, re.split(r"[._]", v)))

    return major, max(versions, key=_version_key)


def fetch_maven_version() -> str:
    """Return the latest Maven version from TUNA Apache mirror."""
    index_html = urlopen(MAVEN_MIRROR + "/").read().decode()
    versions = re.findall(r'(\d+\.\d+\.\d+)/', index_html)
    if not versions:
        sys.exit(f"No Maven versions found at {MAVEN_MIRROR}")
    return max(versions, key=lambda v: tuple(map(int, v.split("."))))


def fetch_golang_version() -> str:
    """Return the latest stable Go version (e.g. 1.26.4)."""
    index_html = urlopen(GOLANG_MIRROR + "/").read().decode()
    pattern = re.compile(r'go(\d+\.\d+\.\d+)\.linux-amd64\.tar\.gz')
    versions = pattern.findall(index_html)
    if not versions:
        sys.exit(f"No Go versions found at {GOLANG_MIRROR}")
    return max(versions, key=lambda v: tuple(map(int, v.split("."))))


def main() -> None:
    py_ver, py_date, py_type = fetch_python_version()
    node_ver = fetch_node_lts()
    pnpm_ver = fetch_pnpm_version()
    jdk_major, jdk_ver = fetch_jdk_lts()
    maven_ver = fetch_maven_version()
    go_ver = fetch_golang_version()

    (SCRIPT_DIR / "python.version").write_text(f"PYTHON_BUILD_DATE={py_date}\nPYTHON_VERSION={py_ver}\nPYTHON_BINARY_TYPE={py_type}\n")
    (SCRIPT_DIR / "nodejs-lts.version").write_text(f"NODE_VERSION={node_ver}\n")
    (SCRIPT_DIR / "pnpm.version").write_text(f"PNPM_VERSION={pnpm_ver}\n")
    (SCRIPT_DIR / "jdk-lts.version").write_text(f"JDK_MAJOR={jdk_major}\nJDK_VERSION={jdk_ver}\n")
    (SCRIPT_DIR / "maven.version").write_text(f"MAVEN_VERSION={maven_ver}\n")
    (SCRIPT_DIR / "golang.version").write_text(f"GO_VERSION={go_ver}\n")

    print(f"Python: {py_ver} (build {py_date}, {py_type})")
    print(f"Node LTS: {node_ver}")
    print(f"pnpm: {pnpm_ver}")
    print(f"JDK LTS: {jdk_major} ({jdk_ver})")
    print(f"Maven: {maven_ver}")
    print(f"Go: {go_ver}")


if __name__ == "__main__":
    main()
