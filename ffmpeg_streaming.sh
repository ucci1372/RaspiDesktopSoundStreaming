#! /bin/bash

# 
# Stream Raspberry Pi Desktop Sound by ffmpeg.
# 別途httpサーバが必要。
# デフォルトでは、nginxのデフォルトルートに直接ストリーミングファイルを生成
#

SoundSource="alsa_output.platform-bcm2835_audio.digital-stereo.monitor"
TargetDir="/var/www/html"

if [ -p /dev/stdin ]; then
  TargetDir=$(cat -)
fi

while getopts t:s: OPT
do
  case $OPT in
    t) TargetDir=$OPTARG ;;
    s) SoundSource=$OPTARG ;;
  esac
done

sudo mkdir -p $TargetDir
sudo chown pi $TargetDir
sudo mount -t tmpfs -o size=2m tmpfs $TargetDir

mkdir -p $TargetDir/stream

ffmpeg -f pulse -i $SoundSource \
  -c:a aac -b:a 64k -ac 1 \
  -flags +cgop+global_header \
  -f hls \
  -hls_time 0.5 -hls_list_size 3 -hls_allow_cache 0 \
  -hls_segment_filename $TargetDir/stream/stream_%d.ts \
  -hls_base_url stream/ \
  -hls_flags delete_segments \
  $TargetDir/rdss.m3u8

rm $TargetDir/stream/stream_*.ts
rmdir $TargetDir/stream
rm $TargetDir/rdss.m3u8
sudo umount $TargetDir
sudo rmdir $TargetDir
