# Cahier des charges

## Résumé du projet
Vite & Gourmand est une entreprise bordelaise de deux personnes, Julie et José, qui existe depuis 25 ans. Elle propose des prestations pour tout événement, comme un repas de Noël ou de Pâques, à travers des menus en constante évolution. Aujourd’hui, ces menus sont envoyés par mail aux clients habitués. Pour gagner en visibilité et toucher de nouveaux clients, Julie a eu l’idée d’une application web qui présente les menus à tous et permette de les commander en ligne. N’ayant pas de notions en informatique, Julie et José ont confié ce projet à FastDev, l’entreprise dans laquelle je suis développeur.

L’application s’adresse à quatre types d’acteurs. Le visiteur, non connecté, découvre l’entreprise sur la page d’accueil, consulte les menus grâce à des filtres dynamiques, crée un compte ou contacte l’entreprise par un formulaire. L’utilisateur commande un menu : le prix dépend du nombre de personnes, avec une réduction de 10 % à partir de cinq personnes au-delà du minimum, et des frais de livraison s’ajoutent hors de Bordeaux. Il suit ensuite sa commande, peut la modifier ou l’annuler avant son acceptation, puis donne son avis. L’employé gère les menus, les plats et les horaires, fait évoluer le statut des commandes et modère les avis. L’administrateur dispose des mêmes droits ; il gère en plus les comptes employés et consulte des statistiques : le nombre de commandes par menu, issu d’une base de données non relationnelle, et le chiffre d’affaires.

Enfin, le client exige une application déployée et fonctionnelle à la livraison, et accessible conformément au RGAA.


## Contexte
## Acteurs et rôles
| Acteur | Création du compte | Rôle dans l'application |
|---|---|---|
| **Visiteur** | Aucun compte (non connecté) | Consulte l'accueil et les menus, crée un compte, contacte l'entreprise par le formulaire |
| **Utilisateur** | Par le visiteur lui-même, à l'inscription | Commande un menu, suit, modifie ou annule ses commandes (avant acceptation), modifie ses informations personnelles, donne un avis |
| **Employé** | Par l'administrateur | Gère les menus, les plats et les horaires, fait évoluer le statut des commandes, valide ou refuse les avis |
| **Administrateur** | Par le développeur, pour José ; jamais depuis l'application | Dispose de tous les droits de l'employé, gère les comptes employés (création, désactivation), consulte les statistiques (commandes par menu, chiffre d'affaires) |

L'administrateur hérite des droits de l'employé : tout ce qu'un employé peut faire,
l'administrateur peut le faire aussi


## Spécifications fonctionnelles
### Espace public (visiteur)
#### Navigation et pied de page
#### Page d'accueil
#### Vue globale des menus
#### Vue détailée d'un menu
#### Création de compte
#### Connexion et mot de passe oublié
#### Contact 

### Espace utilisateur
#### Commande d'un menu
#### Suivi et gestion des commandes
#### Avis

### Espace employé
#### Gestion des menus, plats et horaires
#### Gestion des commandes
#### Modération des avis

### Espace administrateur
#### Gestion des comptes employés
#### Statistiques

## Contraintes