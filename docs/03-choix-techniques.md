# Choix techniques

## Réflexions initiales

L'expression du besoin n'impose qu'une seule contrainte technique : utiliser **une base de données relationnelle et une base de données non relationnelle** (p. 10). Le reste de la stack est libre, mais chaque choix doit être justifié (p. 11).

J'ai fait ces choix comme pour un vrai client, à partir des critères suivants :

- **Proportionnalité** : la solution la plus simple qui couvre le besoin réel de Vite & Gourmand, un traiteur bordelais au volume de commandes modéré.
- **Évolution sans réécriture** : si l'activité grandit, on passe à une offre ou à une configuration supérieure, sans modifier le code.
- **Maintenance** : des versions maintenues longtemps (LTS, *Long Term Support*), pour que l'application reste sécurisée après sa livraison.
- **Données en France** : des prestataires français dès que possible, pour simplifier la conformité au RGPD.
- **Maîtrise** : des technologies que je sais expliquer et maintenir seul dans le délai du projet. Une seule nouveauté est assumée : Stimulus (voir [Front-end](#front-end)).
- **Coût** : faible et prévisible.

Les versions, les durées de maintenance et les prix cités dans ce document ont été vérifiés en novembre 2026.

### Récapitulatif

| Élément | Choix |
|---|---|
| Back-end | Symfony 7.4 LTS, PHP 8.4 |
| Front-end | HTML : Twig · CSS : Bootstrap 5.3 et une feuille de style personnelle (charte graphique) · JavaScript : Symfony UX (Stimulus) |
| Base de données relationnelle | MariaDB 11.8 LTS |
| Base de données non relationnelle | MongoDB (MongoDB Atlas) |
| Adresses et distances | API de la Géoplateforme de l'IGN |
| Envoi de mails | Symfony Mailer : Mailpit en développement, Brevo en préproduction et en production |
| Génération de PDF | Dompdf |
| Hébergement | alwaysdata (préproduction et production) |
| Déploiement | Pipeline GitHub Actions |

## Front-end

Les pages sont générées par le serveur avec **Twig**, le moteur de templates de Symfony. Le JavaScript n'intervient que pour les parties dynamiques demandées par l'expression du besoin : la mise à jour de la liste des menus selon les filtres « sans rechargement de page » (p. 5), le calcul du prix pendant la saisie d'une commande et les statistiques de l'administrateur.

### Twig et Symfony UX (Stimulus)

Le JavaScript est organisé avec **Stimulus**, la bibliothèque de Symfony UX : chaque comportement dynamique est un petit contrôleur JavaScript relié au HTML par des attributs `data-`. J'écris moi-même ces contrôleurs (écouteurs d'évènements, appels au serveur avec `fetch`) ; Stimulus les organise.

J'ai fait ce choix pour deux raisons :
- **approfondir Stimulus**, que je n'avais jamais utilisé : c'est la seule nouveauté technique que je m'autorise dans ce projet ;
- **gagner du temps grâce aux composants Symfony UX prêts à l'emploi** qui correspondent à trois user stories :
  - **UX Chart.js** pour le graphique du nombre de commandes par menu (story 37) ;
  - **UX Autocomplete** pour choisir les plats d'un menu pendant la saisie (stories 22 et 23) ;
  - **UX Dropzone** pour l'envoi des photos de la galerie (story 25).

### Bootstrap 5.3

Le style repose sur **Bootstrap 5.3**, la version stable actuelle (la version 6 n'existe qu'en alpha et n'est pas prête pour la production), complété par une feuille de style personnelle qui applique la charte graphique (couleurs, police).

Bootstrap fournit :
- une **grille responsive**, indispensable puisque toutes les pages doivent fonctionner sur ordinateur et sur mobile ;
- des **composants prêts à l'emploi** : barre de navigation repliable sur mobile, fenêtres de confirmation (archiver un menu, désactiver un compte), carrousel pour la galerie d'un menu, mise en forme des formulaires et de leurs erreurs ;
- une **base accessible** (RGAA) : composants utilisables au clavier, attributs ARIA.

Les animations sont réalisées en CSS (`transition`, `@keyframes`) ou avec les composants Bootstrap, en respectant le réglage `prefers-reduced-motion` des visiteurs qui préfèrent limiter les animations.

### Alternatives écartées

| Alternative | Raison |
|---|---|
| Twig + JavaScript sans bibliothèque | Solution solide, mais le graphique, l'autocomplétion et l'envoi de photos auraient été à développer entièrement, et le code JavaScript plus difficile à organiser. |
| React ou Vue (application séparée) + Symfony en API | Jamais pratiqués : apprendre un framework JavaScript en plus du reste était trop risqué dans le délai du projet. Une application séparée ajoute aussi une API complète à concevoir et à sécuriser, sans bénéfice pour un site de cette taille. |
| Tailwind CSS | Nouvelle façon d'écrire le style (classes utilitaires dans le HTML) et étape de compilation supplémentaire, sans avantage décisif ici. |
| CSS entièrement écrit à la main | Contrôle total, mais le responsive, les composants interactifs et l'accessibilité seraient entièrement à ma charge. |

## Back-end

### Symfony 7.4 LTS

Le back-end est développé en PHP avec le framework **Symfony**, en version **7.4 LTS**. C'est le framework que j'ai le plus pratiqué en formation, et il apporte trois choses dont le projet a besoin.

**Une organisation imposée.** Symfony suit l'architecture MVC : les contrôleurs dans `src/Controller`, les entités dans `src/Entity`, les vues dans `templates/`. Le MakerBundle génère les fichiers de base (`make:entity`, `make:controller`), que je complète ensuite. N'importe quel développeur Symfony peut reprendre le projet.

**Un accès aux données par objets.** L'ORM Doctrine permet de manipuler des objets PHP (`Menu`, `Commande`) plutôt que d'écrire chaque requête à la main ; il les traduit en requêtes SQL préparées. C'est un gain de code, pas de sécurité : PDO permet aussi les requêtes préparées en PHP natif. La place du SQL écrit à la main est expliquée dans la section [Base de données relationnelle](#base-de-données-relationnelle).

**Des protections de sécurité intégrées**, qui couvrent une grande partie des risques relevés pendant l'analyse :
- jeton CSRF sur les formulaires ;
- hachage des mots de passe ;
- régénération de l'identifiant de session à la connexion (contre la fixation de session) ;
- contrôle d'accès par rôle, et *voters* pour vérifier qu'un utilisateur n'accède qu'à ses propres commandes ;
- limitation des tentatives de connexion ;
- échappement automatique des données affichées par Twig (contre le XSS) ;
- validation des formulaires, dont la règle de mot de passe de l'expression du besoin (p. 5).

Le framework ne connaît pas les règles de gestion pour autant. Restent à ma charge : le recalcul du prix par le serveur, les changements de statut autorisés, les messages identiques contre l'énumération de comptes et le contrôle des fichiers envoyés. Les mécanismes de sécurité sont détaillés dans `06-securite.md`.

### Version

| Version | Maintenance | Décision |
|---|---|---|
| **7.4 LTS** | Corrections jusqu'en novembre 2028, sécurité jusqu'en novembre 2029 | **Retenue** |
| 8.1 | Fin de maintenance le 31 janvier 2027, avant la fin du projet | Écartée |
| 8.2 | Sortie en novembre 2026, maintenue jusqu'en juillet 2027 | Écartée |

Une version LTS reste maintenue bien après la livraison au client. Symfony 7.4 demande au minimum PHP 8.2 ; l'application tourne en **PHP 8.4**, la version proposée par l'hébergeur.

### Alternatives écartées

| Alternative | Raison |
|---|---|
| PHP natif avec PDO (stack donnée en exemple) | Chaque ligne serait maîtrisée, mais tout serait à construire : routage, organisation du code, authentification, jetons CSRF, validation, limitation des tentatives, envoi de mails, échappement manuel de chaque donnée affichée. Avec 44 cas d'utilisation et un travail surtout le week-end, cela représentait plusieurs semaines de plus et un risque réel de faille par oubli d'un contrôle. |
| Node.js | Un seul langage côté navigateur et côté serveur, mais je ne l'ai pratiqué que très brièvement : l'apprendre dans le délai du projet était trop risqué. |

## Base de données relationnelle

### MariaDB 11.8 LTS

La base de données relationnelle est **MariaDB**, en version **11.8 LTS**.

J'avais d'abord choisi **MySQL**, que j'ai pratiqué en formation (phpMyAdmin, ligne de commande, Doctrine). L'hébergeur retenu, alwaysdata, ne propose que MariaDB sur son offre mutualisée : MySQL n'y est disponible que sur les serveurs privés virtuels et dédiés. Le passage à MariaDB est donc **un choix dicté par l'hébergeur** (voir [Hébergement et environnements](#hébergement-et-environnements)).

Ce changement est sans conséquence pour le projet :
- MariaDB est issu de MySQL et utilise la même syntaxe pour tout ce dont le projet a besoin : création des tables, insertions, jointures, transactions ;
- Doctrine gère MariaDB comme MySQL ;
- les montants sont stockés en `DECIMAL(10,2)`, un type exact, et non en `FLOAT`, un type approché qui provoquerait des erreurs d'arrondi sur les prix ;
- le moteur InnoDB, utilisé par défaut, gère les transactions dont la commande a besoin (enregistrement en une seule opération, voir le diagramme de séquence dans `05-conception.md`).

**Pourquoi la version 11.8 :** c'est la version LTS la plus récente proposée par l'hébergeur. Elle est maintenue jusqu'en juin 2028, bien au-delà de la livraison. La même version est utilisée en local, en préproduction et en production, pour que ce qui fonctionne sur mon poste fonctionne à l'identique en ligne.

### Doctrine et SQL écrit à la main

L'expression du besoin demande un fichier SQL de création de la base et d'intégration des données, et précise que l'utilisation de fixtures ou de migrations ne prouve pas la maîtrise du SQL (p. 11). J'ai donc organisé le travail ainsi :

- **la structure de la base est écrite à la main en SQL** (`CREATE TABLE`, clés, contraintes), à partir du modèle conceptuel de données. Ce fichier est la référence ;
- **les entités Doctrine décrivent ces tables**, sans migrations Doctrine pour créer la base : il n'y a ainsi qu'une seule source de vérité. La commande `doctrine:schema:validate` vérifie que les entités correspondent bien aux tables ;
- **les données de départ sont insérées par un fichier SQL écrit à la main** : thèmes et régimes, quatorze allergènes, horaires, compte administrateur, menus de démonstration (dont les identifiants servent au manuel d'utilisation) ;
- **certaines requêtes sont écrites en SQL**, avec des paramètres (requêtes préparées), là où le SQL a du sens : par exemple le filtrage des menus ou l'historique des actions d'un employé.

### Alternatives écartées

| Alternative | Raison |
|---|---|
| MySQL 8.4 LTS ou 9.7 LTS | Mon premier choix, mais non proposé par l'hébergeur retenu. Le garder aurait imposé un hébergeur deux fois plus cher ou un serveur à administrer moi-même. |
| MariaDB 11.4 LTS | Maintenue plus longtemps (mai 2029), mais plus ancienne : la 11.8 est la dernière LTS proposée par l'hébergeur et évite une migration ultérieure. |
| PostgreSQL | Plus strict et plus riche en fonctionnalités avancées, inutiles pour ce projet. Je ne l'ai pratiqué que très brièvement, alors que je maîtrise mieux MySQL, dont MariaDB est issu. |

## Base de données non relationnelle

### MongoDB

La base de données non relationnelle est **MongoDB**, une base orientée documents. Elle sert uniquement aux statistiques de l'administrateur : nombre de commandes par menu et chiffre d'affaires (stories 37 et 38).

Ce type de base correspond aux données retenues lors de la conception : **un document par commande**, qui contient déjà tout ce qu'une statistique affiche (menu, date de prestation, statut, montants). Les calculs se font sans jointure, avec les agrégations de MongoDB (compter, additionner, filtrer par menu et par période). La base relationnelle reste la seule source de vérité ; la base non relationnelle n'en est qu'une copie destinée à la lecture, sans aucune donnée personnelle. Le détail des données stockées et leur justification se trouvent dans [`05-conception.md`](05-conception.md#données-de-la-base-non-relationnelle).

### Accès depuis Symfony : la bibliothèque officielle

L'application accède à MongoDB avec la **bibliothèque PHP officielle** (`mongodb/mongodb`), et non avec Doctrine MongoDB ODM, l'équivalent de l'ORM pour MongoDB. J'écris ainsi moi-même les requêtes et les agrégations, comme pour le SQL de la base relationnelle.

Cette bibliothèque s'appuie sur l'extension PHP `mongodb`, qui doit être installée sur le serveur. Je l'ai compilée et testée chez l'hébergeur avant de valider ce choix : elle fonctionne avec PHP 8.4.

### Hébergement : MongoDB Atlas

En préproduction et en production, la base est hébergée sur **MongoDB Atlas**, le service en ligne de MongoDB, avec son offre gratuite (512 Mo), largement suffisante pour des documents de statistiques. En local, MongoDB tourne dans un conteneur Docker.

MongoDB est une société américaine, ce qui fait exception à mon critère de prestataires français. Ce choix reste acceptable pour deux raisons :
- **aucune donnée personnelle** n'est copiée dans cette base (ni nom, ni adresse, ni coordonnées) ;
- le cluster est créé dans une **région européenne**.

L'offre gratuite ne comprend ni sauvegarde ni garantie de disponibilité. Ce n'est pas bloquant : les documents sont une copie et peuvent être reconstitués à tout moment depuis la base relationnelle. Si le besoin grandit, il suffira de passer à une offre payante d'Atlas, sans changer le code.

### Alternatives écartées

| Alternative | Raison |
|---|---|
| Doctrine MongoDB ODM | Plus rapide à mettre en place, mais masque les requêtes. Je préfère écrire les agrégations moi-même pour maîtriser l'accès aux données. |
| Redis | Base clé-valeur en mémoire, faite pour le cache et les compteurs : mal adaptée aux filtres par menu et par période. |
| CouchDB | Également orientée documents, mais peu répandue et peu documentée avec Symfony. |
| Firestore (Google) | Dépendance à Google Cloud et peu utilisé avec PHP. |
| Module MongoDB d'un hébergeur | Celui étudié (Clever Cloud) proposait une version ancienne de MongoDB (4.0) ; Atlas fournit une version à jour. |

## Services externes

### Adresses et frais de livraison : la Géoplateforme de l'IGN

Le calcul des frais de livraison (RG-16) a besoin de deux informations : savoir si l'adresse se trouve dans la commune de Bordeaux (livraison gratuite), et sinon connaître la distance par la route depuis l'entreprise. J'utilise pour cela les **API de la Géoplateforme de l'IGN**, l'Institut national de l'information géographique et forestière :

| Service | Rôle dans l'application |
|---|---|
| **Géocodage** | Transforme l'adresse saisie en coordonnées et renvoie le **code INSEE de la commune** (`citycode`). La livraison est gratuite si ce code vaut `33063` (Bordeaux). Si l'adresse est introuvable ou trop imprécise, l'utilisateur est invité à la corriger. |
| **Calcul d'itinéraire** | Donne la distance par la route entre l'entreprise et l'adresse de livraison. Il n'est appelé que pour les adresses hors de Bordeaux. |
| **Autocomplétion** | Propose de vraies adresses pendant la saisie (inscription, informations personnelles, commande), ce qui limite les erreurs de frappe. |

**Pourquoi le code INSEE plutôt que le champ « ville » :** le nom de ville saisi peut être faux ou falsifié pour obtenir la livraison gratuite. Le code INSEE renvoyé par le géocodage est unique et ne dépend pas de ce que l'utilisateur a tapé.

**Le serveur reste maître du calcul :** même si l'autocomplétion est appelée depuis le navigateur, le serveur géocode à nouveau l'adresse et recalcule les frais à la validation de la commande, car une requête peut être envoyée sans passer par le formulaire (voir le diagramme de séquence dans `05-conception.md`).

**Pourquoi ce service :**
- c'est un **service public français** : l'adresse des clients n'est pas envoyée hors de l'Union européenne ;
- il est **gratuit** et ne demande **aucune clé**, donc aucun secret à protéger ;
- ses limites (50 requêtes par seconde pour le géocodage, 5 pour l'itinéraire) sont largement suffisantes pour un traiteur.

L'ancienne « API Adresse » (`api-adresse.data.gouv.fr`), encore citée dans de nombreux tutoriels, a été transférée à l'IGN et fermée fin janvier 2026.

| Alternative | Raison |
|---|---|
| Google Maps | Très fiable, mais clé et compte de facturation obligatoires, et adresses des clients envoyées hors de l'Union européenne. |
| OpenRouteService | Gratuit, mais clé obligatoire et quota d'utilisation. |

### Envoi de mails : Symfony Mailer

Les mails (bienvenue, réinitialisation du mot de passe, confirmation de commande, etc.) sont envoyés avec le composant **Mailer** de Symfony. Le service d'envoi se choisit dans une variable d'environnement, sans changer le code :

| Environnement | Service | Raison |
|---|---|---|
| Local | **Mailpit** | Fausse boîte de réception qui intercepte et affiche tous les mails : aucun ne part réellement, on peut tester avec de fausses adresses. |
| Préproduction et production | **Brevo** | Société française, offre gratuite de 300 mails par jour, envoi par SMTP ou par API. La préproduction utilise le même service que la production pour tester dans les conditions réelles. |

**Dimensionnement :** une commande génère en général deux mails (confirmation, puis fin de commande), jusqu'à quatre ou cinq si elle est modifiée ou annulée. Avec les inscriptions et les autres envois, 300 mails par jour couvrent plusieurs dizaines de commandes par jour, bien au-delà de l'activité d'un traiteur. Si le besoin grandit, il suffit de passer au premier forfait payant de Brevo, sans modifier le code. Un mail qui ne part pas n'annule jamais une commande : l'erreur est enregistrée dans le journal des erreurs.

| Alternative | Raison |
|---|---|
| Mailjet | Offre gratuite plus limitée (200 mails par jour). |
| Gmail en SMTP | Pas conçu pour un site web : risque élevé de classement en indésirables. |

## Génération de PDF

### Dompdf

Le bon de livraison (story 41, carte #68) est généré en PDF avec **Dompdf**, une bibliothèque PHP installée avec Composer.

Le fonctionnement est simple : le contrôleur fabrique le HTML du bon avec un template Twig, Dompdf le transforme en PDF, et le navigateur l'ouvre dans son lecteur PDF. L'employé n'a plus qu'à l'imprimer pour le livreur. Un site web ne peut pas envoyer un document directement à l'imprimante : le navigateur ouvre toujours sa fenêtre d'impression, pour des raisons de sécurité.

**Pourquoi Dompdf :** c'est un outil proportionné au besoin. Le bon de livraison ne contient que quelques informations (numéro de commande, nom et prénom du client, GSM, adresse et heure de livraison) : un tableau suffit. Dompdf s'installe comme une simple dépendance et tourne dans l'application, sans aucun service supplémentaire à héberger.

**Ses limites, connues et acceptées :** Dompdf n'est pas un navigateur. Il gère la plupart du CSS 2.1 et quelques propriétés plus récentes, mais pas les mises en page en flexbox ou en grille, ni le JavaScript. Le template du bon n'utilise donc pas Bootstrap, mais une feuille de style simple (tableau, marges, largeurs fixes). La police de la charte graphique peut être déclarée avec `@font-face`.

Côté sécurité, Dompdf est configuré pour ne charger aucune ressource externe (images ou feuilles de style hébergées ailleurs), et la dépendance est tenue à jour.

### Alternatives écartées

| Alternative | Raison |
|---|---|
| Gotenberg | Utilise un vrai navigateur (Chromium) dans un conteneur Docker : rendu identique à l'écran, Bootstrap compris. Mais c'est un service lourd de plus à héberger en local, en préproduction et en production, pour un document de quelques lignes. C'est l'évolution possible si le client demande un jour des documents plus riches, comme une carte des menus illustrée. |
| KnpSnappyBundle (wkhtmltopdf) | Ancienne solution courante avec Symfony, mais wkhtmltopdf a été abandonné en janvier 2023 et ne reçoit plus de correctifs de sécurité. |
| Page HTML prévue pour l'impression (`@media print`) | La plus simple, mais elle ne produit pas de PDF, alors que la story demande un bon de livraison en PDF. |
## Déploiement