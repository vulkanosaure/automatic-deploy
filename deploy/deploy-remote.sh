# Dependencies : 
# git
# composer
# node
# npm
# npm/angular-cli
# 


# todo : si se trompe sur le sparse_dir, faut supprimer le git pour réutiliser
# command pour reset (argument ?)
# 


# the remote dir in which git will be initialized (no / at the end)
REMOTE_REPO_DIR=/var/www/clients/client0/web1/web/map/front
# remote root dir (no slash)
REMOTE_WEBROOT_DIR=/var/www/clients/client0/web1/web
# the git url repo (use ssh, not http)
GIT_URL=git@gitlab.com:data-projekt/PAS-MAP2.git
# relative path from repo to src  (used for symlink)
DIST_PATH=SRC/FRONT-MAP/dist/FRONT-MAP
# if not every git folder must be pulled
SPARCE_DIR=SRC/FRONT-MAP
# symlink (no /, optionnel)
SYMLINK=carte-interactive
# environment
ENV=production






# create src directory

if [ ! -d "$REMOTE_REPO_DIR" ]; then
	printf "REMOTE_REPO_DIR not found, creating $REMOTE_REPO_DIR"
	mkdir $REMOTE_REPO_DIR
else
	printf "REMOTE_REPO_DIR exist : $REMOTE_REPO_DIR"
fi




# init git repo

cd $REMOTE_REPO_DIR
if [ ! -d $REMOTE_REPO_DIR/.git ]; then
# if true; then
	
	printf "_________________________________________\nGit repo not found, initializing..."
	git init
	
	# config sparce checkout
	
	
	if [ ! -z "$SPARCE_DIR" ]; then
		printf "Initialize sparce checkout..."
		git config core.sparsecheckout true
		printf $SPARCE_DIR >> .git/info/sparse-checkout
		printf "ok"
	fi
	
	
	
	
	# generate ssh key
	if [ ! -e ~/.ssh/id_rsa.pub ]; then
	# if true; then
		printf "SSH key not found, generating..."
		ssh-keygen -t rsa -C "$SSH_EMAIL" -b 4096
		# ssh-keygen -f id_rsa -t rsa -N '$SSH_PASS' -C "$SSH_EMAIL" -b 4096
		
	else 
		printf "SSH key exists in : ~/.ssh/id_rsa.pub"
	fi
	
	# copy ssh key
	printf "SSH public key used : (add it in the repo if needed)"
	cat ~/.ssh/id_rsa.pub
	
	read -p "Press enter when the key is added"
	git remote add -f origin $GIT_URL
	
	
else
	printf "Git repo already exists"
fi



printf "_________________________________________\nGit pull..."
echo "Git pull..."

git reset --hard HEAD
if ! git pull origin master
then
    echo >&2 "Git pull failed"
    exit 1
fi




if [ ! -z "$SPARCE_DIR" ]; then
	cd $SPARCE_DIR
fi



# creation du symlink si nécéssaire
# (apres build car dossier non existant sinon)

if [ ! -z "$SYMLINK" ]; then
	
	printf "Creating symlink $SYMLINK"
	if [ -e  $REMOTE_WEBROOT_DIR/$SYMLINK ]; then
		rm $REMOTE_WEBROOT_DIR/$SYMLINK
	fi
	ln -s $REMOTE_REPO_DIR/$DIST_PATH $REMOTE_WEBROOT_DIR/$SYMLINK
	# printf "$REMOTE_REPO_DIR/$DIST_PATH    $REMOTE_WEBROOT_DIR/$SYMLINK"
	
fi




# build application (same as deploy-local.bat)

printf "_________________________________________\nBuild application"
printf $PWD

npm install
# npm install -g @angular/cli
ng build -c=$ENV --prod --base-href /$SYMLINK/ --deploy-url=/$SYMLINK/


printf "_________________________________________\nDeploy finished !"


# todo : 
# deploy symfony
# test SPARCE_DIR sans / pour règle générale
# prod / preprod (staging)
# 
# 

