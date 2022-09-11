@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=Install Demo
set AUTHORS="IBM World Wide Tech Sales"
set PROJECT="git@github.ibm.com:ibamoe-examples/ibamoe8-install-demo.git"
set PRODUCT="IBM Business Automation Manager Open Edition"
set JBOSS_HOME=%PROJECT_HOME%\target\jboss-eap-7.4
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_BIN=%JBOSS_HOME%\bin
set SRC_DIR=%PROJECT_HOME%\installs
set SUPPORT_DIR=%PROJECT_HOME%\support
set PRJ_DIR=%PROJECT_HOME%\projects
set VERSION_EAP=7.4.0
set VERSION=8.0
set EAP=jboss-eap-%VERSION_EAP%.zip
set RHPAM=IBAMOE-%VERSION%-BC7.zip
set RHPAM_KIE_SERVER=IBAMOE-%VERSION%-KS8.zip
@REM set RHPAM_ADDONS=rhpam-%VERSION%-add-ons.zip
@REM set RHPAM_CASE=rhpam-%VERSION%-case-mgmt-showcase-eap7-deployable.zip

REM wipe screen.
cls

echo.
echo ###################################################################
echo ##                                                               ##  
echo ##  Setting up the                                               ##
echo ##                                                               ##  
echo ###################################################################
echo ##                                                               ##
echo ##  Setting up the                                               ##
echo ##                                                               ##
echo ##                      #####   #####   #### ####                ##
echo ##                        #    #   ##  #   #    #                ##
echo ##                       #    #####   #   #    #                 ##
echo ##                      #    #   ##  #   #    #                  ##
echo ##                   #####  ######  #   #    #                   ##
echo ##                                                               ##
echo ##             ####    ####     ##    ##   ####    #####         ##
echo ##            #   ##  #   #    # #   # #  #    #   #             ##
echo ##           #####   #####    #  #  #  #  #    #   ####          ##
echo ##          #   ##  #   #    #   # #   #  #    #   #             ##
echo ##         ######  #   #    #    ##    #   ####    #####         ##
echo ##                                                               ##
echo ##                                                               ##
echo ##  brought to you by, ${AUTHORS}                            ##
echo ##                                                               ##
echo ##  ${PROJECT}      ##
echo ##                                                               ##
echo ###################################################################
echo
echo ##  brought to you by, %AUTHORS%                            ##
echo ##                                                               ##
echo ##  %PROJECT%      ##
echo ##                                                               ##   
echo ###################################################################
echo.

echo %PROJECT_HOME%
echo %DEMO%
echo %AUTHORS%
echo %PROJECT%
echo %PRODUCT%
echo %JBOSS_HOME%
echo %SERVER_DIR%
echo %SERVER_CONF%
echo %SERVER_BIN%
echo %SRC_DIR=%
echo %SUPPORT_DIR%
echo %PRJ_DIR%
echo %VERSION_EAP%
echo %VERSION%
echo %EAP=jboss-eap-%
echo %RHPAM%
echo %RHPAM_KIE_SERVER%

REM make some checks first before proceeding.	
if exist "%SUPPORT_DIR%" (
        echo Support dir is presented...
        echo.
) else (
        echo %SUPPORT_DIR% wasn't found. Please make sure to run this script inside the demo directory.
        echo.
        GOTO :EOF
)

if exist "%SRC_DIR%\%EAP%" (
        echo JBoss EAP sources are present...
        echo.
) else (
        echo Need to download %EAP% package from https://developers.redhat.com/products/eap/download
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

if exist "%SRC_DIR%\%RHPAM%" (
        echo Red Hat Process Automation Manager sources are present...
        echo.
) else (
        echo Need to download %RHPAM% package from https://developers.redhat.com/products/rhpam/download
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

if exist "%SRC_DIR%\%RHPAM_KIE_SERVER%" (
        echo Red Hat Process Automation Maanger Kie Server sources are present...
        echo.
) else (
        echo Need to download %RHPAM_KIE_SERVER% package from https://developers.redhat.com/products/rhpam/download
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

@REM if exist "%SRC_DIR%\%RHPAM_ADDONS%" (
@REM         echo Red Hat Process Automation Manager Case Management sources are present...
@REM         echo.
@REM ) else (
@REM         echo Need to download %RHPAM_ADDONS% package from https://developers.redhat.com/products/rhpam/download
@REM         echo and place it in the %SRC_DIR% directory to proceed...
@REM         echo.
@REM         GOTO :EOF
@REM )


REM Move the old instance, if it exists, to the OLD position.
if exist "%PROJECT_HOME%\target" (
         echo - removing existing install...
         echo.
        
         rmdir /s /q %PROJECT_HOME%\target
 )

echo Creating target directory...
echo.
mkdir %PROJECT_HOME%\target



REM Installation.
echo JBoss EAP installation running now...
echo.
cscript /nologo %SUPPORT_DIR%\unzip.vbs %SRC_DIR%\%EAP% %PROJECT_HOME%\target
echo Completed the unzips

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During JBoss EAP Installation!
	echo.
	GOTO :EOF
)

call set NOPAUSE=true

echo Red Hat Process Automation Manager installation running now...
echo.
cscript /nologo %SUPPORT_DIR%\unzip.vbs %SRC_DIR%\%RHPAM% %PROJECT_HOME%\target

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During Red Hat Process Automation Manager Installation!
	echo.
	GOTO :EOF
)

echo Red Hat Process Automation Manager Kie Server installation running now...
echo.
cscript /nologo %SUPPORT_DIR%\unzip.vbs %SRC_DIR%\%RHPAM_KIE_SERVER% %JBOSS_HOME%\standalone\deployments

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During Red Hat Process Automation Manager Kie Server Installation!
	echo.
	GOTO :EOF
)

REM Set deployment Kie Server.
echo. 2>%JBOSS_HOME%/standalone/deployments/kie-server.war.dodeploy

@REM echo Red Hat Process Automation Manager Case Management installation running now...
@REM echo.
@REM cscript /nologo %SUPPORT_DIR%\unzip.vbs %SRC_DIR%\%RHPAM_ADDONS% %SRC_DIR%

@REM if not "%ERRORLEVEL%" == "0" (
@REM   echo.
@REM 	echo Error Occurred During Red Hat Process Automation Manager Case Management Extraction!
@REM 	echo.
@REM 	GOTO :EOF
@REM )

@REM cscript /nologo %SUPPORT_DIR%\unzip.vbs %SRC_DIR%\%RHPAM_CASE% %PROJECT_HOME%\target

@REM if not "%ERRORLEVEL%" == "0" (
@REM   echo.
@REM 	echo Error Occurred During Red Hat Process Automation Manager Case Management Extraction!
@REM 	echo.
@REM 	GOTO :EOF
@REM )

@REM REM Clean up case management archives.
@REM del %SRC_DIR%\rhpam-7.1-*


@REM REM Set deployment Case Management.
@REM echo. 2>%JBOSS_HOME%/standalone/deployments/rhpam-case-mgmt-showcase.war.dodeploy


echo.
echo - enabling demo accounts role setup...
echo.
echo - User 'bamAdmin' password 'ibmpam1!' setup...
echo.
call %JBOSS_HOME%\bin\add-user.bat -a -r ApplicationRealm -u bamAdmin -p ibmpam1! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all --silent
echo - User 'adminUser' password 'test1234!' setup...
echo.
call %JBOSS_HOME%\bin\add-user.bat -a -r ApplicationRealm -u adminUser -p test1234! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all --silent
echo - Management user 'kieserver' password 'kieserver1!' setup...
echo.
call %JBOSS_HOME%\bin\add-user.bat -a -r ApplicationRealm -u kieserver -p kieserver1! -ro kie-server,rest-all --silent
echo - Management user 'caseUser' password 'ibmpam1!' setup...
echo.
call %JBOSS_HOME%\bin\add-user.bat -a -r ApplicationRealm -u caseUser -p ibmpam1! -ro user --silent
echo - Management user 'caseManager' password 'ibmpam1!' setup...
echo.
call %JBOSS_HOME%\bin\add-user.bat -a -r ApplicationRealm -u caseManager -p ibmpam1! -ro user,manager --silent
echo - Management user 'caseSupplier' password 'ibmpam1!' setup...
echo.
call %JBOSS_HOME%\bin\add-user.bat -a -r ApplicationRealm -u caseSupplier -p ibmpam1! -ro user,supplier --silent

echo - setting up standalone.xml configuration adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\standalone-full.xml" "%SERVER_CONF%\standalone.xml"
echo.

echo - setup email task notification users...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\userinfo.properties" "%SERVER_DIR%\business-central.war\WEB-INF\classes\"

echo "=============================================================="
echo "=                                                            ="
echo "=  %PRODUCT% %VERSION% setup complete.  ="
echo "=                                                            ="
echo "=  Start %PRODUCT% with:            ="
echo "=                                                            ="
echo "=           %SERVER_BIN%\standalone.bat         ="
echo "=                                                            ="
echo "=  Log in to Red Hat Process Automation Manager to start     ="
echo "=  developing rules projects:                                ="
echo "=                                                            ="
echo "=  http://localhost:8080/business-central                    ="
echo "=                                                            ="
echo "=    Log in: [ u:bamAdmin / p:ibmpam1! ]                  ="
echo "=                                                            ="
echo "=  http://localhost:8080/rhpam-case-mgmt-showcase            ="
echo "=                                                            ="
echo "=    Log in: [ u:bamAdmin / p:ibmpam1! ]                  ="
echo "=                                                            ="
echo "=    Others:                                                 ="
echo "=            [ u:kieserver / p:kieserver1! ]                 ="
echo "=            [ u:caseuser / p:ibmpam1! ]                  ="
echo "=            [ u:casemanager / p:ibmpam1! ]               ="
echo "=            [ u:casesupplier / p:ibmpam1! ]              ="
echo "=                                                            ="
echo "=============================================================="
echo.

