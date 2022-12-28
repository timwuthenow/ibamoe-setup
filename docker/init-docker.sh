#!/bin/sh
. ./init-properties.sh

# wipe screen.
clear

echo
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
echo "##                                                                  ##"
echo "##  brought to you by,                                              ##"
echo "##             ${AUTHORS}                                              ##"
echo "##                                                                  ##"
echo "##                                                                  ##"
echo "##  ${PROJECT}         ##"
echo "##                                                                  ##"
echo "######################################################################"
echo

# make some checks first before proceeding.
if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	 echo Product sources are present...
	 echo
else
	echo Need to download $EAP package from http://developers.redhat.com
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

#if [ -r $SRC_DIR/$EAP_PATCH ] || [ -L $SRC_DIR/$EAP_PATCH ]; then
#	echo Product patches are present...
#	echo
#else
#	echo Need to download $EAP_PATCH package from the Customer Portal
#	echo and place it in the $SRC_DIR directory to proceed...
#	echo
#	exit
#fi

if [ -r $SRC_DIR/$IBAMOE ] || [ -L $SRC_DIR/$IBAMOE ]; then
		echo Product sources are present...
		echo
else
		echo Need to download $IBAMOE zip from http://developers.redhat.com
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

if [ -r $SRC_DIR/$IBAMOE_KIE_SERVER ] || [ -L $SRC_DIR/$IBAMOE_KIE_SERVER ]; then
		echo Product sources are present...
		echo
else
		echo Need to download $IBAMOE_KIE_SERVER zip from http://developers.redhat.com
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

# if [ -r $SRC_DIR/$IBAMOE_ADDONS ] || [ -L $SRC_DIR/$IBAMOE_ADDONS ]; then
# 		echo Product sources are present...
# 		echo
# else
# 		echo Need to download $IBAMOE_ADDONS zip from http://developers.redhat.com
# 		echo and place it in the $SRC_DIR directory to proceed...
# 		echo
# 		exit
# fi

cp support/docker/Dockerfile .
cp support/docker/.dockerignore .

echo Starting Docker build.
echo

docker build --no-cache -t $DOCKERNAME --build-arg VERSION=$VERSION --build-arg IBAMOE=bamoe-8.0.1-business-central-eap7-deployable.zip --build-arg IBAMOE_KIE_SERVER=$IBAMOE_KIE_SERVER --build-arg EAP=$EAP --build-arg JBOSS_EAP=$JBOSS_EAP .

if [ $? -ne 0 ]; then
        echo
        echo Error occurred during Docker build!
        echo Consult the Docker build output for more information.
        exit
fi

echo Docker build finished.
echo

rm Dockerfile

echo
echo "=================================================================================="
echo "=                                                                                ="
echo "=  You can now start the $PRODUCT in a Docker container with: ="
echo "=                                                                                ="
echo "=  docker run -it -p 8080:8080 -p 9990:9990 $DOCKERNAME ="
echo "=                                                                                ="
echo "=  Login into Business Central at:                                               ="
echo "=                                                                                ="
echo "=    http://localhost:8080/business-central  (u:bamAdmin / p:ibmpam1!)             ="
echo "=                                                                                ="
echo "=                                                                                ="
echo "=                                                                                ="
echo "=                                                                                ="
echo "=  $PRODUCT $VERSION $DEMO Setup Complete.                  ="
echo "=                                                                                ="
echo "=================================================================================="
