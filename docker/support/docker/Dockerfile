# Use Universal Base Image with OpenJDK 11 as the base
FROM registry.access.redhat.com/ubi8/openjdk-11:latest

# Maintainer details
#AUTHOR IBM Worldwide Tech Sales

#Arguments
ARG VERSION
ARG RHPAM
ARG RHPAM_KIE_SERVER
ARG EAP
ARG PROJECT_GIT_REPO
ARG JBOSS_EAP
#ARG EAP_PATCH

# Environment Variables
ENV HOME /opt/jboss
#ENV JBOSS_HOME $HOME/$JBOSS_EAP

# ADD Installation Files
COPY --chown=jboss:jboss installs/$RHPAM installs/$RHPAM_KIE_SERVER installs/$RHPAM_ADDONS installs/$EAP /opt/jboss/
RUN whoami
# Update Permissions on Installers
USER root
# RUN useradd -ms /bin/bash jboss
        # Switch to 'root' user to install 'jboss.container.user' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.user' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y unzip tar rsync shadow-utils \
            && microdnf clean all \
            && rpm -q unzip tar rsync shadow-utils

        # Custom scripts from 'jboss.container.user' module
        USER jboss

#RUN chown 185:185 /opt/jboss /opt/jboss/$EAP /opt/jboss/$RHPAM /opt/jboss/IBAMOE-8.0-KS8.zip /opt/jboss/$RHPAM_ADDONS


# Prepare and run installer and cleanup installation components

RUN unzip -qo /opt/jboss/$EAP -d $HOME 
RUN rm -rf /opt/jboss/$EAP
RUN unzip -qo /opt/jboss/$RHPAM -d $HOME  
RUN rm -rf /opt/jboss/$RHPAM

RUN unzip -qo /opt/jboss/$RHPAM_KIE_SERVER -d /opt/jboss/jboss-eap-7.4/standalone/deployments 
RUN rm -rf /opt/jboss/$RHPAM_KIE_SERVER
RUN touch /opt/jboss/jboss-eap-7.4/standalone/deployments/kie-server.war.dodeploy
RUN rm -rf /opt/jboss/jboss-eap-7.4/standalone/configuration/standalone_xml_history/

##This was validating permissions - the image right now is using root a lot of places due to challenges in the image
RUN cat /opt/jboss/jboss-eap-7.4/bin/add-user.sh
RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u bamAdmin -p ibmpam1! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all,Administrators   
RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u adminUser -p test1234! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all,Administrators  
RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u kieserver -p kieserver1! -ro kie-server,rest-all
RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u caseUser -p ibmpam1! -ro user  
RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u caseManager -p ibmpam1! -ro user,manager  
RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u caseSupplier -p ibmpam1! -ro user,supplier 
COPY --chown=jboss:jboss support/config.cli /opt/jboss

# CLI to change Java security logging level - this was done due a HTTP 405 error showing up with a different user ID
# The ID in the dockerfile typically uses kieserver/kieserver1! but I ended up using bamAdmin to get over 405 error more debugging will be needed
RUN  /opt/jboss/jboss-eap-7.4/bin/jboss-cli.sh --file="/opt/jboss/config.cli"
COPY --chown=jboss:jboss support/standalone-full.xml /opt/jboss/jboss-eap-7.4/standalone/configuration/
COPY --chown=jboss:jboss support/userinfo.properties /opt/jboss/jboss-eap-7.4/standalone/deployments/business-central.war/WEB-INF/classes/
# USER 185
# # Add support files
# RUN /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u bamAdmin -p ibmpam1! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all,Administrators   
# RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u adminUser -p test1234! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all,Administrators  
# RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u kieserver -p kieserver1! -ro kie-server  
# RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u caseUser -p ibmpam1! -ro user  
# RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u caseManager -p ibmpam1! -ro user,manager  
# RUN  /opt/jboss/jboss-eap-7.4/bin/add-user.sh -a -r ApplicationRealm -u caseSupplier -p ibmpam1! -ro user,supplier 
COPY support/standalone-full.xml /opt/jboss/jboss-eap-7.4/standalone/configuration/
COPY support/userinfo.properties /opt/jboss/jboss-eap-7.4/standalone/deployments/business-central.war/WEB-INF/classes/

# Swtich back to root user to perform cleanup
# USER root

# Fix permissions on support files
# RUN chown jboss:jboss /opt/jboss/jboss-eap-7.4/standalone/configuration/standalone-full.xml /opt/jboss/jboss-eap-7.4/standalone/deployments/business-central.war/WEB-INF/classes/userinfo.properties
# RUN chown jboss:jboss /opt/jboss
# Run as JBoss
RUN ls -al /opt/jboss/jboss-eap-7.4
RUN ls -al /opt/jboss/jboss-eap-7.4/standalone
RUN ls -al /opt/jboss
USER jboss

# Expose Ports
EXPOSE 9990 9999 8080

## This was a recommendation on the 405 error, but did not solve it, I am inclkuding it in case you want to explore this further
# RUN export JAVA_OPTS="$JAVA_OPTS -Djboss.modules.system.pkgs=org.jboss.byteman,org.jboss.logmanager -Djava.util.logging.manager=org.jboss.logmanager.LogManager -Dorg.jboss.logging.Logger.pluginClass=org.jboss.logging.logmanager.LoggerPluginImpl"
# RUN export JAVA_OPTS="$JAVA_OPTS -Xbootclasspath/p:$JBOSS_HOME/modules/system/layers/base/org/jboss/logmanager/main/jboss-logmanager-2.0.3.Final-redhat-1.jar"

# Run BRMS
ENTRYPOINT ["/opt/jboss/jboss-eap-7.4/bin/standalone.sh"]
CMD ["-c","standalone-full.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]
