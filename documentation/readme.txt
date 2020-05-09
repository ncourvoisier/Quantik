joueur.sh permet de lancer le joueur avec son IA au serveur.
La joueur doit être lancé en après le serveur.

Par défaut, il y a trois paramètres :
$1 : l'adresse IP du serveur distant
$2 : le port du seveur distant
$3 : le nom du joueur

Exemple de lancement : './joueur.sh 127.0.0.1 3333 NicolasAugustin'

En option, on peut changer le port d'échange entre le joueur et l'IA, par défaut le port est 2567.
$4 : le port d'échange avec l'IA

Exemple de lancement : './joueur.sh 127.0.0.1 3333 NicolasAugustin 4444'
