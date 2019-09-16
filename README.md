## LAMP + Supervisor ##

This is a Dockerfile for a LAMP development environment based on Debian Wheezy. 

It uses Supervisor to keep Apache and MySQL running. 

It is meant for development only. MySQL is set up with zero security in mind. 

### Usage: ###

#### Build (change lamp to whatever you want to call the image): ####
    docker build -t lamp .

#### Run: ####
    docker run -d -p 5000:80 -p 5010:3306 -v /Users/bryan/Sites/sitename:/var/www lamp

#### Browser access: ####
    http://docker:5000/ (where docker has been mappted to your docker/boot2docker ip)

#### MySQL via the command line (just hit enter at password prompt): ####
    mysql -u root -p -h docker -P 5010


Credits: https://github.com/Krijger/docker-cookbooks/tree/master/supervisor
