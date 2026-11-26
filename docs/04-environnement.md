# Environnement de travail

## Poste et système

Je développe sur un ordinateur portable MSI Thin A15, sous Windows 11 Famille (version 26H2).

Le projet a d'abord été installé directement sous Windows, puis je l'ai déplacé dans WSL 2 (WSL 3.0.5), qui fait tourner une distribution Ubuntu 26.04.1 LTS à l'intérieur de Windows. Le dépôt est cloné dans le système de fichiers d'Ubuntu, dans `~/projets/ecf/vite_gourmand`.

### Pourquoi WSL

Sous Windows, chaque page mettait plusieurs secondes à s'afficher. Mon temps disponible pour le projet étant limité, je ne pouvais pas me permettre d'attendre à chaque rechargement. J'ai donc mesuré le temps d'affichage de la page d'accueil (indicateur LCP, panneau Performances du navigateur), avant et après le déplacement dans WSL :

| Chargement | Sous Windows | Dans WSL |
|---|---|---|
| 1er | 5,18 s | 0,08 s |
| 2e | 3,39 s | 0,11 s |
| 3e | 3,38 s | 0,10 s |

Dans WSL, la page s'affiche environ 30 fois plus vite (0,1 s au lieu de 3,4 s).

Cet écart s'explique par l'emplacement des fichiers. PHP tourne dans un conteneur Linux, mais les fichiers du projet se trouvaient sur le disque de Windows : à chaque lecture, ils devaient passer par un mécanisme de partage entre les deux systèmes, qui est lent. Or Symfony lit des centaines de fichiers pour afficher une seule page. Dans WSL, les fichiers sont directement dans le système Linux, au même endroit que les conteneurs : ils sont lus sans intermédiaire.

L'image PHP a été reconstruite au même moment (voir [Conteneurs Docker](#conteneurs-docker)), mais ces changements ne concernent pas l'affichage des pages : l'écart vient bien de l'emplacement des fichiers.

## Outils de développement

### Éditeur : Visual Studio Code

J'utilise Visual Studio Code (version 1.148.0), ouvert directement dans Ubuntu grâce à l'extension **WSL** : l'éditeur s'affiche sous Windows, mais il lit les fichiers, lance le terminal et fait tourner les extensions dans Ubuntu.

J'ai choisi VS Code pour trois raisons :
- j'ai l'habitude de travailler avec cet éditeur et ses extensions ;
- il me permet de tout faire au même endroit : code PHP, gabarits Twig, fichiers de configuration, documentation en Markdown, diagrammes et export PDF ;
- il est gratuit. PhpStorm, plus complet pour PHP, est payant : j'avais une licence étudiante, mais elle a expiré et je n'ai pas jugé utile de la renouveler.

Extensions installées dans WSL :

| Extension | Utilité |
|---|---|
| WSL | Ouvrir le projet dans Ubuntu |
| PHP Intelephense | Complétion et détection des erreurs PHP (réglée sur PHP 8.4.28 dans `.vscode/settings.json`) |
| Twig Language 2 | Coloration des gabarits Twig |
| YAML | Vérification des fichiers de configuration (`compose.yaml`, `config/`) |
| GitLens | Historique et auteur de chaque ligne |
| Container Tools | Suivi des conteneurs Docker |

Les extensions **PlantUML** (diagrammes UML) et **Markdown PDF** (export de la charte graphique) ont été utilisées avant le passage dans WSL. Dans Ubuntu, elles demandent d'installer Java et un navigateur : je les ajouterai quand il faudra régénérer un diagramme ou un PDF.

### Docker Desktop

Docker (version 29.9.3) est installé avec Docker Desktop, dont l'intégration WSL est activée pour Ubuntu : les commandes `docker` se lancent depuis le terminal d'Ubuntu. Le rôle de chaque conteneur est décrit dans la partie [Conteneurs Docker](#conteneurs-docker).

## Gestion de versions

J'utilise **Git** (version 2.53.0, installé dans Ubuntu) et **GitHub** pour héberger le dépôt public [NicolasMiguelRG/vite_gourmand](https://github.com/NicolasMiguelRG/vite_gourmand). L'organisation des branches (`dev` par défaut, `main` protégée), les pull requests et les conventions de commit sont décrites dans [la gestion de projet](01-gestion-projet.md).

### Identifiants GitHub

Git dans Ubuntu utilise le **gestionnaire d'identifiants de Git pour Windows** (Git Credential Manager) : l'accès à GitHub est enregistré de façon chiffrée par Windows, et Ubuntu le réutilise.

Ce réglage remplace l'ancien mode `store`, qui enregistrait un jeton d'accès GitHub en clair dans un fichier de mon dossier personnel. N'importe quel programme lancé avec mon compte pouvait le lire. J'ai supprimé ce fichier et révoqué le jeton sur GitHub.

### Fins de ligne

Le fichier `.gitattributes` impose les fins de ligne Linux (`LF`) à tous les fichiers du dépôt. Le projet a commencé sous Windows, qui utilise un autre format (`CRLF`) : sans cette règle, un même fichier pourrait changer de format selon le système et apparaître comme modifié sans l'être.

### Secrets

Les valeurs sensibles (mots de passe, clé `APP_SECRET`) sont placées dans `.env.local`, ignoré par Git. GitGuardian analyse chaque pull request et signale un secret envoyé par erreur.

## Conteneurs Docker

### Pourquoi Docker

Le site est hébergé chez alwaysdata en **PHP 8.4**, et je voulais exactement la même version en local, pour éviter qu'un code qui fonctionne sur mon poste ne fonctionne pas en ligne.

J'ai d'abord essayé d'installer PHP 8.4 directement sous Windows, mais il était bloqué par le **Contrôle intelligent des applications** de Windows 11 : cette protection refuse les programmes non signés et trop récents pour avoir une réputation. PHP 8.5 démarrait, mais l'extension `mongodb` pour Windows était bloquée à son tour. Plutôt que de désactiver une protection qui sécurise tout mon ordinateur, j'ai placé PHP dans un **conteneur Linux** : j'obtiens la même version et le même système qu'en ligne, sans rien installer sous Windows.

Les bases de données et le serveur de mails sont aussi en conteneurs : tout l'environnement se lance avec une seule commande, et chaque version est écrite dans un fichier versionné.

### Les quatre services

Les services sont décrits dans `compose.yaml`, à la racine du dépôt :

| Service | Image | Rôle | Adresse sur mon poste | En ligne |
|---|---|---|---|---|
| `php` | construite depuis `docker/php/Dockerfile` (PHP 8.4 + Apache) | Exécute Symfony | http://localhost:8080 | PHP 8.4 sur alwaysdata |
| `database` | `mariadb:11.8` | Base de données relationnelle | `127.0.0.1:3306` | MariaDB 11.8 sur alwaysdata |
| `mongodb` | `mongo:8.0` | Base de données non relationnelle | `127.0.0.1:27017` | MongoDB 8.0 sur Atlas |
| `mailer` | `axllent/mailpit` | Reçoit les mails envoyés en local | http://localhost:8025 | Brevo |

Les données des deux bases sont gardées dans des volumes (`db_data`, `mongo_data`) : elles ne sont pas perdues quand un conteneur est arrêté ou recréé.

### L'image PHP

Le fichier `docker/php/Dockerfile` part de l'image officielle `php:8.4-apache` et ajoute :
- les extensions `pdo_mysql` (MariaDB), `mongodb` (MongoDB), `intl`, `zip` et `opcache` ;
- Composer, pour installer les bibliothèques PHP, et `unzip`, qui accélère leur décompression ;
- Apache réglé pour servir uniquement le dossier `public/` : les fichiers `.env`, `src/` ou `config/` ne sont jamais accessibles depuis le navigateur.

J'ai choisi **Apache** parce que c'est le serveur web utilisé par alwaysdata pour les sites PHP.

La version de l'extension `mongodb` est fixée (`mongodb-2.5.9`), car la 2.5.9 corrige une faille de sécurité (CVE-2026-135133). Sans version fixée, la version installée dépendrait du jour où l'image est construite.

### Droits des fichiers

Dans WSL, les droits des fichiers sont réellement appliqués, contrairement au disque Windows. Apache tourne dans le conteneur avec le compte `www-data`. J'ai donné à ce compte le même numéro (1000) que mon compte Ubuntu : Apache peut ainsi lire `.env.local` (lisible par moi seul) et écrire dans `var/`, sans ouvrir ces fichiers à tous les comptes.

### Réglages de sécurité

- Les ports sont liés à `127.0.0.1` : les services ne sont accessibles que depuis mon poste, pas depuis le réseau.
- Les identifiants écrits dans `compose.yaml` ne servent qu'en local, pour des données de démonstration. Les identifiants des serveurs ne sont jamais dans le dépôt.

## Installation en local

Cette procédure installe le projet sur un poste Windows, de la même façon que sur le mien. Le [README](../README.md) en reprend les commandes essentielles.

### Prérequis

- Windows 10 ou 11 avec **WSL 2** et la distribution **Ubuntu** (`wsl --install -d Ubuntu` dans PowerShell) ;
- **Docker Desktop**, avec l'intégration WSL activée pour Ubuntu (*Settings > Resources > WSL integration*) ;
- **Visual Studio Code** avec l'extension **WSL** ;
- **Git** dans Ubuntu, configuré avec un nom et une adresse mail. Pour ne pas enregistrer d'identifiants en clair, utiliser le gestionnaire d'identifiants de Git pour Windows :

```bash
git config --global credential.helper "/mnt/c/Program\ Files/Git/ucrt64/bin/git-credential-manager.exe"
```

Toutes les commandes suivantes se lancent dans le terminal d'Ubuntu.

### 1. Cloner le dépôt dans Ubuntu

Le dépôt doit être cloné dans le système de fichiers d'Ubuntu, et non sur le disque Windows (`/mnt/c/…`), sinon les pages sont très lentes (voir [Pourquoi WSL](#pourquoi-wsl)).

```bash
mkdir -p ~/projets
cd ~/projets
git clone https://github.com/NicolasMiguelRG/vite_gourmand.git
cd vite_gourmand
code .
```

### 2. Créer le fichier `.env.local`

Ce fichier contient les valeurs propres au poste et n'est jamais versionné. Créer `.env.local` à la racine du projet avec ce contenu :

```dotenv
DATABASE_URL="mysql://app:app_local@database:3306/vite_gourmand?serverVersion=11.8.0-MariaDB&charset=utf8mb4"
MONGODB_URL="mongodb://app:app_local@mongodb:27017"
MAILER_DSN="smtp://mailer:1025"
APP_SECRET=
```

Générer une clé pour `APP_SECRET` avec `openssl rand -hex 16`, la coller après le signe `=`, puis réserver le fichier à son propriétaire :

```bash
chmod 600 .env.local
```

### 3. Lancer les conteneurs

```bash
docker compose up -d --build
```

La première fois, la construction de l'image PHP prend quelques minutes. `docker compose ps` doit afficher les quatre services à l'état « Up ».

L'image donne au compte `www-data` le numéro 1000, qui est celui du premier compte créé dans Ubuntu. Vérifier le sien avec `id -u` : s'il est différent, adapter la ligne `groupmod` / `usermod` du `Dockerfile`.

### 4. Installer les bibliothèques PHP

```bash
docker compose exec -u www-data php composer install
```

Les commandes PHP se lancent avec `-u www-data`, pour que les fichiers créés (`vendor/`, `var/`) appartiennent au même compte qu'Apache.

### 5. Vérifier l'installation

| Vérification | Commande ou adresse | Résultat attendu |
|---|---|---|
| Site | http://localhost:8080 | Page d'accueil de Symfony 7.4 |
| MariaDB | `docker compose exec -u www-data php php bin/console dbal:run-sql "SELECT VERSION()"` | `11.8.x-MariaDB` |
| MongoDB | `docker compose exec -u www-data php php bin/console app:mongodb:ping` | « Connexion à MongoDB réussie. » |
| Mails | `docker compose exec -u www-data php php bin/console mailer:test test@example.com` | Mail visible sur http://localhost:8025 |

### Arrêter l'environnement

```bash
docker compose down
```

Les données des bases sont conservées dans les volumes et retrouvées au prochain lancement.