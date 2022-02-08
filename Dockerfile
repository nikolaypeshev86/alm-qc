FROM centos:8.3.2011

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
RUN yum -y install java-11-openjdk-devel
COPY ALM_16.0_Linux_English /tmp
RUN cp /etc/hosts /tmp/hosts
RUN mkdir -p -- /lib-override && cp /lib64/libnss_files.so.2 /lib-override
RUN sed -i 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2
ENV LD_LIBRARY_PATH /lib-override

RUN echo 172.17.0.2 mssql >> /tmp/hosts; /tmp/run_silent.sh; sleep 5
RUN sed -i '$d' /tmp/hosts

ENTRYPOINT /var/opt/ALM/wrapper/HPALM console

EXPOSE 8080 