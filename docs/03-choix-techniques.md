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
## Base de données non relationnelle
## Déploiement