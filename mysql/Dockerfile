FROM mattdm/fedora:f19

MAINTAINER Georgy Kostyanikov <heypandora@gmail.com>
RUN yum -y groupinstall "Development Tools"
RUN yum install -y zlib-devel readline-devel pcre-devel openssl-devel ncurses-devel mysql-devel make libxslt-devel libxslt libxml2-devel libxml2 gettext-devel gcc-c++ gcc expat-devel curl-devel automake autoconf
RUN yum install -y mysql mysql-server
RUN chkconfig --level 2345 mysqld on
