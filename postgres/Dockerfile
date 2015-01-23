FROM ubuntu:14.04
MAINTAINER heypandora@gmail.com

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.4" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -y
RUN apt-get install -y postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 postgresql-plpython-9.4


# Install postgis by compiling from source - several steps
#
# Start with dependencies
RUN apt-get -y -q install postgresql-server-dev-9.4
RUN apt-get -y -q install autoconf build-essential wget
 
# surely some of these are unnecessary!
RUN apt-get -y -q install libgeos-c1 libgdal-dev libproj-dev libjson-c-dev \
libxml2-dev libxml2-utils xsltproc docbook-xsl docbook-mathml

# postgis 2.1.3 is broken against libjson-c-dev, so compile one instead
RUN wget https://s3.amazonaws.com/json-c_releases/releases/json-c-0.11.tar.gz \
-O json-c-0.11.tar.gz
RUN tar -xvf json-c-0.11.tar.gz 
RUN cd json-c-0.11/ && ./configure 
RUN cd json-c-0.11/ && make
RUN cd json-c-0.11/ && make install

# Now download and compile postgis itself
RUN wget http://download.osgeo.org/postgis/source/postgis-2.1.3.tar.gz \
-O postgis-2.1.3.tar.gz
RUN tar xvfz postgis-2.1.3.tar.gz
RUN cd postgis-2.1.3 && ./configure
RUN cd postgis-2.1.3 && make
RUN cd postgis-2.1.3 && make install

# Run the rest of the commands as the ``postgres`` user created by the
# ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN  /etc/init.d/postgresql start &&\
	 psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
	 psql --command "CREATE EXTENSION postgis;" &&\
	 psql --command "CREATE EXTENSION postgis_topology;" &&\
	 psql --command "CREATE EXTENSION fuzzystrmatch;" &&\
	 psql --command "CREATE EXTENSION postgis_tiger_geocoder;" &&\
	 createdb -O docker docker

	# Adjust PostgreSQL configuration so that remote connections to the
	# database are possible. 
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf

# And add ``listen_addresses`` to
# ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

RUN /usr/lib/postgresql/9.4/bin/postgres -D\
	/var/lib/postgresql/9.4/main -c\
	config_file=/etc/postgresql/9.4/main/postgresql.conf >logfile 2>&1 &

# Expose the PostgreSQL port
EXPOSE 5432
RUN mkdir -p /var/lib/postgresql/db_backups

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql", "/var/lib/postgresql/db_backups"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D",\
"/var/lib/postgresql/9.4/main", "-c",\
"config_file=/etc/postgresql/9.4/main/postgresql.conf"]
