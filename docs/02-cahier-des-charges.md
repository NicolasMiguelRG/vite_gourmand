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
- Pied de page affichant les horaires d'ouverture, du lundi au dimanche ; un jour sans horaires est indiqué « Fermé »
- Liens vers les mentions légales et les conditions générales de vente (CGV)

#### Page d'accueil

- Présentation de l'entreprise
- Mise en avant du professionnalisme de l'équipe
- Affichage des avis clients validés par un employé ou l'administrateur
- Chaque avis affiche sa note, son commentaire et le menu concerné, avec la mention « menu plus proposé » si ce menu a été archivé
- Nom du client non affiché, pour ne publier que les données nécessaires (RGPD)
- Message indiquant qu'aucun avis n'est encore disponible, si aucun avis n'a été validé

#### Vue globale des menus

- Accessible aux personnes connectées comme non connectées
- Affichage des menus publiés uniquement
- Pour chaque menu : image principale, titre, description, nombre minimum de personnes, prix associé et bouton d'accès au détail
- Menu épuisé (stock à 0) toujours affiché, avec une mention indiquant qu'il est épuisé
- Filtres : prix maximum, fourchette de prix, thème, régime, nombre de personnes
- Filtre « nombre de personnes » : affiche les menus dont le nombre minimum est inférieur ou égal au nombre saisi
- Filtres combinables, avec un bouton pour les réinitialiser
- Mise à jour dynamique des menus affichés, sans rechargement de la page
- Message indiquant qu'aucun menu ne correspond, si les filtres ne donnent aucun résultat

#### Vue détaillée d'un menu

- Affichage de toutes les informations du menu : titre, galerie d'images, description, thème, régime, liste des plats (entrées, plats, desserts) avec leurs allergènes, nombre minimum de personnes, prix, conditions et stock disponible
- Photo de chaque plat, s'il en possède une
- Conditions du menu mises en évidence, pour que le client ne puisse pas dire qu'il ne les a pas vues
- Matériel prêté : si le menu ou l'un de ses plats en comprend, affichage de la liste du matériel et d'un rappel des conditions de restitution
- Bouton « Commander » :
  - personne connectée : redirection vers la page de commande, avec le menu déjà sélectionné
  - visiteur : invitation à se connecter ou à créer un compte avant d'accéder à la commande
  - menu épuisé (stock à 0) : bouton désactivé, avec une mention indiquant que le menu est épuisé

#### Création de compte

- Informations demandées : nom, prénom, numéro de GSM, adresse mail, adresse postale, mot de passe sécurisé
- Le mot de passe est saisi deux fois, à l'identique
- Attribution automatique du rôle « utilisateur »
- Envoi automatique d'un mail de bienvenue, contenant un lien de confirmation de l'adresse mail : le compte n'est activé qu'après un clic sur ce lien
- Même message affiché après l'envoi du formulaire, que l'adresse mail soit nouvelle ou déjà utilisée
- Adresse déjà utilisée : aucun compte n'est créé, et un mail informe son titulaire qu'il possède déjà un compte et l'invite à se connecter ou à réinitialiser son mot de passe

#### Connexion et mot de passe oublié

- Connexion avec l'adresse mail (identifiant) et le mot de passe
- Après connexion, redirection vers l'espace correspondant au compte : utilisateur, employé ou administrateur
- Identifiants erronés : message générique, sans indiquer si l'adresse mail existe
- Connexion impossible tant que l'adresse mail n'a pas été confirmée, avec un message invitant à cliquer sur le lien reçu
- Nombre de tentatives de connexion limité
- Bouton « Déconnexion » dans la barre de navigation
- Mot de passe oublié : le visiteur saisit son adresse mail et reçoit un lien de réinitialisation par mail
- Même message affiché après la demande, que le compte existe ou non ; aucun mail n'est envoyé si le compte n'existe pas
- Lien de réinitialisation à usage unique et à durée limitée
- Nouveau mot de passe saisi deux fois, à l'identique
- Mail informant l'utilisateur que son mot de passe a été modifié, sans le contenir

#### Contact

- Page accessible depuis la barre de navigation
- Formulaire demandant un titre, une description et l'adresse mail du visiteur, pour lui répondre
- Erreur de saisie (champ vide, adresse mail invalide) : message précis pour le champ concerné
- Demande transmise par mail à l'entreprise
- Message confirmant au visiteur que sa demande a été envoyée
- Nombre d'envois limité, et protection contre les envois automatisés

### Espace utilisateur

#### Commande d'un menu

- Accessible depuis le bouton « Commander » de la vue détaillée d'un menu
- Nom, prénom, adresse mail et numéro de GSM préremplis à partir du compte
- Informations de la prestation : adresse, date, heure de livraison souhaitée et lieu
- Adresse de la prestation saisie, ou reprise en un clic depuis l'adresse enregistrée dans le compte
- Calendrier bloquant les dates passées et celles qui ne respectent pas le délai minimum de commande du menu
- Menu déjà sélectionné si l'utilisateur vient de la vue détaillée, sinon à choisir
- Choix du nombre de personnes, avec mise à jour du prix et respect du minimum imposé par le menu
- Calcul automatique des frais de livraison selon l'adresse de la prestation : si l'adresse est introuvable ou la distance incalculable, un message s'affiche et la commande ne peut pas être validée
- Application d'une réduction selon le nombre de personnes ; la condition de réduction est indiquée pour le menu choisi, et la réduction apparaît ou disparaît dynamiquement
- Récapitulatif détaillé du prix avant validation (prix du menu, réduction éventuelle, frais de livraison et total), mis à jour quand l'adresse ou le nombre de personnes change
- Acceptation des CGV obligatoire pour valider la commande
- Prix vérifié à la validation : s'il a changé, le nouveau prix est affiché et l'utilisateur doit valider à nouveau
- Envoi d'un mail de confirmation après la commande

#### Suivi et gestion des commandes

- Consultation du détail de toutes ses commandes, de la plus récente à la plus ancienne (date de la prestation, menu, statut, prix total), puis du détail de chacune
- Actions proposées selon le statut : modifier ou annuler (« en attente »), suivre (à partir de « accepté »), donner un avis (« terminée », sans avis existant)
- Accès limité à ses propres commandes
- Modification ou annulation d'une commande tant qu'elle n'a pas été acceptée par un employé ; tout est modifiable sauf le menu choisi
- Modification : mêmes règles qu'à la commande, nouveau récapitulatif du prix à valider, puis mail récapitulatif
- Modification par le client enregistrée dans l'historique de la commande, visible par l'employé
- Annulation : confirmation demandée, puis message à l'écran et mail de confirmation ; la commande passe au statut « annulée » et reste visible dans la liste
- Commande acceptée entre-temps : la modification ou l'annulation est refusée, avec un message explicatif
- Après acceptation : accès au suivi de la commande, qui liste tous ses statuts avec la date et l'heure de chaque changement, le statut actuel étant mis en évidence

#### Avis

- Notification par mail quand la commande est terminée, invitant l'utilisateur à donner son avis ; le lien du mail mène au formulaire d'avis, après connexion si nécessaire
- Bouton « Donner mon avis » dans le détail d'une commande terminée, tant qu'aucun avis n'a été donné pour elle
- Avis donné depuis la commande : une note de 1 à 5 et un commentaire
- Note sous forme d'étoiles, utilisables au clavier et lisibles par un lecteur d'écran
- Un seul avis par commande
- Message informant l'utilisateur que son avis sera publié après validation
- Avis affiché sur la page d'accueil uniquement après validation par un employé ou l'administrateur

#### Informations personnelles

- Modification de ses informations personnelles : nom, prénom, numéro de GSM, adresse postale et adresse mail
- Changement d'adresse mail : mot de passe actuel exigé, adresse refusée si elle est déjà utilisée, et mail d'alerte envoyé à l'ancienne adresse
- Changement de mot de passe dans un formulaire séparé : mot de passe actuel exigé, nouveau mot de passe saisi deux fois à l'identique, puis mail informant l'utilisateur de la modification, sans le contenir
- Informations modifiées utilisées pour préremplir les prochaines commandes, sans changer les commandes existantes
- Message confirmant l'enregistrement des modifications

### Espace employé

#### Compte

- Remplacement obligatoire du mot de passe provisoire par un mot de passe personnel à la première connexion (RG-10 bis)
- Tant que le mot de passe provisoire n'est pas remplacé, toute page de l'espace employé renvoie vers le formulaire de changement
- Nouveau mot de passe saisi deux fois à l'identique, et différent du mot de passe provisoire
- Après le changement, fermeture de la session : l'employé se reconnecte avec son nouveau mot de passe
- Mail informant l'employé que son mot de passe a été modifié, sans le contenir

#### Gestion des menus, plats et horaires

- Rubrique « Gestion des menus » listant tous les menus, quel que soit leur statut : brouillon, publié ou archivé
- Création, modification et suppression des menus
- Informations d'un menu : titre, description, thème, régime, plats, nombre minimum de personnes, prix pour ce minimum, conditions, délai minimum de commande, stock, et matériel prêté éventuel avec sa description
- Thème et régime choisis dans des listes ; plats choisis dans le catalogue par une recherche à la saisie, rangés automatiquement par catégorie
- Valeurs impossibles refusées avec un message (prix, nombre minimum, stock ou délai)
- Menu créé au statut « brouillon », invisible pour les clients, puis rendu visible par un bouton « Publier » ; un menu publié peut repasser en brouillon
- Modification appliquée aux nouvelles commandes uniquement : les commandes existantes conservent les informations et le prix validés par le client
- Suppression = archivage, après confirmation : le menu n'est plus visible ni commandable, mais il est conservé (commandes en cours, avis, statistiques) et peut être republié
- Galerie d'images : ajout et suppression de photos, choix de l'image principale, texte alternatif obligatoire pour chaque photo
- Publication impossible sans au moins une photo
- Rubrique « Gestion des plats » listant les plats du catalogue, avec les boutons Ajouter, Modifier et Archiver
- Informations d'un plat : nom, catégorie (entrée, plat ou dessert), allergènes, photo facultative avec texte alternatif, et matériel prêté éventuel avec sa description
- Allergènes choisis dans la liste des allergènes à déclaration obligatoire
- Modification d'un plat, allergènes compris, appliquée immédiatement à tous les menus qui le contiennent ; les commandes existantes conservent la composition et les allergènes validés par le client
- Archivage d'un plat impossible tant qu'il est utilisé dans un menu publié
- Modification des horaires affichés dans le pied de page : deux plages horaires possibles par jour, ou « Fermé »
- Rubrique « Régimes et thèmes » : ajout d'un régime alimentaire ou d'un thème aux listes proposées ; un nom déjà existant est refusé, sans tenir compte des majuscules ni des accents
- Suppression impossible d'un régime ou d'un thème utilisé par au moins un menu ; un message indique les menus concernés

#### Gestion des commandes

- Rubrique « Commandes » affichant par défaut les commandes à traiter (ni terminées ni annulées), triées par date de prestation, la plus proche en premier
- Pour chaque commande : date et heure de la prestation, client, menu, nombre de personnes et statut
- Détail d'une commande : coordonnées du client, adresse, date et heure de livraison, menu avec la composition et les allergènes validés, nombre de personnes, détail du prix, statut et historique (statuts, modifications, contacts)
- Filtre des commandes par statut ou par client, pour retrouver rapidement les commandes à traiter ; filtres combinables, mis à jour sans rechargement de la page, avec un bouton pour les réinitialiser
- Mise à jour du statut des commandes : accepté, en préparation, en cours de livraison, livré, en attente du retour de matériel, terminée
- Seuls les statuts suivants autorisés sont proposés ; après « livré », le statut suivant est « en attente du retour de matériel » si du matériel a été prêté, « terminée » sinon
- Chaque changement de statut demande une confirmation et est enregistré avec l'employé qui l'a effectué
- Envoi automatique d'un mail au client lorsque la commande passe « en attente du retour de matériel », pour lui rappeler les conditions de restitution
- Envoi automatique d'un mail au client lorsque la commande passe « terminée », pour l'inviter à donner son avis
- Échec d'envoi d'un mail : le changement de statut est quand même enregistré, et l'employé en est averti
- Modification ou annulation d'une commande uniquement après avoir contacté le client (appel GSM ou mail), avec saisie du mode de contact et du motif
- Motif saisi en premier, puis contact du client par un bouton « GSM » ou « Mail » ; le mail est prérempli et le contact est enregistré automatiquement au clic
- Modification ou annulation possible tant que la commande n'est pas « en cours de livraison »
- Modification : accord du client obligatoire ; prix, réduction et frais de livraison recalculés ; le menu n'est pas modifiable ; mail récapitulatif envoyé au client avec le nouveau prix
- Client en désaccord : la démarche est close sans modifier la commande, et le contact, le motif et le désaccord restent enregistrés dans l'historique
- Annulation : accord du client non exigé, confirmation demandée ; la commande passe au statut « annulée » et le client reçoit un mail l'informant de l'annulation et de son motif

#### Modération des avis

- Rubrique « Avis » avec trois listes : en attente, validés, refusés ; les avis en attente s'affichent du plus ancien au plus récent
- Pour chaque avis : commentaire, menu concerné et date ; la note n'est pas affichée, pour que la décision porte uniquement sur le contenu du texte
- Validation ou refus des avis laissés par les utilisateurs
- Refus avec un motif obligatoire ; le client reçoit un mail l'informant du refus, avec ce motif
- Retrait d'un avis validé, avec un motif obligatoire : il passe en « refusé » et disparaît de la page d'accueil
- Chaque décision est enregistrée avec la date, l'heure et l'employé
- Seuls les avis validés sont affichés sur la page d'accueil

### Espace administrateur

L'administrateur dispose de toutes les fonctionnalités de l'espace employé, ainsi que des suivantes.

#### Gestion des comptes employés

- Rubrique « Comptes employés » listant tous les comptes employés avec leur statut (actif ou désactivé), et une recherche par nom, prénom ou adresse mail
- Création d'un compte employé avec une adresse mail (identifiant) et un mot de passe provisoire
- Informations demandées : nom, prénom et adresse mail uniquement, pour ne collecter que les données nécessaires (RGPD)
- Mot de passe provisoire généré aléatoirement et affiché, pour que l'administrateur le transmette oralement à l'employé
- Adresse mail déjà utilisée : création refusée avec un message clair
- Envoi automatique d'un mail à l'employé pour l'informer de la création de son compte, avec un lien vers la page de connexion, sans communiquer le mot de passe
- Désactivation d'un compte employé, par exemple en cas de départ de l'entreprise
- Désactivation après confirmation, avec effet immédiat : les sessions ouvertes de ce compte sont fermées, et son historique d'actions est conservé
- Réactivation possible d'un compte désactivé, avec un nouveau mot de passe provisoire à changer à la première connexion
- Consultation de l'historique des actions d'un employé, actif ou désactivé : changements de statut, modifications et annulations de commandes avec leur motif, décisions sur les avis ; de la plus récente à la plus ancienne, avec un filtre par période
- Aucune création de compte administrateur possible depuis l'application

#### Statistiques

- Rubrique « Statistiques », accessible uniquement à l'administrateur
- Nombre de commandes par menu, avec un graphique pour comparer les menus entre eux (données issues de la base non relationnelle)
- Graphique en barres accompagné d'un tableau reprenant les mêmes chiffres
- Commandes comptées : toutes, sauf les commandes annulées ; filtre par période
- Calcul du chiffre d'affaires par menu, avec un filtre par menu et un filtre sur une période
- Chiffre d'affaires présenté dans un tableau : prix du menu après réduction, frais de livraison sur une ligne séparée
- Distinction entre chiffre d'affaires réalisé (commandes livrées ou terminées) et prévisionnel (commandes acceptées, pas encore livrées) ; les commandes en attente et annulées ne sont pas comptées
- Totaux mis à jour selon les filtres, sans rechargement de la page ; données issues de la base non relationnelle, comme pour le graphique

## Règles de gestion

Les règles marquées « interprétation » ne figurent pas explicitement dans l'expression du besoin : ce sont des choix
que j'ai faits lorsque l'expression du besoin était incomplète ou ambiguë. Ils sont justifiés dans le tableau
« Choix d'interprétation » en fin de section.

### Menus et plats

- **RG-01** : Un menu possède un thème parmi : Noël, Pâques, classique, événement. Les thèmes sont stockés en base de données : un employé ou l'administrateur peut en ajouter (p. 4 ; ajout : interprétation).
- **RG-02** : Un menu possède un régime parmi : classique, végétarien, vegan, pescétarien, sans gluten, sans lactose. Les régimes sont stockés en base de données : un employé ou l'administrateur peut en ajouter (p. 4 ; ajout autorisé par l'expression du besoin).
- **RG-03** : Un plat est une entrée, un plat principal ou un dessert, et peut appartenir à plusieurs menus (p. 4).
- **RG-04** : Un plat peut posséder une liste d'allergènes, choisis parmi les 14 allergènes à déclaration obligatoire du règlement européen INCO n° 1169/2011, annexe II (p. 4 ; liste réglementaire : interprétation).
- **RG-05** : Le prix d'un menu est défini pour son nombre minimum de personnes (p. 4).
- **RG-06** : Le stock indique le nombre de commandes encore possibles pour un menu. Il diminue de 1 à chaque commande et augmente de 1 à chaque annulation ; à 0, le menu reste affiché comme épuisé mais ne peut plus être commandé. Un employé peut le réapprovisionner (interprétation).
- **RG-29** : Un menu possède un statut : brouillon, publié ou archivé. Seul un menu publié est visible et commandable par les clients. Un menu ne peut être publié qu'avec au moins une photo. Supprimer un menu revient à l'archiver : il est conservé et peut être republié (interprétation).
- **RG-30** : Un menu possède un délai minimum de commande, exprimé en jours : la date de prestation choisie doit respecter ce délai (interprétation).
- **RG-31** : Un menu et un plat peuvent comprendre du matériel prêté, avec sa description. Un menu comprend du matériel prêté si lui-même ou l'un de ses plats en comprend (interprétation).
- **RG-32** : Les photos des menus et des plats sont acceptées aux formats JPEG, PNG et WebP, dans la limite de 20 Mo par fichier envoyé (interprétation).

### Comptes et connexion

- **RG-07** : Le mot de passe contient au moins 10 caractères, dont au moins une majuscule, une minuscule, un chiffre et un caractère spécial (p. 5).
- **RG-08** : L'adresse mail sert d'identifiant et doit être unique (p. 5 ; unicité : interprétation).
- **RG-09** : Un compte créé par inscription reçoit le rôle « utilisateur » (p. 5).
- **RG-10** : Seul l'administrateur peut créer un compte employé, avec une adresse mail et un mot de passe provisoire. Le mot de passe n'est jamais envoyé par mail : l'employé l'obtient auprès de l'administrateur (p. 9). Le mot de passe provisoire est généré aléatoirement et respecte RG-07 (interprétation).
- **RG-10 bis** : À sa première connexion, l'employé doit remplacer le mot de passe provisoire par un mot de passe personnel, différent du mot de passe provisoire (interprétation).
- **RG-11** : Un compte employé désactivé ne peut plus se connecter (p. 9). La désactivation ferme immédiatement ses sessions ouvertes ; un compte réactivé reçoit un nouveau mot de passe provisoire (interprétation).
- **RG-12** : Il existe un seul compte administrateur, créé par le développeur ; aucun compte administrateur ne peut être créé depuis l'application (p. 9).
- **RG-33** : Un compte créé par inscription n'est activé qu'après confirmation de l'adresse mail. Le lien de confirmation est à usage unique et à durée limitée (interprétation).
- **RG-34** : Le lien de réinitialisation du mot de passe est valable 1 heure et ne peut être utilisé qu'une seule fois (interprétation).

### Calcul du prix d'une commande

- **RG-13** : Le nombre de personnes doit être supérieur ou égal au nombre minimum du menu (p. 7).
- **RG-14** : Le prix du menu est proportionnel au nombre de personnes : (prix du menu ÷ nombre minimum) × nombre de personnes (interprétation).
- **RG-15** : Une réduction de 10 % s'applique sur le prix du menu dès que le nombre de personnes atteint le minimum + 5 (p. 7 ; « dès que » : interprétation).
- **RG-16** : Livraison dans la ville de Bordeaux : gratuite. Hors de Bordeaux : 5 € + 0,59 € par kilomètre, calculés depuis l'adresse de l'entreprise (p. 7 ; point de départ : interprétation). « Dans Bordeaux » désigne la commune de Bordeaux ; la distance est celle du trajet aller par la route, calculée automatiquement. Si l'adresse est introuvable ou la distance incalculable, la commande ne peut pas être validée (interprétation).
- **RG-17** : La réduction ne s'applique pas aux frais de livraison (interprétation).
- **RG-18** : Prix total = prix du menu après réduction + frais de livraison. Le détail est affiché avant validation (p. 7).
- **RG-35** : À la validation d'une commande, son prix (menu, réduction, livraison, total), la composition du menu, les allergènes et le matériel prêté sont figés. Une modification ultérieure du menu ou d'un plat ne change pas les commandes existantes ; seule une modification de la commande elle-même recalcule son prix (interprétation).

### Statuts d'une commande

- **RG-19** : Une commande passée reçoit le statut « en attente » (interprétation).
- **RG-20** : Ordre des statuts : en attente → accepté → en préparation → en cours de livraison → livré → (en attente du retour de matériel) → terminée (p. 8). Seul le statut suivant est autorisé : après « livré », la commande passe « en attente du retour de matériel » si elle comprend du matériel prêté (RG-31), « terminée » sinon (interprétation).
- **RG-21** : Chaque changement de statut est enregistré avec sa date et son heure (p. 7), ainsi que l'employé qui l'a effectué (interprétation).
- **RG-22** : L'utilisateur peut modifier ou annuler sa commande uniquement au statut « en attente ». Le menu choisi n'est pas modifiable (p. 7).
- **RG-23** : Un employé ne peut modifier ou annuler une commande qu'après avoir contacté le client ; le mode de contact (GSM ou mail) et le motif sont obligatoires (p. 8). C'est possible tant que la commande n'est pas « en cours de livraison ». L'accord du client est obligatoire pour une modification, mais pas pour une annulation. Chaque contact est enregistré avec son mode, sa date, son heure et l'employé (interprétation).
- **RG-24** : Au statut « en attente du retour de matériel », un mail informe le client qu'il dispose de 10 jours ouvrés pour restituer le matériel, sous peine de 600 € de frais prévus par les CGV (p. 8).
- **RG-25** : Une commande est « terminée » quand elle a été livrée sans prêt de matériel, ou quand le matériel a été restitué. Un mail invite alors l'utilisateur à donner son avis (p. 7-8).
- **RG-36** : Une commande annulée, par le client (RG-22) ou par un employé (RG-23), passe au statut « annulée ». Ce statut est en dehors de l'ordre de RG-20 et ne peut pas être choisi comme un changement de statut ordinaire (interprétation).

### Avis

- **RG-26** : Un avis ne peut être donné que sur une commande terminée, et une seule fois par commande (p. 7 ; « une seule fois » : interprétation).
- **RG-27** : Un avis comprend une note entière de 1 à 5 et un commentaire (p. 7).
- **RG-28** : Un avis est en attente jusqu'à sa validation ou son refus par un employé ; seuls les avis validés sont affichés (p. 8). Un refus exige un motif, communiqué au client par mail. Un avis validé peut être retiré, avec un motif obligatoire : il repasse alors en « refusé ». La note n'est pas montrée à l'employé qui modère (interprétation).
- **RG-37** : Un avis publié affiche sa note, son commentaire et le menu concerné, sans le nom du client ; si le menu est archivé, la mention « menu plus proposé » l'accompagne (interprétation).

### Horaires

- **RG-38** : Pour chaque jour de la semaine, les horaires d'ouverture comportent une plage horaire, avec une deuxième plage facultative, ou la mention « Fermé ». L'heure de fermeture d'une plage est postérieure à son heure d'ouverture, et deux plages d'un même jour ne se chevauchent pas (interprétation).

### Statistiques

- **RG-39** : Le nombre de commandes par menu compte toutes les commandes, sauf les commandes annulées (interprétation).
- **RG-40** : Le chiffre d'affaires d'un menu correspond au prix du menu après réduction ; les frais de livraison sont comptés à part. Il est **réalisé** pour les commandes livrées ou terminées, et **prévisionnel** pour les commandes acceptées pas encore livrées ; les commandes en attente et annulées ne sont pas comptées (interprétation).

### Choix d'interprétation

| Règle                          | Ambiguïté de l'expression du besoin                                                                                    | Choix retenu et justification                                                                                                                                                                                                           |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| RG-01                          | Les thèmes sont listés, sans indiquer s'ils peuvent évoluer                                                            | Thèmes stockés en base de données et extensibles, comme les régimes : une liste fermée évite les doublons (« Noël » / « Noel ») qui casseraient le filtre                                                                               |
| RG-02                          | L'expression du besoin cite trois régimes et autorise à en ajouter                                                     | Ajout de pescétarien, sans gluten et sans lactose, régimes courants en restauration. Régimes stockés en base de données pour que l'équipe puisse en ajouter sans modifier le code                                                       |
| RG-04                          | La liste des allergènes n'est pas précisée                                                                             | Les 14 allergènes à déclaration obligatoire du règlement INCO : c'est la liste que l'entreprise doit déjà déclarer                                                                                                                      |
| RG-06                          | Le fonctionnement du stock n'est pas détaillé                                                                          | Une commande consomme une unité : c'est le sens de « il reste 5 commandes possibles ». Une annulation la rend. Un menu épuisé reste affiché pour que le client sache qu'il existe                                                       |
| RG-08                          | L'unicité du mail n'est pas mentionnée                                                                                 | Le mail sert d'identifiant, donc deux comptes ne peuvent pas partager le même                                                                                                                                                           |
| RG-10                          | Le mode de création du mot de passe provisoire n'est pas précisé                                                       | Mot de passe généré aléatoirement : l'administrateur n'a pas à en inventer un, et il respecte forcément RG-07                                                                                                                           |
| RG-10 bis                      | L'administrateur connaît le mot de passe de l'employé                                                                  | Changement obligatoire à la première connexion : l'exigence du client est respectée, et seul l'employé connaît son mot de passe définitif                                                                                               |
| RG-11                          | Les effets de la désactivation ne sont pas détaillés                                                                   | Sessions fermées immédiatement, sinon un employé déjà connecté garderait l'accès. Réactivation possible avec un nouveau mot de passe provisoire, en cas de retour de l'employé                                                          |
| RG-14                          | Le calcul du prix selon le nombre de personnes n'est pas précisé                                                       | Un prix proportionnel est le plus simple à comprendre pour le client                                                                                                                                                                    |
| RG-15                          | « 5 personnes de plus » peut se lire « exactement » ou « au moins »                                                    | « Au moins » : une remise qui disparaîtrait à 6 personnes de plus n'aurait pas de sens                                                                                                                                                  |
| RG-16                          | Le point de départ du kilométrage n'est pas indiqué ; « dans la ville de Bordeaux » et la distance ne sont pas définis | L'adresse de l'entreprise, d'où partent les livraisons ; la commune de Bordeaux, limite administrative vérifiable ; la distance aller par la route, calculée automatiquement pour éviter les erreurs de saisie                          |
| RG-17                          | Le périmètre de la réduction n'est pas précisé                                                                         | L'expression du besoin lie la réduction au nombre de personnes, donc au prix du menu seulement                                                                                                                                          |
| RG-19                          | Aucun statut n'est nommé avant « accepté »                                                                             | « En attente » désigne une commande reçue mais pas encore validée par l'équipe                                                                                                                                                          |
| RG-20                          | Les retours en arrière et les sauts de statut ne sont pas évoqués                                                      | Seul le statut suivant est autorisé : le suivi reste cohérent pour le client                                                                                                                                                            |
| RG-21                          | L'auteur d'un changement de statut n'est pas demandé                                                                   | L'employé est enregistré, pour savoir qui a fait quoi en cas de problème                                                                                                                                                                |
| RG-23                          | Le moment limite et l'accord du client ne sont pas précisés                                                            | Jusqu'à « en cours de livraison » : après le départ de la livraison, il est trop tard. Accord exigé pour modifier (le client doit accepter ce qu'il paiera), pas pour annuler (l'entreprise peut ne plus pouvoir assurer la prestation) |
| RG-26                          | Le nombre d'avis par commande n'est pas limité                                                                         | Un avis par commande évite les doublons et reste fidèle à « depuis la commande »                                                                                                                                                        |
| RG-28                          | Les suites d'un refus ne sont pas précisées                                                                            | Motif obligatoire et mail au client, pour la transparence. Note masquée à l'employé, pour que la décision porte sur le contenu du commentaire et non sur la note (éviter de ne refuser que les mauvaises notes)                         |
| RG-29                          | La suppression d'un menu n'est pas détaillée                                                                           | Un brouillon permet de préparer un menu avant de le montrer. Supprimer = archiver, pour conserver les commandes, les avis et les statistiques liés au menu                                                                              |
| RG-30                          | Aucun délai de commande n'est mentionné                                                                                | Un délai par menu laisse à l'équipe le temps de préparer la prestation                                                                                                                                                                  |
| RG-31                          | Le matériel prêté n'est rattaché à aucun élément                                                                       | Rattaché au menu et au plat, pour savoir automatiquement, après « livré », si la commande passe « en attente du retour de matériel »                                                                                                    |
| RG-32                          | Les formats et la taille des photos ne sont pas précisés                                                               | Formats d'image courants sur le web ; 20 Mo pour accepter les photos d'appareils professionnels, redimensionnées ensuite pour l'affichage                                                                                               |
| RG-33                          | La vérification de l'adresse mail n'est pas mentionnée                                                                 | Confirmation par lien : l'adresse appartient bien à la personne qui crée le compte                                                                                                                                                      |
| RG-34                          | La durée de validité du lien de réinitialisation n'est pas précisée                                                    | Une durée courte et un usage unique limitent le risque si le mail est lu par quelqu'un d'autre                                                                                                                                          |
| RG-35                          | L'effet d'une modification de menu sur les commandes passées n'est pas évoqué                                          | Le client paie et reçoit ce qu'il a validé ; une modification ultérieure ne le concerne pas                                                                                                                                             |
| RG-36                          | Aucun statut n'est nommé pour une commande annulée                                                                     | Statut « annulée » : la commande reste consultable avec son motif, au lieu d'être effacée                                                                                                                                               |
| RG-37                          | Le contenu affiché d'un avis n'est pas précisé                                                                         | Nom du client masqué (minimisation des données, RGPD) ; menu indiqué pour donner du sens à l'avis                                                                                                                                       |
| RG-38                          | Le format des horaires n'est pas précisé                                                                               | Deux plages par jour pour gérer les journées coupées, ou « Fermé »                                                                                                                                                                      |
| RG-39                          | Les commandes comptées ne sont pas précisées                                                                           | Les annulées sont exclues : elles ne reflètent pas la popularité réelle d'un menu                                                                                                                                                       |
| RG-40                          | Le calcul du chiffre d'affaires n'est pas précisé                                                                      | Livraison à part, car elle ne dépend pas du menu ; réalisé et prévisionnel distingués pour ne pas compter de l'argent pas encore gagné                                                                                                  |
| Filtre « nombre de personnes » | Le filtre peut se lire « minimum égal à » ou « menus possibles pour ce nombre »                                        | Menus dont le minimum est inférieur ou égal au nombre saisi : le visiteur saisit son nombre de convives et voit les menus qu'il peut commander                                                                                          |

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

## User stories

Les spécifications fonctionnelles ci-dessus ont été traduites en user stories, au format « En tant que… je veux… afin de… ».
Chaque user story est une carte du tableau GitHub Projects ([Vite & Gourmand - ECF](https://github.com/users/NicolasMiguelRG/projects/2)), qui contient ses critères d'acceptation, ses dépendances et les règles de gestion concernées.
**Les cartes font référence** : le tableau ci-dessous n'en est qu'un récapitulatif.

| Carte | Espace         | User story                                                                                  | Priorité | Taille |
| ----- | -------------- | ------------------------------------------------------------------------------------------- | -------- | ------ |
| #25   | Public         | Découvrir l'entreprise et son équipe                                                        | P0       | S      |
| #26   | Public         | Consulter les avis des clients                                                              | P0       | S      |
| #27   | Public         | Consulter l'ensemble des menus                                                              | P0       | S      |
| #28   | Public         | Filtrer les menus                                                                           | P0       | M      |
| #29   | Public         | Consulter le détail d'un menu                                                               | P0       | M      |
| #30   | Public         | Créer un compte                                                                             | P0       | M      |
| #31   | Public         | Confirmer son adresse mail                                                                  | P1       | S      |
| #32   | Public         | Se connecter                                                                                | P0       | M      |
| #33   | Public         | Réinitialiser son mot de passe                                                              | P0       | M      |
| #34   | Public         | Contacter l'entreprise                                                                      | P0       | S      |
| #35   | Public         | Connaître les horaires d'ouverture                                                          | P0       | S      |
| #36   | Public         | Consulter les mentions légales et les CGV                                                   | P0       | S      |
| #37   | Utilisateur    | Modifier ses informations personnelles                                                      | P0       | M      |
| #38   | Utilisateur    | Commander un menu                                                                           | P0       | M      |
| #39   | Utilisateur    | Bénéficier de la réduction de groupe                                                        | P0       | S      |
| #40   | Utilisateur    | Connaître le détail du prix avant validation                                                | P0       | M      |
| #41   | Utilisateur    | Consulter ses commandes                                                                     | P0       | S      |
| #42   | Utilisateur    | Modifier sa commande avant acceptation                                                      | P0       | M      |
| #43   | Utilisateur    | Annuler sa commande avant acceptation                                                       | P0       | S      |
| #44   | Utilisateur    | Suivre sa commande                                                                          | P0       | S      |
| #45   | Utilisateur    | Donner un avis sur une commande terminée                                                    | P0       | S      |
| #46   | Employé        | Remplacer son mot de passe provisoire                                                       | P1       | S      |
| #47   | Employé        | Créer un menu                                                                               | P0       | M      |
| #48   | Employé        | Modifier un menu                                                                            | P0       | M      |
| #49   | Employé        | Supprimer (archiver) un menu                                                                | P0       | S      |
| #50   | Employé        | Gérer la galerie d'images d'un menu                                                         | P0       | M      |
| #51   | Employé        | Gérer les plats et leurs allergènes                                                         | P0       | M      |
| #52   | Employé        | Modifier les horaires d'ouverture                                                           | P0       | S      |
| #53   | Employé        | Consulter les commandes des clients                                                         | P0       | S      |
| #54   | Employé        | Filtrer les commandes                                                                       | P0       | S      |
| #55   | Employé        | Faire évoluer le statut d'une commande                                                      | P0       | M      |
| #56   | Employé        | Être prévenu par mail du retour de matériel et de la fin de commande (acteur : utilisateur) | P0       | S      |
| #57   | Employé        | Modifier la commande d'un client après contact                                              | P0       | M      |
| #58   | Employé        | Annuler la commande d'un client après contact                                               | P0       | S      |
| #59   | Employé        | Valider ou refuser les avis des clients                                                     | P0       | S      |
| #64   | Employé        | Ajouter un régime alimentaire ou un thème                                                   | P2       | S      |
| #60   | Administrateur | Créer un compte employé                                                                     | P0       | M      |
| #61   | Administrateur | Désactiver un compte employé                                                                | P0       | S      |
| #62   | Administrateur | Comparer le nombre de commandes par menu                                                    | P0       | M      |
| #63   | Administrateur | Consulter le chiffre d'affaires par menu                                                    | P0       | M      |
| #65   | Administrateur | Consulter l'historique des actions d'un employé                                             | P2       | S      |

**Priorités** : P0 = exigence explicite de l'expression du besoin ; P1 = interprétation qui renforce la sécurité ; P2 = amélioration facultative.
**Tailles** : S = moins de 2 h ; M = une demi-journée.
