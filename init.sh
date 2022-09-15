#!/bin/sh
DEMO="Install Demo"
AUTHORS="IBM World Wide Tech Sales"
PROJECT="git@github.ibm.com:ibamoe-examples/ibamoe8-install-demo.git"
PRODUCT="IBM Business Automation Manager Open Edition"
JBOSS_HOME=./target/jboss-eap-7.4
SERVER_DIR=$JBOSS_HOME/standalone/deployments
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects
VERSION_EAP=7.4.0
VERSION=8.0
EAP=jboss-eap-$VERSION_EAP.zip
#INSTALL - IBM or Red Hat
INSTALL=IBAMOE
RHPAM=$INSTALL-$VERSION-BC7.zip
RHPAM_KIE_SERVER=$INSTALL-$VERSION-KS8.zip
RHPAM_ADDONS=$INSTALL-$VERSION-AO.zip
#RHPAM_CASE=rhpam-$VERSION-case-mgmt-showcase-eap7-deployable.zip
RHPAM_UPDATE=rhpam-$VERSION-update

# wipe screen.
clear

echo
echo "###################################################################"
echo "##                                                               ##"
echo "##  Setting up the                                               ##"
echo "##                                                               ##"
echo "##                      #####   #####   #### ####                ##"
echo "##                        #    #   ##  #   #    #                ##"
echo "##                       #    #####   #   #    #                 ##"
echo "##                      #    #   ##  #   #    #                  ##"
echo "##                   #####  ######  #   #    #                   ##"
echo "##                                                               ##"
echo "##             ####    ####     ##    ##   ####    #####         ##"
echo "##            #   ##  #   #    # #   # #  #    #   #             ##"
echo "##           #####   #####    #  #  #  #  #    #   ####          ##"
echo "##          #   ##  #   #    #   # #   #  #    #   #             ##"
echo "##         ######  #   #    #    ##    #   ####    #####         ##"
echo "##                                                               ##"
echo "##                                                               ##"
echo "##  brought to you by, ${AUTHORS}                            ##"
echo "##                                                               ##"
echo "##  ${PROJECT}      ##"
echo "##                                                               ##"
echo "###################################################################"
echo

# make some checks first before proceeding.
if [ -r $SUPPORT_DIR ] || [ -L $SUPPORT_DIR ]; then
        echo "Support dir is presented..."
        echo
else
        echo "$SUPPORT_DIR wasn't found. Please make sure to run this script inside the demo directory."
        echo
        exit
fi

if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	echo "Product EAP sources are present..."
	echo
else
	echo "Need to download $EAP package from https://developers.redhat.com/content-gateway/file/jboss-eap-7.4.0.zip with a Red Hat Developer Account"
	echo "and place it in the $SRC_DIR directory to proceed..."
	echo
	exit
fi

if [ -r $SRC_DIR/$RHPAM ] || [ -L $SRC_DIR/$RHPAM ]; then
	echo "Product IBM Business Automation Manager Open Edition sources are present..."
	echo
else
	echo "Need to download $RHPAM package from Passport Advantage or your typical IBM Software Downloads location and search for product M06VVML - Business Central"
	echo "and place it in the $SRC_DIR directory to proceed..."
	echo
	exit
fi

if [ -r $SRC_DIR/$RHPAM_KIE_SERVER ] || [ -L $SRC_DIR/$RHPAM_KIE_SERVER ]; then
	echo "Product IBM Business Automation Manager Open Edition KIE Server sources are present..."
	echo
else
	echo "Need to download $RHPAM_KIE_SERVER package from https://w3.ibm.com/w3publisher/software-downloads and search M06VYML - KIE Server"
	echo "and place it in the $SRC_DIR directory to proceed..."
	echo
	exit
fi

# if [ -r $SRC_DIR/$RHPAM_ADDONS ] || [ -L $SRC_DIR/$RHPAM_ADDONS ]; then
# 	echo "Product IBM Business Automation Manager Open Edition Case Management sources are present..."
# 	echo
# else
# 	echo "Need to download $RHPAM_ADDONS package from https://developers.redhat.com/products/rhpam/download"
# 	echo "and place it in the $SRC_DIR directory to proceed..."
# 	echo
# 	exit
# fi

# Remove the old JBoss instance, if it exists.
if [ -x $JBOSS_HOME ]; then
		echo "  - removing existing JBoss product..."
		echo
		rm -rf $JBOSS_HOME
fi

# Installation.
echo "JBoss EAP installation running now..."
echo
mkdir -p ./target
unzip -qo $SRC_DIR/$EAP -d target

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during JBoss EAP installation!
	exit
fi

echo "IBM Business Automation Open Edition installation running now..."
echo
unzip -qo $SRC_DIR/$RHPAM -d target

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during IBM Business Automation Manager Open Edition installation!
	exit
fi

echo "IBM Business Automation Manager Open Edition - Kie Server installation running now..."
echo
unzip -qo $SRC_DIR/$RHPAM_KIE_SERVER  -d $JBOSS_HOME/standalone/deployments

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during IBM Business Automation Manager Open Edition Kie Server installation!
	exit
fi

# Set deployment Kie Server.
touch $JBOSS_HOME/standalone/deployments/kie-server.war.dodeploy

# echo "IBM Business Automation Manager Open Edition Case Management installation running now..."
# echo
# unzip -qo $SRC_DIR/$RHPAM_ADDONS $RHPAM_CASE -d $SRC_DIR
# unzip -qo $SRC_DIR/$RHPAM_CASE -d target
# rm $SRC_DIR/$RHPAM_CASE

# if [ $? -ne 0 ]; then
# 	echo
# 	echo Error occurred during IBM Automation Manager Open Edition Case Management installation!
# 	exit
# fi

# # Set deployment Case Management.
# touch $JBOSS_HOME/standalone/deployments/rhpam-case-mgmt-showcase.war.dodeploy

echo "  - enabling demo accounts role setup..."
echo
echo "  - adding user 'bamAdmin' with password 'ibmpam1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u bamAdmin -p ibmpam1! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all

echo "  - adding user 'adminUser' with password 'test1234!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u adminUser -p test1234! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all

echo "  - adding user 'kieserver' with password 'kieserver1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u kieserver -p kieserver1! -ro kie-server,rest-all

echo "  - adding user 'controllerUser' with password 'controllerUser1234;'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u kieserver -p kieserver1! -ro kie-server,rest-all

echo "  - adding user 'caseUser' with password 'ibmpam1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u caseUser -p ibmpam1! -ro user

echo "  - adding user 'caseManager' with password 'ibmpam1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u caseManager -p ibmpam1! -ro user,manager

echo "  - adding user 'caseSupplier' with password 'ibmpam1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u caseSupplier -p ibmpam1! -ro user,supplier

echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone-full.xml $SERVER_CONF/standalone.xml
cp $SUPPORT_DIR/standalone-full.xml $SERVER_CONF/standalone-full.xml

echo "  - setup email task notification users..."
echo
cp $SUPPORT_DIR/userinfo.properties $SERVER_DIR/business-central.war/WEB-INF/classes/




# Add execute permissions to the standalone.sh script.
echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

echo "=============================================================="
echo "=                                                            ="
echo "=  $PRODUCT $VERSION setup complete.  ="
echo "=                                                            ="
echo "=  Start $PRODUCT with:            ="
echo "=                                                            ="
echo "=           $SERVER_BIN/standalone.sh         ="
echo "=                                                            ="
echo "=  Log in to IBM Business Automation Manager to start        ="
echo "=  developing rules projects:                                ="
echo "=                                                            ="
echo "=  http://localhost:8080/business-central                    ="
echo "=                                                            ="
echo "=    Log in: [ u:bamAdmin / p:ibmpam1! ]                     ="
echo "=                                                            ="
echo "=  http://localhost:8080/rhpam-case-mgmt-showcase            ="
echo "=                                                            ="
echo "=    Others:                                                 ="
echo "=            [ u:kieserver / p:kieserver1! ]                 ="
echo "=            [ u:caseUser / p:ibmpam1! ]                     ="
echo "=            [ u:caseManager / p:ibmpam1! ]                  ="
echo "=            [ u:caseSupplier / p:ibmpam1! ]                 ="
echo "=                                                            ="
echo "=============================================================="
echo

# echo "Red Hat Process Automation Manager update and patch process running now..."
# echo
# unzip -qo $SRC_DIR/$RHPAM_UPDATE.zip -d target

# if [ $? -ne 0 ]; then
# 	echo
# 	echo Error occurred during IBM Business Automation Manager Open Edition Update installation!
# 	exit
# fi

# cd ./target/$RHPAM_UPDATE

# echo "  - patching Business Central..."
# ./apply-updates.sh ../jboss-eap-7.4/standalone/deployments/business-central.war rhpam-business-central-eap7-deployable

# echo "  - patching KIE Server..."
# ./apply-updates.sh ../jboss-eap-7.4/standalone/deployments/kie-server.war rhpam-kie-server-ee8

# cd ../../
# rm -r target/$RHPAM_UPDATE
