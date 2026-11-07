# Cahier des charges

Ce document est rédigé à partir de l'expression du besoin transmise par le chef de projet.
Les numéros de page entre parenthèses renvoient à ce document.

## Résumé du projet

Vite & Gourmand est une entreprise bordelaise de deux personnes, Julie et José, qui existe depuis 25 ans. Elle propose des prestations pour tout événement, comme un repas de Noël ou de Pâques, à travers des menus en constante évolution. Aujourd'hui, ces menus sont envoyés par mail aux clients habitués. Pour gagner en visibilité et toucher de nouveaux clients, Julie a eu l'idée d'une application web qui présente les menus à tous et permette de les commander en ligne. N'ayant pas de notions en informatique, Julie et José ont confié ce projet à FastDev, l'entreprise dans laquelle je suis développeur.

L'application s'adresse à quatre types d'acteurs. Le visiteur, non connecté, découvre l'entreprise sur la page d'accueil, consulte les menus grâce à des filtres dynamiques, crée un compte ou contacte l'entreprise par un formulaire. L'utilisateur commande un menu : le prix dépend du nombre de personnes, avec une réduction de 10 % à partir de cinq personnes au-delà du minimum, et des frais de livraison s'ajoutent hors de Bordeaux. Il suit ensuite sa commande, peut la modifier ou l'annuler avant son acceptation, puis donne son avis. L'employé gère les menus, les plats et les horaires, fait évoluer le statut des commandes et modère les avis. L'administrateur dispose des mêmes droits ; il gère en plus les comptes employés et consulte des statistiques : le nombre de commandes par menu, issu d'une base de données non relationnelle, et le chiffre d'affaires.

Enfin, le client exige une application déployée et fonctionnelle à la livraison, et accessible conformément au RGAA.

## Acteurs et rôles

| Acteur             | Création du compte                                          | Rôle dans l'application                                                                                                                                          |
| ------------------ | ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Visiteur**       | Aucun compte (non connecté)                                 | Consulte l'accueil et les menus, crée un compte, contacte l'entreprise par le formulaire                                                                         |
| **Utilisateur**    | Par le visiteur lui-même, à l'inscription                   | Commande un menu, suit, modifie ou annule ses commandes (avant acceptation), modifie ses informations personnelles, donne un avis                                |
| **Employé**        | Par l'administrateur                                        | Gère les menus, les plats et les horaires, fait évoluer le statut des commandes, valide ou refuse les avis                                                       |
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

- Accessible depuis le bouton « Commander » de la vue détaillée d'un menu
- Nom, prénom, adresse mail et numéro de GSM préremplis à partir du compte
- Informations de la prestation : adresse, date, heure de livraison souhaitée et lieu
- Menu déjà sélectionné si l'utilisateur vient de la vue détaillée, sinon à choisir
- Choix du nombre de personnes, avec mise à jour du prix et respect du minimum imposé par le menu
- Calcul des frais de livraison selon l'adresse de la prestation
- Application d'une réduction selon le nombre de personnes
- Récapitulatif détaillé du prix avant validation (prix du menu et prix de la livraison)
- Envoi d'un mail de confirmation après la commande

#### Suivi et gestion des commandes

- Consultation du détail de toutes ses commandes
- Modification ou annulation d'une commande tant qu'elle n'a pas été acceptée par un employé ; tout est modifiable sauf le menu choisi
- Après acceptation : accès au suivi de la commande, qui liste tous ses statuts avec la date et l'heure de chaque changement

#### Avis

- Notification par mail quand la commande est terminée, invitant l'utilisateur à donner son avis
- Avis donné depuis la commande : une note de 1 à 5 et un commentaire
- Avis affiché sur la page d'accueil uniquement après validation par un employé ou l'administrateur

#### Informations personnelles

- Modification de ses informations personnelles

### Espace employé

### Compte 
- Remplacement obligatoire du mot de passe provisoire par un mot de passe personnel à la première connexion (RG-10 bis)

#### Gestion des menus, plats et horaires

- Création, modification et suppression des menus
- Création, modification et suppression des plats, avec leurs allergènes
- Modification des horaires affichés dans le pied de page

#### Gestion des commandes

- Filtre des commandes par statut ou par client, pour retrouver rapidement les commandes à traiter
- Mise à jour du statut des commandes : accepté, en préparation, en cours de livraison, livré, en attente du retour de matériel, terminée
- Envoi automatique d'un mail au client lorsque la commande passe « en attente du retour de matériel », pour lui rappeler les conditions de restitution
- Modification ou annulation d'une commande uniquement après avoir contacté le client (appel GSM ou mail), avec saisie du mode de contact et du motif

#### Modération des avis

- Validation ou refus des avis laissés par les utilisateurs
- Seuls les avis validés sont affichés sur la page d'accueil

### Espace administrateur

L'administrateur dispose de toutes les fonctionnalités de l'espace employé, ainsi que des suivantes.

#### Gestion des comptes employés

- Création d'un compte employé avec une adresse mail (identifiant) et un mot de passe provisoire
- Envoi automatique d'un mail à l'employé pour l'informer de la création de son compte, sans communiquer le mot de passe
- Désactivation d'un compte employé, par exemple en cas de départ de l'entreprise
- Aucune création de compte administrateur possible depuis l'application

#### Statistiques

- Nombre de commandes par menu, avec un graphique pour comparer les menus entre eux (données issues de la base non relationnelle)
- Calcul du chiffre d'affaires par menu, avec un filtre par menu et un filtre sur une période

## Règles de gestion

Les règles marquées « interprétation » ne figurent pas explicitement dans l'expression du besoin : ce sont des choix
que j'ai faits lorsque l'expression du besoin était incomplète ou ambiguë. Ils sont justifiés dans le tableau
« Choix d'interprétation » en fin de section.

### Menus et plats

- **RG-01** : Un menu possède un thème parmi : Noël, Pâques, classique, événement (p. 4).
- **RG-02** : Un menu possède un régime parmi : classique, végétarien, vegan, pescétarien, sans gluten, sans lactose. Les régimes sont stockés en base de données : un employé ou l'administrateur peut en ajouter (p. 4 ; ajout autorisé par l'expression du besoin).
- **RG-03** : Un plat est une entrée, un plat principal ou un dessert, et peut appartenir à plusieurs menus (p. 4).
- **RG-04** : Un plat peut posséder une liste d'allergènes (p. 4).
- **RG-05** : Le prix d'un menu est défini pour son nombre minimum de personnes (p. 4).
- **RG-06** : Le stock indique le nombre de commandes encore possibles pour un menu. Il diminue de 1 à chaque commande ; à 0, le menu ne peut plus être commandé (interprétation).

### Comptes et connexion

- **RG-07** : Le mot de passe contient au moins 10 caractères, dont au moins une majuscule, une minuscule, un chiffre et un caractère spécial (p. 5).
- **RG-08** : L'adresse mail sert d'identifiant et doit être unique (p. 5 ; unicité : interprétation).
- **RG-09** : Un compte créé par inscription reçoit le rôle « utilisateur » (p. 5).
- **RG-10** : Seul l'administrateur peut créer un compte employé, avec une adresse mail et un mot de passe provisoire. Le mot de passe n'est jamais envoyé par mail : l'employé l'obtient auprès de l'administrateur (p. 9).
- **RG-10 bis** : À sa première connexion, l'employé doit remplacer le mot de passe provisoire par un mot de passe personnel (interprétation).
- **RG-11** : Un compte employé désactivé ne peut plus se connecter (p. 9).
- **RG-12** : Il existe un seul compte administrateur, créé par le développeur ; aucun compte administrateur ne peut être créé depuis l'application (p. 9).

### Calcul du prix d'une commande

- **RG-13** : Le nombre de personnes doit être supérieur ou égal au nombre minimum du menu (p. 7).
- **RG-14** : Le prix du menu est proportionnel au nombre de personnes : (prix du menu ÷ nombre minimum) × nombre de personnes (interprétation).
- **RG-15** : Une réduction de 10 % s'applique sur le prix du menu dès que le nombre de personnes atteint le minimum + 5 (p. 7 ; « dès que » : interprétation).
- **RG-16** : Livraison dans la ville de Bordeaux : gratuite. Hors de Bordeaux : 5 € + 0,59 € par kilomètre, calculés depuis l'adresse de l'entreprise (p. 7 ; point de départ : interprétation).
- **RG-17** : La réduction ne s'applique pas aux frais de livraison (interprétation).
- **RG-18** : Prix total = prix du menu après réduction + frais de livraison. Le détail est affiché avant validation (p. 7).

### Statuts d'une commande

- **RG-19** : Une commande passée reçoit le statut « en attente » (interprétation).
- **RG-20** : Ordre des statuts : en attente → accepté → en préparation → en cours de livraison → livré → (en attente du retour de matériel) → terminée (p. 8).
- **RG-21** : Chaque changement de statut est enregistré avec sa date et son heure (p. 7).
- **RG-22** : L'utilisateur peut modifier ou annuler sa commande uniquement au statut « en attente ». Le menu choisi n'est pas modifiable (p. 7).
- **RG-23** : Un employé ne peut modifier ou annuler une commande qu'après avoir contacté le client ; le mode de contact (GSM ou mail) et le motif sont obligatoires (p. 8).
- **RG-24** : Au statut « en attente du retour de matériel », un mail informe le client qu'il dispose de 10 jours ouvrés pour restituer le matériel, sous peine de 600 € de frais prévus par les CGV (p. 8).
- **RG-25** : Une commande est « terminée » quand elle a été livrée sans prêt de matériel, ou quand le matériel a été restitué. Un mail invite alors l'utilisateur à donner son avis (p. 7-8).

### Avis

- **RG-26** : Un avis ne peut être donné que sur une commande terminée, et une seule fois par commande (p. 7 ; « une seule fois » : interprétation).
- **RG-27** : Un avis comprend une note entière de 1 à 5 et un commentaire (p. 7).
- **RG-28** : Un avis est en attente jusqu'à sa validation ou son refus par un employé ; seuls les avis validés sont affichés (p. 8).

### Choix d'interprétation

| Règle     | Ambiguïté de l'expression du besoin                                 | Choix retenu et justification                                                                                                                                                     |
| --------- | ------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| RG-02     | L'expression du besoin cite trois régimes et autorise à en ajouter  | Ajout de pescétarien, sans gluten et sans lactose, régimes courants en restauration. Régimes stockés en base de données pour que l'équipe puisse en ajouter sans modifier le code |
| RG-06     | Le fonctionnement du stock n'est pas détaillé                       | Une commande consomme une unité : c'est le sens de « il reste 5 commandes possibles »                                                                                             |
| RG-08     | L'unicité du mail n'est pas mentionnée                              | Le mail sert d'identifiant, donc deux comptes ne peuvent pas partager le même                                                                                                     |
| RG-10 bis | L'administrateur connaît le mot de passe de l'employé               | Changement obligatoire à la première connexion : l'exigence du client est respectée, et seul l'employé connaît son mot de passe définitif                                         |
| RG-14     | Le calcul du prix selon le nombre de personnes n'est pas précisé    | Un prix proportionnel est le plus simple à comprendre pour le client                                                                                                              |
| RG-15     | « 5 personnes de plus » peut se lire « exactement » ou « au moins » | « Au moins » : une remise qui disparaîtrait à 6 personnes de plus n'aurait pas de sens                                                                                            |
| RG-16     | Le point de départ du kilométrage n'est pas indiqué                 | L'adresse de l'entreprise, d'où partent les livraisons                                                                                                                            |
| RG-17     | Le périmètre de la réduction n'est pas précisé                      | L'expression du besoin lie la réduction au nombre de personnes, donc au prix du menu seulement                                                                                    |
| RG-19     | Aucun statut n'est nommé avant « accepté »                          | « En attente » désigne une commande reçue mais pas encore validée par l'équipe                                                                                                    |
| RG-26     | Le nombre d'avis par commande n'est pas limité                      | Un avis par commande évite les doublons et reste fidèle à « depuis la commande »                                                                                                  |

## Contraintes

### Réglementaires

- **RGPD** : respect de la réglementation sur les données personnelles. Seules les données nécessaires sont collectées, et des mentions légales sont accessibles depuis le pied de page (p. 4).
- **RGAA** : l'application doit être accessible, conformément au référentiel général d'amélioration de l'accessibilité (p. 9).

### Sécurité

- Respect des aspects de sécurité dans toute l'application, notamment pour la connexion et les formulaires (p. 4).
- Mots de passe conformes à la règle RG-07.
- Les dispositions de sécurité prises doivent être détaillées dans la documentation (p. 11).

### Techniques

- Utilisation obligatoire d'une base de données relationnelle et d'une base de données non relationnelle ; aucune autre technologie n'est imposée (p. 10).
- Les statistiques de l'administrateur proviennent de la base non relationnelle (p. 9).
- Application utilisable sur ordinateur et sur mobile : des maquettes bureau et mobile sont exigées (p. 11).

### Déploiement

- L'application doit être en ligne et fonctionnelle au moment de la livraison, sous peine de pénalités (p. 9).
- La démarche et les étapes du déploiement doivent être documentées (p. 12).

### Livraison et bonnes pratiques

- Dépôt GitHub public, avec une branche principale, une branche de développement et une branche par fonctionnalité (p. 11).
- Fichier `README.md` expliquant l'installation de l'application en local (p. 11).
- Fichiers SQL de création de la base et d'insertion des données ; les fixtures et migrations ne suffisent pas (p. 11).
- Manuel d'utilisation et charte graphique au format PDF (p. 11).

### Hors périmètre

- Paiement en ligne : l'expression du besoin n'en fait pas mention. La commande est validée sans paiement dans l'application ; le règlement se fait en dehors. Une évolution possible serait d'intégrer un prestataire de paiement spécialisé, pour ne jamais stocker de données bancaires.
