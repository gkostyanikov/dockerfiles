FROM ubuntu:14.10
MAINTAINER heypandora@gmail.com

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.4" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -y
RUN apt-get install -y postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4

# Run the rest of the commands as the ``postgres`` user created by the
# ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN  /etc/init.d/postgresql start &&\
	 psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
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
