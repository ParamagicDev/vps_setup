username="paramagician"

if getent passwd $1 > /dev/null 2>&1; then
    echo "$username is already being used!"
else
    echo "$username is not taken!"
    adduser $username
    adduser $username sudo
fi

sudo apt update
sudo apt upgrade -y

PACKAGE_LIST="curl tmux git vim zsh gnupg2 sqlite3 postgresql less python3 python-pip ufw"


for item in $PACKAGE_LIST; do
  sudo apt install $item -y
done

# install mosh
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:keithw/mosh
sudo apt-get update
sudo apt-get install mosh

# configure server to accept mosh connections

# install docker
sudo snap install docker

# Configure docker
groupadd docker
usermod -aG docker $USER
usermod -aG docker $username
systemctl enable docker
chkconfig docker on
systemctl restart docker.service

# install rvm
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
cd /tmp
curl -sSL https://get.rvm.io -o rvm.sh
cat /tmp/rvm.sh | bash -s stable --rails
source ~/.rvm/scripts/rvm

# install ruby
rvm install ruby-2.5.1
rvm use ruby-2.5.1

gem install rails -v 5.2.0
rvm gemset create $username
rvm 2.5.1@"$username" --create
source ~/.rvm/scripts/rvm

# install nodejs for rails pipeline
cd /tmp
# installs nodejs as root. Important note, will not properly install if not root
\curl -sSL https://deb.nodesource.com/setup_10.x -o nodejs.sh | bash -
less nodejs.sh
cat /tmp/nodejs.sh | sudo -E bash -
sudo apt install -y nodejs

# install colorls
gem install colorls

# install bundler
gem install bundler

# enabling traffic
sudo systemctl start ufw
sudo systemctl enable ufw
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow http/tcp

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp ~/vps-setup/.zshrc ~/.zshrc

ZSH_PLUGINS="~/.oh-my-zsh/custom/plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k


cd ~
source ~/.zshrc

