#!/usr/bin/env bash
# QW 工坊 一键构建脚本
#
# 依赖：apktool、zipalign、apksigner（Android SDK build-tools 30+）
#
# 用法：
#   ./tools/build.sh                                   # 只出未签名包 build/qw-unsigned.apk
#   KS=~/qw.keystore ALIAS=qw PASS=你的口令 ./tools/build.sh   # 出 zipalign + 签名包 build/qw-signed.apk
#
# 注意：本仓库的 smali/ 是「桥接层」，可独立编译通过；
#      下载器核心（WorkshopDownloader 等）的实现说明见 docs/patch-notes-workshop.md。

set -euo pipefail
cd "$(dirname "$0")/.."

OUT="build/qw-unsigned.apk"
mkdir -p build

echo "==> apktool b ."
apktool b . -o "$OUT" -f

if [ -n "${KS:-}" ]; then
  : "${ALIAS:?需要设置 ALIAS（keystore 别名）}"
  : "${PASS:?需要设置 PASS（keystore 口令）}"
  KEYPASS="${KEYPASS:-$PASS}"

  echo "==> zipalign"
  zipalign -f -p 4 "$OUT" build/qw-aligned.apk

  echo "==> apksigner sign"
  apksigner sign \
    --ks "$KS" --ks-key-alias "$ALIAS" \
    --ks-pass "pass:$PASS" --key-pass "pass:$KEYPASS" \
    --out build/qw-signed.apk build/qw-aligned.apk

  echo "==> apksigner verify"
  apksigner verify build/qw-signed.apk
  echo "==> 完成：build/qw-signed.apk"
else
  echo "==> 完成：$OUT（未签名，可用 apksigner 手动签名）"
fi
