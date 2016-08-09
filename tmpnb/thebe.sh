git clone https://github.com/oreillymedia/thebe
sudo npm install -g requirejs
sudo npm install -g coffee-script
sudo npm install -g bower
cd thebe
bower install
coffee -cbm .
cd static
r.js -o build.js baseUrl=. name=almond include=main out=main-built.js 
cd ..
cd ..
sudo mkdir /var/www/html/thebe
sudo cp -R thebe/* /var/www/html/thebe/