###Pulling the Image from docker hub repository
FROM    centos:7
###updating the packages
RUN yum -y update
###installing the apache packages
RUN yum install -y httpd httpd-tools
###installing some basic packages
RUN yum install -y lynx wget rsync vim bash-completion curl unzip net-tools
###Exporting the port to the externel
EXPOSE  8092
###Creating the new ssh user for accessing the application
RUN adduser greycaps
###Directory Environment for project
RUN mkdir -p /home/greycaps/{backup,public_html,logs,tmp}
###Sample test file for testing the environment
RUN touch /home/greycaps/public_html/index.html
###adding the content to the sample file
RUN echo "this is the docker apache test page for test1.greycaps.com site......" > /home/greycaps/public_html/index.html
###changing the ownership of the directories
RUN chown -R greycaps:greycaps /home/greycaps/*
###changing the permissions of the project directory
RUN chmod -R 755 /home/*
RUN chmod -R 775 /home/greycaps/*
##### custom apache port ##########################
RUN sed -i 's/Listen 80/Listen 8092/g' /etc/httpd/conf/httpd.conf
###customizing the httpd configuration file for multiple projects
RUN sed -i 's/DirectoryIndex index.html/DirectoryIndex index.html index.php/g' /etc/httpd/conf/httpd.conf
###adding the one line space to the httpd configuration file
RUN echo " " >> /etc/httpd/conf/httpd.conf
######## Cross origin Enabled ######
RUN echo "## Cross Origin Enabled" >> /etc/httpd/conf/httpd.conf
RUN echo 'Header set Access-Control-Allow-Origin "*"' >> /etc/httpd/conf/httpd.conf
RUN echo 'Header set Access-Control-Allow-Headers "Origin, X-Requested-With, Content-Type, Accept"' >> /etc/httpd/conf/httpd.conf
RUN echo " " >> /etc/httpd/conf/httpd.conf
RUN echo "KeepAlive on" >> /etc/httpd/conf/httpd.conf
RUN echo "KeepAliveTimeout 7" >> /etc/httpd/conf/httpd.conf
RUN echo " " >> /etc/httpd/conf/httpd.conf
RUN echo "##################################" >> /etc/httpd/conf/httpd.conf
####this is the virtual host configuration for the projects
RUN echo "<VirtualHost *:8092>" >> /etc/httpd/conf/httpd.conf
RUN echo "DocumentRoot /var/www/html" >> /etc/httpd/conf/httpd.conf
RUN echo "ServerName 172.105.119.75" >> /etc/httpd/conf/httpd.conf
RUN echo "</VirtualHost>" >> /etc/httpd/conf/httpd.conf
####################################################################################
###enabling the user home directory for the project
RUN sed -i 's/AllowOverride FileInfo AuthConfig Limit Indexes/#    AllowOverride FileInfo AuthConfig Limit Indexes/g' /etc/httpd/conf.d/userdir.conf
RUN sed -i 's/Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec/AllowOverride all/g' /etc/httpd/conf.d/userdir.conf
RUN sed -i 's/Require method GET POST OPTIONS/Require all granted/g' /etc/httpd/conf.d/userdir.conf
RUN sed -i 's/UserDir disabled/# UserDir disabled/g' /etc/httpd/conf.d/userdir.conf
RUN sed -i 's/#UserDir public_html/UserDir public_html/g' /etc/httpd/conf.d/userdir.conf
##################### test1.greycaps.com ##########################
RUN touch /etc/httpd/conf.d/greycaps.conf
RUN echo "##### test1.greycaps.com ###########" >> /etc/httpd/conf.d/greycaps.conf
RUN echo "<VirtualHost *:8092>" >> /etc/httpd/conf.d/greycaps.conf
RUN echo "       DocumentRoot    /home/greycaps/public_html" >> /etc/httpd/conf.d/greycaps.conf
RUN echo "       ServerName      test1.greycaps.com" >> /etc/httpd/conf.d/greycaps.conf
RUN echo "       ErrorLog        /home/greycaps/logs/greycaps-error_log" >> /etc/httpd/conf.d/greycaps.conf
RUN echo "       TransferLog     /home/greycaps/logs/greycaps-access_log" >> /etc/httpd/conf.d/greycaps.conf
RUN echo "</VirtualHost>" >> /etc/httpd/conf.d/greycaps.conf
RUN echo "######################" >> /etc/httpd/conf.d/greycaps.conf
###apache service running in the foreground
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
##
