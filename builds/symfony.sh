# SYMFONY

composer install

# maybe useless, try to remove if possible
export SYMFONY_ENV=prod
export SYMFONY_DEBUG=0


echo "cache:clear"
php bin/console cache:clear --env=$ENV

echo "doctrine:schema:create"
php bin/console doctrine:schema:create --no-debug

# todo : maybe if SYMFONY_ENV==prod ? ou !=dev

echo "doctrine:ensure-production-settings"
php bin/console doctrine:ensure-production-settings

echo "doctrine:schema:update"
php bin/console doctrine:schema:update --force