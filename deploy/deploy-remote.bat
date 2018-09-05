@ECHO OFF

set user=xxx
set host=xxx
set pwd=xxx

plink %user%@%host% -m deploy/deploy-remote.sh -pw %pwd% -t