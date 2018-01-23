# intercept svn dcommit for non-master branches
if [[ -z $_real_git ]];then
    # _real_git is not exists
    _real_git=$(which git)
fi
git() {
    if [[ ($1 == 'svn')
        ||($1 == dcm)
        || ($1 == dm) 
        || ($1 == u)
        || ($1 == up) ]]
    then
        echo "intercept git $1 $2"
        curr_branch=$($_real_git branch | sed -n 's/\* //p')
        if [[ ($curr_branch != master) && ($curr_branch != '(no branch)') ]]
        then
            echo "You are now on branch [$curr_branch], continue performing this action? [y(es)/N]"
            read resp
            if [[ ($resp == yes) 
                || ($resp == y)]]
            then
                echo "do git svn $1 $2"
            else
                echo "Abort!"
                return 2
            fi
        fi
    fi
    $_real_git "$@"
}

# alias for git
alias st="stree"
alias x="stree"

alias gg='git log --oneline --decorate --graph --all'
alias gl='git log --oneline --decorate --graph --all'
export VISUAL="subl -n -w"

# common alias
alias dirSize='du -sh'
alias ll='ls -l'
alias la='ls -a'
alias lal='ls -al'
alias wh=which
alias bw='brew'
alias bwc='brew cask'
alias sb='subl'
alias sb.='subl .'
alias sbp='subl .'
alias a='atom'
alias ap='atom .'
alias reloadOhMyZshConfig="source $HOME/.zshrc"

# the fuck
alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
alias fk='fuck'

alias gp=grep

op(){
	local currentDir=$(pwd)
	echo "open in finder: $currentDir"
	open $currentDir
}
alias f="open"

# adb
alias apl='adb pull'
adb_push_image() {
    src=$1
    dest=$2
    adb push $src $dest
    adb shell "[ -f $dest ] && am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file://$dest"
    #adb shell "[[ -d $dest ]] && [[ $dest != */ ]] && echo 111$dest/$(basename $src)"
    adb shell "[[ -d $dest ]] && [[ $dest != */ ]] && am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file://$dest/$(basename $src)"
    adb shell "[[ -d $dest ]] && [[ $dest = */ ]] && am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file://$dest"
}
adbPushImage2Camera() {
    adb_push_image $1 "/mnt/sdcard/DCIM/Camera"
}
alias ainstall='adb install'
alias auninstall='adb uninstall'
alias adbkill='adb kill-server'
alias adbstart='adb start-server'
alias adbrestart='adbkill;adbstart;adbstart'
alias adbwfon="adb shell su -c 'svc wifi enable'"
alias adbwfoff="adb shell su -c 'svc wifi disable'"

export OHMYZSH="$HOME/development/codes/tools/oh-my-zsh"
alias jom="$HOME/development/codes/tools/OhMyZshCustom"
# add tools directory
export PATH="$PATH:$OHMYZSH:."

# network
net_status(){
	networksetup -getairportpower $WIFI_INTERFACE
	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'
	printf "Wi-Fi proxy:"
	networksetup -getautoproxyurl Wi-Fi
	printf "Ethernet proxy:"
	networksetup -getautoproxyurl Ethernet
	echo "http_proxy:$http_proxy"
	echo "https_proxy:$https_proxy"
	echo "ftp_proxy:$ftp_proxy"
	echo "all_proxy:$all_proxy"
}
alias ns=net_status

wfon(){
	networksetup -setairportpower $WIFI_INTERFACE on
}
wfof(){
	networksetup -setairportpower $WIFI_INTERFACE off
}

# common proxy
epTencent_dev(){
	networksetup -setautoproxyurl Ethernet $TENCENT_PROXY_URL_DEV
}
epDuotai(){
	networksetup -setautoproxyurl Ethernet $DUO_TAI_PROXY_URL
}
wfpTencent_office(){
    networksetup -setautoproxyurl Wi-Fi $TENCENT_PROXY_URL
}
wfpTencent_dev(){
	networksetup -setautoproxyurl Wi-Fi $TENCENT_PROXY_URL_DEV
}
wfpDuotai(){
    networksetup -setautoproxyurl Wi-Fi $DUO_TAI_PROXY_URL
}
wfpoff(){
    networksetup -setautoproxystate Wi-Fi off
}
wfpon(){
    networksetup -setautoproxystate Wi-Fi on
}

# command line proxy
cmdpDuotai(){
	export http_proxy=$DUO_TAI_PROXY_URL_CMD
	export https_proxy=$http_proxy
    export ftp_proxy=$http_proxy
    export all_proxy=$http_proxy
}
cmdpTencent(){
	export http_proxy=$TENCENT_PROXY_URL_CMD
	export https_proxy=$http_proxy
    export ftp_proxy=$http_proxy
    export all_proxy=$http_proxy
}
cmdpoff(){
	unset http_proxy
	unset https_proxy
    unset ftp_proxy
    unset all_proxy
}

# alias for svn
alias s='svn'
alias sv='svn'
alias svs='svn status'
alias svu='svn update'
alias sva='svn add'
alias svd='svn diff'
alias svc-m='svn commit -m'
alias svnrevertall='for FILE in $(svn status); do svn revert "$FILE"; done'

# ruby
if which rbenv > /dev/null;
	then eval "$(rbenv init -)";
fi

# start ssh agent
start_ssh_agent(){
	eval "$(ssh-agent -s)"
}

alias mapping_trace_sh_for_android_shrink=$ANDROID_HOME/tools/proguard/bin/retrace.sh

# add android to PATH
export ANDROID_HOME="$HOME/development/env/android/android-sdk-macosx"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools"
#export ANDROID_NDK="$HOME/development/env/android/ndk/android-ndk-r10e"
export ANDROID_NDK="$HOME/development/env/android/ndk/android-ndk-r14b"
export PATH="$PATH:$ANDROID_NDK"
alias nb="ndk-build"

# alias for tencent
alias code_review_tencent='~/development/tools/tencent/code-client-mac/CodeClient_Mac.sh'
alias jp="cd ~/development/codes/tencent/TTPic/git/dolphin_android_proj/"
alias js="cd ~/development/codes/tencent/Oscar/git/LifeIsLikeAPlay_Android_proj/"
alias jq="cd ~/development/codes/tencent/qzone/git/oscar_camera_proj/android"
alias jsdk="cd ~/development/codes/tencent/TTPic/git/dolphin_android_proj/PtuSdkFromShaka"
alias jd="cd ~/development"
alias jf="cd ~/development/codes/tencent/ferrari/WeiShi_Android_proj/Ferrari"

# config for rails
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# set go path
export GOPATH="$HOME/development/env/go/apps"

# add go apps
export PATH="$PATH:$GOPATH/bin"

# jadx
alias jadx=$HOME/development/tools/jadx-0.6.0/bin/jadx
alias jadx_gui=$HOME/development/tools/jadx-0.6.0/bin/jadx-gui

# react-native
alias rn=react-native

# autojump config
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

alias jai="cd $HOME/development/codes/ai"
# caffe
export CAFFE_ROOT="$HOME/development/codes/ai/caffe/caffe"
alias jcaffe="cd $CAFFE_ROOT"
export PYTHONPATH=$CAFFE_ROOT/python:$PYTHONPATH

export NCNN_ROOT="$HOME/development/codes/ai/ncnn/ncnn"
export PATH="$NCNN_ROOT/build/tools:$NCNN_ROOT/build/tools/caffe:$PATH"
alias jncnn="cd $NCNN_ROOT"

alias p=python
alias p2=python2
alias p3=python3
# make python -> brew python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# tensorflow
alias jtf="cd ~/development/codes/ai/tf/"

# cocos2d
export COCOS2D_ROOT="$HOME/development/codes/cocos2d/cocos2d-x-3.16"

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT="$HOME/development/codes/cocos2d"
export PATH=$COCOS_X_ROOT:$PATH

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT="$COCOS2D_ROOT/tools/cocos2d-console/bin"
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT="$COCOS2D_ROOT/templates"
export PATH=$COCOS_TEMPLATES_ROOT:$PATH

# Add environment variable NDK_ROOT for cocos2d-x
export NDK_ROOT="$ANDROID_NDK"
export PATH=$NDK_ROOT:$PATH

# Add environment variable ANDROID_SDK_ROOT for cocos2d-x
export ANDROID_SDK_ROOT="$ANDROID_HOME"

# add imgcat
alias imgcat=$ZSH_CUSTOM/imgcat.sh
alias imcat=imgcat
