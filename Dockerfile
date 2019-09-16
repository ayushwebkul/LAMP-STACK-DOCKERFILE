FROM ubuntu:18.04

MAINTAINER Ayush singh rathore

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
#RUN apt-get install apache2 -y

#RUN apt-get install mysql-server -y

#RUN sed -i '/^bind-address*/ s/^/#/' /etc/mysql/my.cnf
RUN apt-get update && apt install -y apache2 \
    && a2enmod rewrite \
    && a2enmod headers \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt-get clean -y \
    && apt-get update -y \
    && apt-get install -y php5.6 php5.6-cli php5.6-common php5.6-bcmath php5.6-ctype php5.6-curl php5.6-dom php5.6-gd php5.6-iconv php5.6-intl php5.6-mbstring php5.6-simplexml php5.6-soap php5.6-xsl php5.6-zip  php5.6-mysql php5.6-fpm php5.6-bcmath libapache2-mod-php5.6 \
    && sed -i "s/None/all/g" /etc/apache2/apache2.conf

RUN service apache2 restart
#RUN service mysql start && mysql -u root --password= -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;"


RUN apt-get update 

RUN echo "mysql-server-5.7 mysql-server/root_password password root" | debconf-set-selections \
&& echo "mysql-server-5.7 mysql-server/root_password_again password root" | debconf-set-selections \
&& DEBIAN_FRONTEND=noninteractive apt-get install mysql-server-5.7 -y

RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
chmod -R 777 /var/run/mysqld/ && \
sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf


RUN apt-get -y install supervisor && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d

COPY supervisor.conf /etc/supervisor.conf
#COPY apache2.sv.conf /etc/supervisor/conf.d/
#COPY mysql.sv.conf /etc/supervisor/conf.d/

EXPOSE 80
EXPOSE 3306
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
