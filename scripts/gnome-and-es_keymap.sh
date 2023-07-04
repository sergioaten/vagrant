sudo apt update
apt install ubuntu-desktop-minimal -y
sudo apt install console-data -y
sudo wget https://mirrors.edge.kernel.org/pub/linux/utils/kbd/kbd-2.5.1.tar.gz -O /tmp/kbd-2.5.1.tar.gz
cd /tmp/ && tar xzf kbd-2.5.1.tar.gz
sudo cp -Rp /tmp/kbd-2.5.1/data/keymaps/* /usr/share/keymaps/
sudo localectl set-keymap es