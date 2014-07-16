FROM mattdm/fedora:f19
# docker-postgresql

# Install Development Tools
RUN yum -y groupinstall "Development Tools"
RUN echo "exclude=postgresql*" >> /etc/yum.repos.d/fedora.repo
RUN echo "exclude=postgresql*" >> /etc/yum.repos.d/fedora-updates.repo

RUN curl -O http://yum.postgresql.org/9.3/fedora/fedora-19-x86_64/pgdg-fedora93-9.3-1.noarch.rpm
RUN rpm -ivh pgdg-fedora93-9.3-1.noarch.rpm

# install server
RUN yum install -y postgresql93-server postgresql93-contrib postgresql93-devel postgis2_93 postgis2_93-utils pgadmin3_93

VOLUME ["/var/lib/pgsql/data"]
