FROM mattdm/fedora:f19
# docker-postgresql
EXPOSE 5432

# Install Development Tools
RUN yum -y groupinstall "Development Tools"
RUN echo "exclude=postgresql*" >> /etc/yum.repos.d/fedora.repo
RUN echo "exclude=postgresql*" >> /etc/yum.repos.d/fedora-updates.repo

RUN curl -O http://yum.postgresql.org/9.3/fedora/fedora-19-x86_64/pgdg-fedora93-9.3-1.noarch.rpm
RUN rpm -ivh pgdg-fedora93-9.3-1.noarch.rpm

# install server
RUN yum install -y postgresql93-server postgresql93-contrib postgresql93-devel postgis2_93 postgis2_93-utils pgadmin3_93

# initialize DB data files
RUN su - postgres -c '/usr/pgsql-9.3/bin/initdb -D /var/lib/pgsql/data'

RUN echo "host all all 0.0.0.0/0 md5" >> /var/lib/pgsql/data/pg_hba.conf

#listen on all interfaces
RUN echo "listen_addresses='*'" >> /var/lib/pgsql/data/postgresql.conf

RUN su - postgres -c "/usr/pgsql-9.3/bin/postgres --single  -D /var/lib/pgsql/data -c config_file=/var/lib/pgsql/data/postgresql.conf" <<< "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';"

RUN su - postgres -c "/usr/pgsql-9.3/bin/postgres --single  -D /var/lib/pgsql/data -c config_file=/var/lib/pgsql/data/postgresql.conf" <<< "CREATE DATABASE docker;"

RUN su - postgres -c "/usr/pgsql-9.3/bin/postgres -D /var/lib/pgsql/data -c config_file=/var/lib/pgsql/data/postgresql.conf >logfile 2>&1 &" && sleep 3 && su - postgres -c psql <<< "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology; CREATE EXTENSION fuzzystrmatch; CREATE EXTENSION postgis_tiger_geocoder;" 

CMD ["su", "-", "postgres", "-c", "/usr/pgsql-9.3/bin/postgres -D /var/lib/pgsql/data -c config_file=/var/lib/pgsql/data/postgresql.conf"]
