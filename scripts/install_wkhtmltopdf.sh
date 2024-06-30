#!/bin/bash
set -exo pipefail

OS_VERSION=$(ruby -e 'puts `. /etc/os-release 2> /dev/null && echo ${ID}_${VERSION_ID}`.strip')

# wkhtmltopdf-binary v0.12.6.6 と同じバイナリを使用するため、`buster` を指定している。
# 0.12.6.1 r3 に`bullseye` のバイナリは存在するが、変えて問題ないのか確証が持てないため。
if [ "${OS_VERSION}" == "debian_11" ]; then
  WKHTMLTOPDF_TAG="0.12.6-1"
  if [ "$BUILDPLATFORM" == "linux/arm64" ]; then
    WKHTMLTOPDF_FILE="wkhtmltox_0.12.6-1.buster_arm64.deb"
  else
    WKHTMLTOPDF_FILE="wkhtmltox_0.12.6-1.buster_amd64.deb"
  fi
elif [ "${OS_VERSION}" == "ubuntu_22.04" ]; then
  WKHTMLTOPDF_TAG="0.12.6.1-2"
  WKHTMLTOPDF_FILE="wkhtmltox_0.12.6.1-2.jammy_amd64.deb"
else
  exit 1
fi

WKHTMLTOPDF_URL="https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_TAG}/${WKHTMLTOPDF_FILE}"

wget -q ${WKHTMLTOPDF_URL} \
  && apt install -y -f ./${WKHTMLTOPDF_FILE} \
  && rm ${WKHTMLTOPDF_FILE}
