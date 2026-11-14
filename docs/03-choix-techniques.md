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

## Réflexions initiales
## Front-end
## Back-end
## Base de données relationnelle
## Base de données non relationnelle
## Déploiement