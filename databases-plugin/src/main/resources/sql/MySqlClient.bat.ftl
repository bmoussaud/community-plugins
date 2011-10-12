@echo off
setlocal
<#import "/sql/commonFunctions.ftl" as cmn>
<#include "/sql/windowsSetEnvVars.ftl">

${deployed.container.mySqlHome}\bin\mysql --user=${cmn.lookup('username')} --password=${cmn.lookup('password')} ${cmn.lookup('schema')} &lt;

endlocal