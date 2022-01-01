#!/bin/bash

RELEASE_URL="https://github.com/prometheus/prometheus/releases/download/v2.32.1/prometheus-2.32.1.linux-amd64.tar.gz"

gz=`basename ${RELEASE_URL}`
dir=`basename ${gz} .tar.gz`

mkdir ./work_dir
cd ./work_dir

# DL
wget ${RELEASE_URL}

# Extract
tar -xzvf ${gz}

# Copy src to /usr/local/src
cp -r ${dir} /usr/local/src/

# Copy binary to /usr/bin
cp ${dir}/prometheus /usr/bin/
cp ${dir}/promtool /usr/bin/

# 設定ファイル
mkdir /etc/prometheus
cp ../prometheus.yml /etc/prometheus/

# prometheusの実行ユーザ&グループを作成
adduser --system --home /var/lib/prometheus --no-create-home --group prometheus

# 各種ディレクトリの権限設定
mkdir -p /var/log/prometheus
mkdir -p /var/lib/prometheus/data
chown prometheus:prometheus /var/log/prometheus
chown -R prometheus:prometheus /var/lib/prometheus

# systemDの.serviceファイルをコピー
cd ../prometheus.service /lib/systemd/system/prometheus.service

