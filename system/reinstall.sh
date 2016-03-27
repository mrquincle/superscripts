#/bin/sh

LATEX="texlive vim-latexsuite texlive-latex-extra"
TEXT_MANIP="vim hexedit hexdump meld srecord $LATEX"

SYSTEM="aptitude zsh tree libusb-1.0-0-dev expect hardinfo bumblebee smartmontools apt-file checkinstall"

NETWORK="nmap arp-scan tcpdump curl minicom vpnc network-manager-vpnc google-chrome pidgin nfs-client traceroute nginx"

# sni-qt:i386 is necessary to show the skype indicator
MEDIA="vlc vlc-nox mesa-utils vuze sni-qt:i386 gimp imagemagick pavucontrol meshlab ffmpeg"

PROGRAMMING="exuberant-ctags cmake cmake-gui nodejs ruby2.1-dev aclocal automake autotools-dev openocd srecord python-pygame python-pip ant openjdk-7-jdk python-bluez subversion clang g++-multilibgitg libgflags-dev libgoogle-glog-dev"

SCIENCE="libeigen3-dev epstool libopenblas-dev python3-matplotlib python3-scipy r-base r-cran-tkrplot"

# install particular packages by
# R
# install.packages('DPpackage_1.1-6.tar.gz');

# msttcorefonts are the Microsoft fonts, e.g. useful in Acrobat Reader
COMPATIBILITY="msttcorefonts"

sudo apt-get install $SYSTEM
sudo apt-get install $NETWORK
sudo apt-get install $TEXT_MANIP
sudo apt-get install $MEDIA
sudo apt-get install $PROGRAMMING
sudo apt-get install $SCIENCE
sudo apt-get install $COMPATIBILITY

# get sagemath from separate repos
sudo apt-add-repository -y ppa:aims/sagemath
sudo apt-get update
sudo apt-get install sagemath-upstream-binary

UNNECESSARY="zeitgeist zeitgeist-datahub libzeitgeist totem firefox xul-ext-unity xul-ext-webaccounts empathy"

sudo apt-get remove --purge $UNNECESSARY

# get OCTAVE from source ball
#mkdir ~/setup
#cd ~/setup
#wget ftp://ftp.gnu.org/gnu/octave/octave-4.0.0.tar.xz
#tar xf octave-4.0.0.tar.xz
#cd octave-4.0.0
#./configure
#make
#sudo make install

# too much work
sudo apt-get install octave


echo "Install npm first via PPA"
sudo apt-get install npm
echo "Then update it"
sudo npm install -g npm
echo "And remove it again"
sudo apt-get remove npm
# add to ~/.localrc
# export PATH="$HOME/.npm-packages/bin:$PATH"
# we do not use npm to install node, this is deprecated...

echo "Install CUDA from https://developer.nvidia.com/cuda-downloads"

echo "Get VisualSFM from http://ccwu.me/vsfm/download/VisualSFM_linux_64bit.zip"

VISUALSFM_DEPS="build-essential libsdl1.2debian libsdl1.2-dev libgl1-mesa-dev libglu1-mesa-dev libsdl-image1.2 libsdl-image1.2-dev freeglut3-dev libxmu-dev libdevil1c2 libdevil-dev libglew-dev libgtk2.0-dev"

sudo apt-get install $VISUALSFM_DEPS

echo "Get SIFTGPU from http://cs.unc.edu/~ccwu/siftgpu/download.html"
SIFTGPU_DEPS="nvidia-cuda-dev"

sudo apt-get install $SIFTGPU_DEPS

echo "Adjust following"
echo "MimeType=application/x-bittorrent;application/x-torrent"
sudo vim /usr/share/applications/azureus.desktop

echo "Add following"
echo "x-scheme-handler/magnet=azureus.desktop"
sudo vim /usr/share/applications/defaults.list

sudo gem install bundler

# in e.g. the dobots.nl jekyll blog
bundle install

# use pip
sudo pip install pexpect
sudo pip install intelhex --allow-unverified intelhex

# use npm
sudo npm install -g bower
sudo npm install -g cordova

# adb, etc. get from source
# http://developer.android.com/sdk/index.html
# make sure you get the tools, not the studio
#unzip ~/setup/android*.zip -d /opt
tar -xzvf ~/setup/android*.tgz -C /opt

# add to ~/.localrc
# export PATH="$PATH:/opt/android-sdk-linux/tools"
# export PATH="$PATH:/opt/android-sdk-linux/platform-tools"
android sdk

# check requirements script
~/.cordova/lib/android/cordova/3.4.0/bin/check_reqs

# set meld as diff tool
# http://nathanhoad.net/how-to-meld-for-git-diffs-in-ubuntu-hardy
mkdir -p $HOME/myscripts/text
script=$HOME/myscripts/text/diff.py
echo "#!/usr/bin/python" >> $script
echo "import sys" >> $script
echo "import os" >> $script
echo "os.system('meld "%s" "%s"' % (sys.argv[2], sys.argv[5]))" > $script

git config --global diff.external /home/anne/myscripts/text/diff.py

mkdir -p $HOME/.ssh
touch $HOME/.ssh/config
echo "Host almendedemo.customers.luna.net" >> $HOME/.ssh/config
echo "   IdentityFile ~/.ssh/luna/id_rsa_gamix" >> $HOME/.ssh/config
sudo chown 007 $HOME/.ssh/luna/id_rsa_gamix
ssh-add $HOME/.ssh/luna/id_rsa_gamix

# check list of keys:
ssh-add -L

# on all machines to which I have access
sudo vim /etc/ssh/sshd_config
echo "PasswordAuthentication no"

# SSD changes
UUID=3bef3a49-7a5e-4bc3-8120-89b9d0bb8977  /opt          ext4    noatime,defaults        0       2
UUID=a2df195c-abfa-4ff5-adf3-dc3bdece6e99  none          swap    sw              0       0
UUID=55C3-6B67                             /boot/efi     vfat    defaults	0	1
UUID=abb29e98-4e3f-4573-8f93-4969599403c6  /hd           ext4	defaults	02
tmpfs      /var/log        tmpfs      defaults,noatime        0    0
tmpfs      /tmp          tmpfs      defaults,noatime,mode=1777    0    0

# Change shell to zsh and enable oh-my-zsh (esp. for git plugin)
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh

# https://www.segger.com/jlink-software.html

# cross-compiler arm
mkdir -p ~/setup
cd ~/setup

# there are newer versions now
curl -v -O https://launchpadlibrarian.net/186124019/gcc-arm-none-eabi-4_8-2014q3-20140805-src.tar.bz2
tar -xvjf gcc-arm-none-eabi-4_8-2014q3-20140805-src.tar.bz2 -C /opt

# install Acrobat reader
curl -v -O ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
sudo apt-get install libgtk2.0-0:i386 libxml2:i386 libstdc++6:i386 gtk2-engines-murrine:i386 libcanberra-gtk-module:i386 unity-gtk2-module:i386
sudo dpkg -i AdbeRdr9.5.5-1_i386linux_enu.deb

# set as default
mimeopen -d some.pdf

