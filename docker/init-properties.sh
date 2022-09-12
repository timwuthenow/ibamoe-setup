DEMO="Install Demo"
AUTHORS="Community"
PROJECT="https://github.com/timwuthenow/ibamoe-docker.git"
PRODUCT="IBM Business Automation Open Edition"
TARGET=./target
JBOSS_EAP=./target/jboss-eap-7.4
#JBOSS_HOME=$TARGET/$JBOSS_EAP
SERVER_DIR=$JBOSS_HOME/standalone/deployments
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
VERSION=8.0
VERSION_EAP=7.4
#INSTALL - IBM or Red Hat
#IF INSTALLING IBM BUSINESS AUTOMATION MANAGER OPEN EDITION LEAVE THESE NEXT LINES UNCOMMENTED, IF RED HAT UNCOMMENT 
# THOSE BELOW
#IBM INSTALLATION FILES BEGIN
INSTALL=IBAMOE
RHPAM=$INSTALL-$VERSION-BC7.zip
RHPAM_KIE_SERVER=$INSTALL-$VERSION-KS8.zip
RHPAM_ADDONS=$INSTALL-$VERSION-AO.zip
RHPAM_KIE_SERVER=$INSTALL-$VERSION-KS8.zip
#IBM INSTALLATION FILES END


#If the installation is done with the Red Hat Developer downloaded products 
#(https://developers.redhat.com/products/rhpam/download), uncomment the following:
#RED HAT INSTALLATION FILES BEGIN
#VERSION=7.13
#INSTALL=rhpam
#RHPAM=rhpam-$VERSION-business-central-eap7-deployable.zip
#RHPAM_KIE_SERVER=rhpam-$VERSION-kie-server-ee8.zip
#RHPAM_ADDONS=rhpam-$VERSION-add-ons.zip
#END RED HAT INSTALLATION FILES

PAM_CASE_MGMT=rhpam-7.7.0-case-mgmt-showcase-eap7-deployable.zip
EAP=jboss-eap-$VERSION_EAP.zip

#PROJECT_GIT_REPO=https://github.com/jbossdemocentral/rhpam7-mortgage-demo-repo
#PROJECT_GIT_REPO_NAME=examples-rhpam7-mortgage-demo-repo.git
#NIOGIT_PROJECT_GIT_REPO="MySpace/$PROJECT_GIT_REPO_NAME"

DOCKERNAME=ibamoe-8-bc
