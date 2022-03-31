#!/bin/bash
sudo apt update -y
sudo apt install nginx python3 -y
sudo systemctl start nginx

sudo python3 - <<'END_SCRIPT'
text = '''
<html>
    <body>
        <h1>Hello World!</h1>
        <h2>Instance Tags: {"Name": "Flugel", "Owner" : "InfraTeam"}</h2>
    </body>
</html>
'''

file = open("/var/www/html/index.html","w")
file.write(text)
file.close()

END_SCRIPT

sudo cat /var/www/html/index.html

# sudo echo '<h1>Flugel Task 2 Instance</h1>' > /var/www/html/index.html
