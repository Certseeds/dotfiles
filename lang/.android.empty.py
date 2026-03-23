import hashlib
import base64
import argparse
import pathlib
from typing import List


def getNames() -> List[str]:
    return [
        "..ccdid",
        "..ccvid",
        ".BD_SAPI_CACHE",
        ".ColombiaMedia",
        ".DataStorage",
        ".Rcs",
        ".SystemConfig",
        ".UTSystemConfig",
        ".antutu",
        ".arrow_flavor",
        ".cc",
        ".com.android.providers.downloads.ui",
        ".com.taobao.dp",
        ".dlprovider",
        ".duid",
        ".estrongs",
        ".g_b_d_v",
        ".g_m_o_bs",
        ".gs",
        ".gs_file",
        ".gs_fs0",
        ".gs_fs3",
        ".jd_Read",
        ".jds",
        ".knights",
        ".map_style",
        ".mn_2119253381",
        ".mn_442355282",
        ".n_a",
        ".n_b",
        ".n_c",
        ".n_d",
        ".o_a",
        ".personalassistant",
        ".tbs",
        ".tcookieid",
        ".transportext",
        ".um",
        ".uxx",
        ".vivo",
        ".x_o_b_d",
        "1688quick",
        "360",
        "Alarm",
        "Alarms",
        "AllenVersionPath",
        "AndroLua",
        "AppTimer",
        "BaiduNetdisk",
        "Blink",
        "ByteDownload",
        "COM",
        "Catfish",
        "DataStroage",
        "DuoKan",
        "Fonts",
        "FreeRun",
        "ICBC",
        "INSTALLATION_NEW",
        "JDReader",
        "JuphoonService",
        "KMP",
        "KMP_SUBTITLES",
        "Lanthanum",
        "Lanthanum_v2",
        "Lark",
        "LenovoClub",
        "MXShare",
        "MiMarket",
        "Mob",
        "Musicana",
        "Notifications",
        "OSSLog",
        "Podcasts",
        "PureIconPack",
        "QQBrowser",
        "QTAudioEngine",
        "Qiezi",
        "Ringtones",
        "SMZDM",
        "Screenshot",
        "SmartHome",
        "SoundMeter",
        "StarbucksImageCache",
        "Subtitles",
        "TENCENT.MOBILEQQ",
        "TitaniumBackup",
        "UTSystemConfig",
        "VirtualXposed",
        "WeiboInternational",
        "WoodenLetter",
        "Xiaomi",
        "_0ServerSendToServices.txt",
        "abnormal_reboot.dump",
        "advanced",
        "alipay",
        "amap",
        "app",
        "auf",
        "backup",
        "backups",
        "baidu",
        "beam",
        "bestpay",
        "broswer",
        "browser",
        "bwton",
        "bytedance",
        "cache",
        "ccvoice",
        "cmb",
        "cmb.db",
        "cmmap",
        "com.android.providers.downloads.ui",
        "com.miui.guardprovider_TMP_TMS",
        "com.miui.voiceassist",
        "com.netease.cloudmusic",
        "com.tencent.mobileqq",
        "com.tencent.tim",
        "data",
        "dcctp",
        "dctp",
        "dht.id",
        "did",
        "documents",
        "duilite",
        "ebz-crash",
        "flywheel",
        "iApp",
        "images",
        "libs",
        "mipush",
        "mm",
        "names.log",
        "netease",
        "nsmes2.log",
        "phicare",
        "pudding",
        "qqmusiclite",
        "qqstory",
        "qsvf",
        "ramdump",
        "recovery.img",
        "rtic.db",
        "sina",
        "sogou",
        "statistic",
        "system",
        "tbs",
        "tencent",
        "tencent_mmbak",
        "tiebaMini",
        "tmp",
        "tv.danmaku.bili",
        "txrtmp",
        "umeng_cache",
        "unite",
        "voip-data",
        "zhihu",
    ]


def generate_content(name: str) -> str:
    """
    Generate file content based on the original shell script logic:
    1. name | base64 | md5sum
    2. name | md5sum | base64
    3. name | sha1sum | base64
    4. name | sha256sum | md5sum
    """
    name_bytes = name.encode("utf-8")

    # 1. echo "${line}" | base64 | md5sum
    # Note: base64 in shell adds a newline by default, but we should match the intent.
    # The shell script `echo "${line}"` adds a newline.
    line_with_newline = (name + "\n").encode("utf-8")
    b64_1 = base64.b64encode(line_with_newline)
    md5_1 = hashlib.md5(b64_1).hexdigest()

    # 2. echo "${line}" | md5sum | base64
    # md5sum output in shell is usually "hash  -"
    md5_2_raw = hashlib.md5(line_with_newline).hexdigest()
    md5_2_str = f"{md5_2_raw}  -\n".encode("utf-8")
    b64_2 = base64.b64encode(md5_2_str).decode("utf-8")

    # 3. echo "${line}" | sha1sum | base64
    sha1_3_raw = hashlib.sha1(line_with_newline).hexdigest()
    sha1_3_str = f"{sha1_3_raw}  -\n".encode("utf-8")
    b64_3 = base64.b64encode(sha1_3_str).decode("utf-8")

    # 4. echo "${line}" | sha256sum | md5sum
    sha256_4_raw = hashlib.sha256(line_with_newline).hexdigest()
    sha256_4_str = f"{sha256_4_raw}  -\n".encode("utf-8")
    md5_4 = hashlib.md5(sha256_4_str).hexdigest()

    return f"{md5_1}\n{b64_2}\n{b64_3}\n{md5_4}\n"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate 'empty' files based on a list of names."
    )
    parser.add_argument(
        "target_dir", type=pathlib.Path, help="Directory where files will be created"
    )
    args = parser.parse_args()

    target_dir: pathlib.Path = args.target_dir
    if not target_dir.exists():
        target_dir.mkdir(parents=True)

    for name in getNames():
        file_path = target_dir / name
        print(f"Generating: {name}")
        content = generate_content(name)
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(content)


if __name__ == "__main__":
    main()
