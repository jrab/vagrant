echo "--- Adding updated nodejs repo ---"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

echo "--- Adding yarn to apt-get ---"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

echo "--- Installing nginx ---"
sudo apt-get update
sudo apt-get install -y nginx
sudo cp /vagrant/includes/default /etc/nginx/sites-available/default

echo "--- Installing node.js ---"
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

echo "--- Installing git ---"
sudo apt-get install -y git

echo "--- Restart services ---"
sudo service nginx restart

echo "--- Installing Yarn ---"
sudo apt-get install -y yarn

echo "--- Copying SSH Key ---"
cp /vagrant/includes/ssh_keys/id_rsa /home/vagrant/.ssh/id_rsa
cp /vagrant/includes/ssh_keys/id_rsa /root/.ssh/id_rsa
chmod 600 /home/vagrant/.ssh/id_rsa /root/.ssh/id_rsa

echo "--- Adding to known_hosts ---"
ssh-keyscan -t rsa github.com >> /home/vagrant/.ssh/known_hosts
ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts
chown -R vagrant:vagrant /home/vagrant/.ssh/

echo "--- Cloning repos ---"
cd /var/www/nodeapp && git clone git@github.com:cordium/Zeus.git
cd /var/www/nodeapp && git clone git@github.com:cordium/Atlas.git
cd /var/www/nodeapp && git clone git@github.com:cordium/Pilot.git

echo "-- Installing npm packages ---"
cd /var/www/nodeapp/Atlas && yarn
cd /var/www/nodeapp/Zeus && yarn
cd /var/www/nodeapp/Pilot && yarn

