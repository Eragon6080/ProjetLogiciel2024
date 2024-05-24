# Initialisation en local

## Base de données

Au préalable, il faut avoir télécharger l'application docker dekstop ou alors, faire en sorte que docker soit [installé](https://www.docker.com/products/docker-desktop/) localement sur la machine.

Pour commencer, il faut initialiser le conteneur docker se trouvant dans le répertoire BD. Une fois initialisé, le conteneur est prévu pour être écouté sur le port 5432. L'image provient d'un dépôt [git postgresql](https://github.com/docker-library/postgres). Il contient l'image officiel.

L'initialisation débute par taper **docker compose** en se trouvant à l'endroit du script docker compose, il initialisera la base de données sous format postgresql. Si après l'allumage du conteneur, la base de données est vide, il suffit d'utiliser l'extension de visual studio code pour les bases de données postgresql et de lancer le script. Si on travaille avec pycharm, il suffit d'utiliser l'extension bd de l'IDE pour que cela fonctionne. A condition de se connecter au préalable sur la base de données.

Les identifiants de la base de données avec ce conteneur docker est : 
- HOST : localhost:5432
- USER : admin
- Password : admin
- database : admin
- URL : jdbc:postgresql://localhost:5432

## django

Pour le démarrage de django, il faut se trouver à la racine du projet à hauteur du manage.py. Pour lancer le serveur, il faut écrire dans un invite de commande l'instruction suivante :

- python manage.py runserver (par défaut django ouvre le port 8000, si on veut un autre port, il suffit d'écrire à la suite le numéro du port désiré)\newline

Pour que django utilise les tables de la base donnée, il faut télécharger le connecteur python permettant de se connecter à une bd postgresql. On tape alors la commande : *pip install psycopg2*.

Une fois le connecteur téléchargé, il faut peut être incorporé les modèles corrects, pour cela, on migre les modèles. On tape la commande : **python manage.py migrate**. Puis, la commande : **python manage.py makemigrations**. Si un problème d'utf8 se manifeste, il faut aller dans le fichier models.py qui a incorporé les modèles et changer son encodage en UTF-8.

# Initialisation en ligne

## Base de données
La base de données se trouvent maintenant en ligne. Pour se connecter, il suffit d'utiliser soit l'extension de visual studio code pour les bases de données postgresql et de lancer le script. Si on travaille avec pycharm, il suffit d'utiliser l'extension BD de l'IDE pour que cela fonctionne.  La connexion à la BD se fait en utilisant les identifiants suivants : 
 - HOST : dpg-cooc4gev3ddc738l4ql0-a.oregon-postgres.render.com
 - database : admin_8u5u
 - USER : admin
 - Password : admin
 - URL : jdbc:postgresql://dpg-cooc4gev3ddc738l4ql0-a.oregon-postgres.render.com:5432/admin_8u5u
Pour manipuler les données, il suffit de faire tourner le script sql à l'endroit prévu par votre IDE.
## django
La mise en ligne du site est semi-automatisée grâce aux "github actions". Le conteneur et l'envoi sur le hub de docker se fait de cette manière. Ce qui n'est pas encore automatique est la récupération de ce conteneur sur render pour qu'il déploie l'application. Pour forcer render à le faire, il faut 
se rendre à [l'adresse suivante](https://dashboard.render.com/web/srv-copleqa1hbls73fmhs10) et d'aller sur le menu déroulant 'Manual deploy' et de cliquer 'deploy latest reference'. Dès lors, il déploiera la dernière version du conteneur de l'application en ligne.

Le site est disponible à l'adresse suivante : https://genie-logiciel.onrender.com/

