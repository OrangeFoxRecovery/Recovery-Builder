FROM docker/whalesay:latest
LABEL Name=orangefoxci Version=0.0.1
SHELL [ "executable" ] apt-get -y update && apt-get install -y fortunes
SHELL [ "/home/user/OrangeFox-CI/scripts/sync.sh" ]
SHELL [ "/home/user/OrangeFox-CI/scripts/build.sh" ]
SHELL [ "/home/user/OrangeFox-CI/scripts/upload.sh" ]
CMD ["sh", "-c", "/usr/games/fortune -a | cowsay"]
