# Initialisation

## Base de données

Au préalable, il faut avoir télécharger l'application docker dekstop ou alors, faire en sorte que docker soit [installé](https://www.docker.com/products/docker-desktop/) localement sur la machine.

Pour commencer, il faut initialiser le conteneur docker se trouvant dans le répertoire BD. Une fois initialisé, le conteneur est prévu pour être écouté sur le port 5432. L'image provient d'un dépot [git postgresql](https://github.com/docker-library/postgres). Il contient l'image officiel.

L'initialisation début par taper **docker compose**, il initialisera la base de données sous format postgresql. Si après l'allumage du conteneur, la base de données est vide, il suffit d'utiliser l'extension de visual studio code pour les bases de données postgresql et de lancer le script. Si on travaille avec pycharm, il suffit d'utiliser l'extension bd de l'IDE pour que cela fonctionne.

## django

Pour le démarrage de django, il faut se trouver à la racine du projet à hauteur du manage.py. Pour lancer le serveur, il faut écrire dans un invite de commande l'instruction suivante :

- python manage.py runserver (par défaut django ouvre le port 8000, si on veut un autre port, il suffit d'écrire à la suite le numéro du port désiré)\newline

Pour que django utilise les tables de la base donnée, il faut télécharger le connecteur python permettant de se connecter à une bd postgresql. On tape alors la commande : *pip install psycopg2*.

Une fois le connecteur téléchargé, il faut peut être incorporé les modèles corrects, pour cela, on migre les modèles. On tape la commande : **python manage.py migrate**. Puis, la commande : **python manage.py makemigrations**. Si un problème d'utf8 se manifeste, il faut aller dans le fichier models.py qui a incorporé les modèles et changer son encodage en UTF-8.

