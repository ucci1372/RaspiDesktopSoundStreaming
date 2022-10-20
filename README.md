# RaspiDesktopSoundStreaming

# Features

Raspberry piのデスクトップサウンドを、HLSでストリーミング配信するスクリプトです。

# Requirement
* Raspberry Pi OS 2020-12-02 release 以上
* ffmpeg
* nginx
* tmux

# Installation

ホームにスクリプトをダウンロードしてください。

```bash
git clone https://github.com/ucci1372/RaspiDesktopSoundStreaming.git RaspiDesktopSoundStreaming
```

ファイルに実行権限を付加して下さい。
```bash
cd RaspiDesktopSoundStreaming/
chmod +x ffmpeg_streaming.sh
```
# Usage

HLSの配信にはhttpサーバーが必要です。nginxのデフォルトルート（`/var/www/html`）に配信用のファイルを保存する設定にしています。適宜変更して下さい。

ターミナルから以下のコマンドを実行して下さい。

```bash
tmux new-session -d -s rdss './ffmpeg_streaming.sh'
```
tmuxで、`ffmpeg`のエンコードが起動します。現在の状況を確認する時は、tmuxのコマンドで確認出来ます。

```bash
tmux a -t rdss
```

サウンドはHLSで配信されるので、safari等のブラウザ、vlc等からRaspberry Pi（192.168.xxx.xxx）の`rdss.m3u8`にアクセスして下さい。

http://192.168.xxx.xxx/rdss.m3u8

HLSファイルの場所は標準入力でも指定できるようにしています。必要に応じて変更して下さい。

例：`/home/pi/www/live_streaming`を指定する場合
```bash
tmux new-session -d -s rdss 'echo "/home/pi/www/live_streaming" | ./ffmpeg_streaming.sh'
```
配信を続ける間、ffmpegは常にファイル生成します。長時間使用する場合は`tmpfs`の利用も検討して下さい。
# Author

* ucci1372
* twitter: https://twitter.com/ucci1372

# License

"RaspiDesktopSoundStreaming" is under [MIT license](https://en.wikipedia.org/wiki/MIT_License).
