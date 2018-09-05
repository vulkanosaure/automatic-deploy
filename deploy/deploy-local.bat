@ECHO OFF


set base_href=carte-interactive
set env=local

call npm install
ng build -c=%env% --base-href /%base_href%/ --deploy-url=/%base_href%/


REM add call (before npm install)
REM var display differently
