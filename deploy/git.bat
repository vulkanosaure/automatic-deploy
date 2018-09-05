@ECHO OFF

set commit_msg=%1


if NOT "%~1"=="" (
	
	echo "Git commit and push"
	git add .
	git commit -m %commit_msg%
	git push -u origin master
	
)

