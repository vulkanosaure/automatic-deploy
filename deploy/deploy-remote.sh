# Dependencies :
 
# git
# composer
# node
# npm
# npm/angular-cli



# todo : 
# si se trompe sur le sparse_dir, faut supprimer le git pour réutiliser
# command pour reset (argument ?)
# separer set de constantes selon environment (group)
# gestion env preprod


# PREPROD

REMOTE_REPO_DIR=/var/www/clients/client0/web1/web/map/front
REMOTE_WEBROOT_DIR=/var/www/clients/client0/web1/web
SSH_DIR=/var/www/clients/client0/web2/.ssh
ENV=production


# PROD

# REMOTE_REPO_DIR=/var/www/clients/client0/web2/web/map/front
# REMOTE_WEBROOT_DIR=/var/www/clients/client0/web2/web
# SSH_DIR=/var/www/clients/client0/web2/.ssh
# ENV=production



# the git url repo (use ssh, not http)
GIT_URL=git@gitlab.com:data-projekt/PAS-MAP2.git
# relative path from repo to src  (used for symlink)
DIST_PATH=SRC/FRONT-MAP/dist/FRONT-MAP
# if not every git folder must be pulled
SPARCE_DIR=SRC/FRONT-MAP
# symlink (no /, optionnel)
SYMLINK=carte-interactive
# ssh email
SSH_EMAIL=vincent.huss@gmail.com






# create src directory

if [ ! -d "$REMOTE_REPO_DIR" ]; then
	printf "REMOTE_REPO_DIR not found, creating $REMOTE_REPO_DIR"
	mkdir -p $REMOTE_REPO_DIR
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
	if [ ! -e $SSH_DIR/id_rsa.pub ]; then
	# if true; then
		echo "SSH key not found, generating..."
		
		# create dir if not exist
		if [ ! -d "$SSH_DIR" ]; then
			echo "Create ssh key folder $SSH_DIR"
			mkdir -p $SSH_DIR
		fi
		
		ssh-keygen -t rsa -C "$SSH_EMAIL" -b 4096 -f $SSH_DIR/id_rsa
		# ssh-keygen -f id_rsa -t rsa -N '$SSH_PASS' -C "$SSH_EMAIL" -b 4096
		
	else 
		echo "SSH key exists in : $SSH_DIR/id_rsa.pub"
	fi
	
	# copy ssh key
	echo "SSH public key used : (add it in the repo if needed)"
	cat $SSH_DIR/id_rsa.pub
	
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







# build application (same as deploy-local.bat)

printf "_________________________________________\nBuild application"
printf $PWD

npm install
# npm install -g @angular/cli
ng build -c=$ENV --prod --base-href /$SYMLINK/ --deploy-url=/$SYMLINK/







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






printf "_________________________________________\nDeploy finished !"


# todo : 
# deploy symfony
# test SPARCE_DIR sans / pour règle générale
# prod / preprod (staging)
# 
# 

