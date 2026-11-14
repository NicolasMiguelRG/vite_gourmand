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
## Base de données relationnelle
## Base de données non relationnelle
## Déploiement