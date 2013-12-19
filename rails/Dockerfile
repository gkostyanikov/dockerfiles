FROM mattdm/fedora:f19

MAINTAINER Georgy Kostyanikov <heypandora@gmail.com>
RUN yum -y groupinstall "Development Tools"
RUN yum install openssl-devel -y
RUN git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc
RUN git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
RUN export PATH="$HOME/.rbenv/bin:$PATH" && rbenv install 2.0.0-p353
RUN export PATH="$HOME/.rbenv/bin:$PATH" && rbenv global 2.0.0-p353
