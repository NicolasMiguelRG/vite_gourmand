# Cahier des charges

## Résumé du projet

Vite & Gourmand est une entreprise bordelaise de deux personnes, Julie et José, qui existe depuis 25 ans. Elle propose des prestations pour tout événement, comme un repas de Noël ou de Pâques, à travers des menus en constante évolution. Aujourd'hui, ces menus sont envoyés par mail aux clients habitués. Pour gagner en visibilité et toucher de nouveaux clients, Julie a eu l'idée d'une application web qui présente les menus à tous et permette de les commander en ligne. N'ayant pas de notions en informatique, Julie et José ont confié ce projet à FastDev, l'entreprise dans laquelle je suis développeur.

L'application s'adresse à quatre types d'acteurs. Le visiteur, non connecté, découvre l'entreprise sur la page d'accueil, consulte les menus grâce à des filtres dynamiques, crée un compte ou contacte l'entreprise par un formulaire. L'utilisateur commande un menu : le prix dépend du nombre de personnes, avec une réduction de 10 % à partir de cinq personnes au-delà du minimum, et des frais de livraison s'ajoutent hors de Bordeaux. Il suit ensuite sa commande, peut la modifier ou l'annuler avant son acceptation, puis donne son avis. L'employé gère les menus, les plats et les horaires, fait évoluer le statut des commandes et modère les avis. L'administrateur dispose des mêmes droits ; il gère en plus les comptes employés et consulte des statistiques : le nombre de commandes par menu, issu d'une base de données non relationnelle, et le chiffre d'affaires.

Enfin, le client exige une application déployée et fonctionnelle à la livraison, et accessible conformément au RGAA.

## Acteurs et rôles

| Acteur | Création du compte | Rôle dans l'application |
|---|---|---|
| **Visiteur** | Aucun compte (non connecté) | Consulte l'accueil et les menus, crée un compte, contacte l'entreprise par le formulaire |
| **Utilisateur** | Par le visiteur lui-même, à l'inscription | Commande un menu, suit, modifie ou annule ses commandes (avant acceptation), modifie ses informations personnelles, donne un avis |
| **Employé** | Par l'administrateur | Gère les menus, les plats et les horaires, fait évoluer le statut des commandes, valide ou refuse les avis |
| **Administrateur** | Par le développeur, pour José ; jamais depuis l'application | Dispose de tous les droits de l'employé, gère les comptes employés (création, désactivation), consulte les statistiques (commandes par menu, chiffre d'affaires) |

L'administrateur hérite des droits de l'employé : tout ce qu'un employé peut faire,
l'administrateur peut le faire aussi.

## Spécifications fonctionnelles

### Espace public (visiteur)

#### Navigation et pied de page
- Barre de navigation contenant au minimum : retour à l'accueil, accès à tous les menus, connexion, accès à la page de contact
- Connexion réservée aux comptes utilisateur, employé et administrateur
- Possibilité d'ajouter d'autres rubriques, dans le respect du RGPD et de la sécurité
- Pied de page affichant les horaires d'ouverture, du lundi au dimanche
- Liens vers les mentions légales et les conditions générales de vente (CGV)

#### Page d'accueil
- Présentation de l'entreprise
- Mise en avant du professionnalisme de l'équipe
- Affichage des avis clients validés par un employé ou l'administrateur

#### Vue globale des menus
- Accessible aux personnes connectées comme non connectées
- Pour chaque menu : titre, description, nombre minimum de personnes, prix associé et bouton d'accès au détail
- Filtres : prix maximum, fourchette de prix, thème, régime, nombre minimum de personnes
- Mise à jour dynamique des menus affichés, sans rechargement de la page

#### Vue détaillée d'un menu
- Affichage de toutes les informations du menu : titre, galerie d'images, description, thème, régime, liste des plats (entrées, plats, desserts) avec leurs allergènes, nombre minimum de personnes, prix, conditions et stock disponible
- Conditions du menu mises en évidence, pour que le client ne puisse pas dire qu'il ne les a pas vues
- Bouton « Commander » :
    - personne connectée : redirection vers la page de commande, avec le menu déjà sélectionné
    - visiteur : invitation à se connecter ou à créer un compte avant d'accéder à la commande

#### Création de compte
- Informations demandées : nom, prénom, numéro de GSM, adresse mail, adresse postale, mot de passe sécurisé
- Attribution automatique du rôle « utilisateur »
- Envoi automatique d'un mail de bienvenue

#### Connexion et mot de passe oublié
- Connexion avec l'adresse mail (identifiant) et le mot de passe
- Mot de passe oublié : le visiteur saisit son adresse mail et reçoit un lien de réinitialisation par mail

#### Contact
- Page accessible depuis la barre de navigation
- Formulaire demandant un titre, une description et l'adresse mail du visiteur, pour lui répondre
- Demande transmise par mail à l'entreprise

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

## Règles de gestion

## Contraintes