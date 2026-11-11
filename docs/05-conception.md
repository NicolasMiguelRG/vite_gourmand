# Conception

## Diagramme de cas d'utilisation

### Démarche

Les diagrammes de cas d'utilisation sont construits à partir des spécifications fonctionnelles et des règles de gestion du [cahier des charges](02-cahier-des-charges.md).

Ils sont réalisés avec **PlantUML**, via l'extension VS Code, en rendu local :

- le diagramme est décrit en texte (fichiers `.puml`), ce qui permet de le versionner avec Git et de suivre chaque modification dans les pull requests ;
- la même syntaxe servira pour les diagrammes de séquence ;
- le rendu local évite d'envoyer le contenu des diagrammes à un serveur externe.

Les fichiers sources se trouvent dans `docs/diagrammes/`, et les images exportées dans `docs/images/conception/`.

### Découpage

L'application compte une quarantaine de cas d'utilisation. Pour rester lisible, la modélisation est découpée en **un diagramme par espace** : public, utilisateur, employé et administrateur.

### Acteurs

| Acteur                   | Type       | Hérite de |
| ------------------------ | ---------- | --------- |
| Visiteur                 | Principal  | —         |
| Utilisateur              | Principal  | Visiteur  |
| Employé                  | Principal  | Visiteur  |
| Administrateur           | Principal  | Employé   |
| Service d'envoi de mails | Secondaire | —         |

Le service d'envoi de mails est un acteur secondaire : il ne déclenche aucun cas d'utilisation, c'est l'application qui le sollicite pour envoyer les mails prévus par le cahier des charges.

L'héritage évite de répéter les cas d'utilisation : un acteur enfant peut réaliser tous les cas de son parent. Dans chaque diagramme, l'acteur parent est représenté avec une note renvoyant au diagramme qui détaille ses cas. Ce choix implique un compromis assumé : l'utilisateur et l'employé héritent aussi de « Créer un compte », qui n'a plus d'intérêt une fois connecté.

### Conventions de lecture

- **Colonne de gauche** : les cas déclenchés directement par l'acteur.
- **Colonne de droite** : les cas qui en dépendent (`<<include>>` et `<<extend>>`).
- **`<<include>>`** : le cas inclus est exécuté à chaque fois (obligatoire).
- **`<<extend>>`** : le cas qui étend ne s'exécute que sous une condition.
- **Notes** : préconditions et règles, avec la référence de la règle de gestion (RG-xx).
- **Étiquettes vers le service de mails** : le mail envoyé lors du cas.

L'authentification n'est pas représentée par un `<<include>>` : c'est une **précondition** d'accès aux espaces, pas une étape d'un cas d'utilisation.

### Espace public

![Diagramme de cas d'utilisation de l'espace public](images/conception/cas-utilisation-public.png)

Le visiteur, non authentifié, découvre l'entreprise et consulte les avis clients validés depuis la page d'accueil. Il accède à l'ensemble des menus, qu'il peut filtrer dynamiquement, et peut consulter le détail de chacun. Il peut créer un compte, puis confirmer son adresse mail grâce au lien reçu : le compte n'est activé qu'après cette confirmation. Il peut se connecter et, en cas d'oubli, réinitialiser son mot de passe. Il peut également contacter l'entreprise via un formulaire, et consulter les horaires d'ouverture ainsi que les mentions légales et les conditions générales de vente. Le service d'envoi de mails intervient comme acteur secondaire lors de la création de compte (mail de bienvenue contenant le lien de confirmation), de la réinitialisation du mot de passe (lien de réinitialisation, puis alerte de modification) et de la prise de contact (transmission de la demande à l'entreprise).

### Espace utilisateur

![Diagramme de cas d'utilisation de l'espace utilisateur](images/conception/cas-utilisation-utilisateur.png)

L'utilisateur est un visiteur authentifié : il hérite de l'ensemble des cas d'utilisation de l'espace public. Une fois connecté, il peut commander un menu, depuis la vue détaillée d'un menu ou directement depuis la page de commande ; une confirmation lui est alors envoyée par mail par l'intermédiaire du service d'envoi de mails. Il peut consulter le détail de toutes ses commandes, les modifier (à l'exception du menu choisi) ou les annuler tant qu'elles n'ont pas été acceptées par l'équipe ; chaque modification donne lieu à un mail récapitulatif, et chaque annulation, qui fait passer la commande au statut « annulée », à un mail de confirmation. Il peut ensuite suivre l'avancement de ses commandes une fois acceptées. Lorsqu'une commande est terminée, il peut donner un avis, composé d'une note de 1 à 5 et d'un commentaire. Il peut enfin modifier ses informations personnelles ; un changement de mot de passe ou d'adresse mail déclenche un mail d'alerte, envoyé à l'ancienne adresse dans le cas d'un changement d'adresse.

### Espace employé

![Diagramme de cas d'utilisation de l'espace employé](images/conception/cas-utilisation-employe.png)

L'employé hérite des cas d'utilisation de l'espace public. À sa première connexion, il doit remplacer le mot de passe provisoire fourni par l'administrateur par un mot de passe personnel ; un mail d'alerte confirme ce changement. Il gère les menus (création, modification, suppression sous forme d'archivage) et les publie pour les rendre visibles aux clients, à condition qu'ils comportent au moins une photo. Il gère aussi les plats et leurs allergènes, les régimes et les thèmes proposés, et modifie les horaires d'ouverture. Il consulte les commandes, qu'il peut filtrer par statut ou par client, imprime un bon de livraison en PDF pour le livreur lorsqu'une commande est en préparation ou en cours de livraison, et fait évoluer leur statut ; certains changements déclenchent l'envoi d'un mail au client par le service d'envoi de mails : rappel des conditions de restitution du matériel, puis invitation à donner son avis lorsque la commande est terminée. Il ne peut modifier ou annuler la commande d'un client qu'après l'avoir contacté, en renseignant obligatoirement le mode de contact (GSM ou mail) et le motif ; le client reçoit ensuite un mail récapitulatif avec le nouveau prix, ou un mail l'informant de l'annulation et de son motif. Enfin, il modère les avis laissés par les utilisateurs, en les validant ou en les refusant, peut retirer un avis déjà validé, et peut valider un avis refusé par erreur ; un refus ou un retrait exige un motif, communiqué au client par mail, et le client est prévenu par mail lorsque son avis refusé est finalement publié.

### Espace administrateur

![Diagramme de cas d'utilisation de l'espace administrateur](images/conception/cas-utilisation-administrateur.png)

L'administrateur hérite de l'ensemble des cas d'utilisation de l'espace employé. Il crée les comptes employés à partir du nom, du prénom et de l'adresse mail de l'employé ; un mot de passe provisoire est généré automatiquement, et l'employé est informé de la création de son compte par un mail envoyé par le service d'envoi de mails, qui ne contient jamais le mot de passe. Il peut désactiver un compte employé, par exemple en cas de départ de l'entreprise, puis le réactiver si besoin avec un nouveau mot de passe provisoire. Il peut aussi consulter l'historique des actions d'un employé. Il consulte enfin les statistiques de l'activité : le nombre de commandes par menu, hors commandes annulées, présenté sous forme de graphique comparatif et filtrable par période, et le chiffre d'affaires par menu, réalisé et prévisionnel, qu'il peut filtrer par menu et par période. Le compte administrateur unique est créé par le développeur : aucun compte administrateur ne peut être créé depuis l'application.

## Diagramme de séquence

### Démarche
 
Le diagramme de cas d'utilisation décrit **ce que** le système permet de faire ; le diagramme de séquence décrit **comment** une de ces actions se déroule, dans le temps, entre les différentes parties de l'application. Il complète donc la section précédente plutôt qu'il ne la répète.
 
La construction s'est faite en quatre temps : choix du cas d'utilisation à détailler, recensement des participants, écriture du scénario nominal du début à la fin, puis ajout des cas alternatifs jugés utiles.
 
### Choix du cas d'utilisation
 
Le cas retenu est **« Commander un menu »**, pour trois raisons :
 
- **C'est le cœur du métier.** Toutes les autres fonctionnalités (consulter les menus, les gérer, modérer les avis, consulter les statistiques) existent pour permettre la commande ou en découlent. Sans elle, l'application n'a plus d'objet.
- **C'est le cas qui met en jeu le plus de participants.** Il sollicite le front-end, le back-end, la base de données relationnelle, la base non relationnelle, l'API de calcul d'itinéraire et le service d'envoi de mails. Un seul diagramme suffit donc à montrer comment l'ensemble des composants de l'application communiquent entre eux.
- **C'est là que se concentrent les règles de gestion et les contrôles de sécurité.** Calcul du prix (RG-14), réduction (RG-15), frais de livraison (RG-16), nombre minimum de personnes (RG-13), délai de commande (RG-30), stock (RG-06), figement des données (RG-35), statut initial (RG-19) : toutes sont vérifiées par le serveur au cours de ce seul parcours.
Deux autres cas avaient été envisagés : « Se connecter », qui concentre les mécanismes de sécurité du compte, et « Faire évoluer le statut d'une commande », qui illustre le travail de l'employé. Ils n'ont pas été retenus : leurs échanges sont plus simples et leurs participants moins nombreux. Ils pourront faire l'objet de diagrammes complémentaires si le besoin s'en fait sentir.
 
### Participants
 
| Participant | Rôle dans le diagramme |
|---|---|
| Utilisateur | Acteur principal, client connecté qui passe la commande |
| Front-end | Partie de l'application exécutée dans le navigateur : affichage, saisie, calculs d'affichage |
| Back-end | Partie exécutée sur le serveur : vérifications, calculs faisant foi, accès aux données |
| Base de données relationnelle | Source de vérité : comptes, menus, plats, commandes, historiques |
| Base NoSQL | Copie des commandes destinée à la lecture pour les statistiques de l'administrateur |
| API d'itinéraire | Service externe qui fournit la distance par la route (RG-16) |
| Service d'envoi de mails | Service externe sollicité par le système, jamais déclencheur |
 
Les participants sont nommés de façon générique : aucune technologie n'apparaît dans le diagramme. Les choix techniques font l'objet d'une étape ultérieure du projet, et le déroulement décrit ici reste valable quelle que soit la pile retenue.
 
### Conventions de lecture
 
- Le temps s'écoule de haut en bas ; chaque participant possède une ligne de vie verticale.
- Une **flèche pleine** représente un message (une demande, une action déclenchée chez un autre participant).
- Une **flèche en pointillés** représente une réponse à un message précédent.
- Une flèche qui **revient sur son émetteur** représente une action qu'il effectue seul : vérifier, calculer.
- Un cadre **`alt`** représente une alternative : seule une des branches se déroule.
- Un cadre **`ref`** renvoie à une séquence déjà décrite plus haut, pour éviter de la redessiner.
- Les **notes** précisent ce que le dessin seul ne peut pas exprimer.
- Les règles de gestion concernées sont citées directement dans le texte des messages, pour assurer la traçabilité avec le cahier des charges.
### Schéma
 
![Diagramme de séquence du cas d'utilisation « Commander un menu », en quatre étapes : affichage du formulaire prérempli, saisie et calcul du prix, validation de la commande, confirmation. Les échanges relient l'utilisateur, le front-end, le back-end, la base de données relationnelle, la base NoSQL, l'API d'itinéraire et le service d'envoi de mails.](images/conception/sequence-commander-menu.png)
 
Source : `docs/diagrammes/sequence-commander-menu.puml`
 
### Déroulement
 
**Affichage du formulaire.** L'utilisateur clique sur « Commander » depuis la vue détaillée d'un menu. Le front-end demande le formulaire au back-end, qui vérifie d'abord la session : l'identité est lue dans la session côté serveur, jamais dans les données envoyées par le navigateur. Il lit ensuite en base les informations du compte et celles du menu, puis vérifie que le menu est bien publié (RG-29) et qu'il reste du stock (RG-06). Le formulaire est renvoyé prérempli avec les coordonnées du client.
 
**Saisie et calcul du prix.** Lorsque l'utilisateur saisit le nombre de personnes, le front-end calcule seul le prix (RG-14) et la réduction éventuelle (RG-15) à partir des données qu'il a déjà reçues : le montant affiché se met à jour sans aller-retour avec le serveur. La saisie de l'adresse, en revanche, déclenche une demande au back-end. Si l'adresse se trouve dans la commune de Bordeaux, la livraison est gratuite et aucun appel externe n'est nécessaire (RG-16). Sinon, le back-end interroge l'API d'itinéraire pour obtenir la distance par la route, puis calcule les frais. Le récapitulatif complet est alors affiché (RG-18).
 
**Validation de la commande.** L'utilisateur accepte les conditions générales de vente et valide. Le back-end revérifie tout : la session, les saisies, puis les données du menu qu'il relit en base, car elles ont pu changer depuis l'ouverture du formulaire — un autre client a pu prendre le dernier menu disponible, ou l'employé a pu l'archiver. Il contrôle le statut du menu (RG-29), le stock (RG-06), le nombre minimum de personnes (RG-13) et le respect du délai de commande (RG-30), puis recalcule lui-même le prix, la réduction et les frais de livraison. Le montant affiché par le navigateur n'est jamais utilisé tel quel. L'enregistrement se fait enfin en une seule **transaction** : la commande et ses prix figés (RG-35), la copie des plats et de leurs allergènes, le statut initial « en attente » (RG-19) et la décrémentation du stock (RG-06) sont écrits ensemble, ou pas du tout. Cette garantie évite qu'une panne laisse une commande sans statut ou un stock décrémenté sans commande.
 
**Confirmation.** La commande étant enregistrée, le back-end en copie les données dans la base non relationnelle, qui alimente les statistiques de l'administrateur. Cette écriture a lieu **après** la transaction : elle a besoin de l'identifiant créé par celle-ci, et une transaction échouée ne doit pas laisser de commande fantôme dans les statistiques. Le mail de confirmation est envoyé, puis le numéro de commande remonte jusqu'à l'utilisateur, qui voit son message de confirmation.
 
### Choix de conception
 
**Calcul du prix côté navigateur, vérification côté serveur.** Le front-end calcule le prix pour l'affichage, ce qui rend le formulaire instantané et évite une requête à chaque changement du nombre de personnes. La sécurité est assurée par le recalcul du serveur à la validation : si les deux montants diffèrent, la commande n'est pas enregistrée et le nouveau prix doit être validé. La contrepartie assumée est que la formule de calcul existe à deux endroits.
 
**Appel de l'API d'itinéraire depuis le serveur.** Une clé d'API placée dans le code du navigateur serait lisible par n'importe quel visiteur, et pourrait être réutilisée au détriment de l'entreprise. Par ailleurs, une distance transmise par le navigateur pourrait être falsifiée pour réduire les frais : le serveur doit obtenir lui-même la valeur sur laquelle il fonde son calcul.
 
**Appel de l'API seulement hors de Bordeaux.** La livraison étant gratuite dans la commune (RG-16), la distance y est inutile. Ce choix réduit le nombre d'appels — donc le quota consommé et le coût éventuel —, accélère la réponse, et permet aux clients bordelais de commander même si l'API est indisponible.
 
**Les échecs de notification n'annulent pas la commande.** Si l'envoi du mail ou l'écriture dans la base non relationnelle échoue, la commande reste valide : elle est enregistrée, visible dans l'espace du client et confirmée à l'écran. L'erreur est inscrite au journal des erreurs. La base relationnelle restant la source de vérité, le document manquant pourra être recopié ultérieurement.
 
### Cas alternatifs non représentés
 
Pour rester lisible, le diagramme ne représente que le scénario nominal et le cas d'une adresse dont la distance ne peut pas être calculée. Les autres situations d'erreur sont décrites ici :
 
| Situation | Comportement attendu |
|---|---|
| Utilisateur non connecté | Redirection vers la connexion ou la création de compte |
| Menu inexistant, non publié ou épuisé | Message d'information ; le formulaire n'est pas affiché ou la validation est refusée (RG-06, RG-29) |
| Saisie invalide (minimum non atteint, date trop proche, champ vide) | Message précis sur le champ concerné ; les autres champs restent remplis (RG-13, RG-30) |
| Prix recalculé différent du prix affiché | La commande n'est pas enregistrée ; le nouveau prix est affiché et doit être validé à nouveau |
| Échec de l'envoi du mail ou de l'écriture non relationnelle | La commande est maintenue ; l'erreur est enregistrée dans le journal des erreurs |
 
### Point à préciser lors du choix des technologies
 
Le diagramme distingue les adresses situées dans la commune de Bordeaux des autres, sans préciser comment cette appartenance est établie. Se fier au champ « ville » saisi par le client serait insuffisant, celui-ci pouvant être modifié pour obtenir une livraison gratuite. Une vérification fondée sur le géocodage de l'adresse sera retenue si l'API choisie le permet.
 

## Modèle conceptuel de données

### Démarche

L'expression du besoin fournit un premier modèle conceptuel de données (annexe 1, p. 10). Il a servi de point de départ : il a été comparé, association par association et attribut par attribut, aux spécifications fonctionnelles, aux règles de gestion et aux user stories du [cahier des charges](02-cahier-des-charges.md).

La modélisation suit la méthode Merise, en trois temps :

1. **Lecture** : séparer les données des traitements, formuler les règles de gestion, repérer les entités et associations candidates.
2. **Dictionnaire des données** : décrire chaque donnée, distinguer les données élémentaires, calculées et composées, puis épurer le dictionnaire avant de modéliser.
3. **Modélisation** : poser les entités et leurs identifiants, les relier par des associations nommées, fixer les cardinalités d'après les règles de gestion, puis vérifier la cohérence du modèle en suivant des scénarios réels.

Le modèle a été écrit avec [Mocodo](https://www.mocodo.net/), qui dessine le schéma à partir d'un texte. La source est versionnée dans `docs/diagrammes/mcd.mcd` : chaque modification du modèle est lisible dans l'historique Git et dans les pull requests.

### Dictionnaire des données

Le dictionnaire recense toutes les données que l'application doit conserver, à partir des spécifications fonctionnelles, des règles de gestion et des user stories du [cahier des charges](02-cahier-des-charges.md). Il a été épuré avant la modélisation : il ne contient que des données élémentaires, sans donnée calculée ni redondante. Les données retirées de l'annexe sont justifiées dans le tableau des corrections.

**Types** : AN = alphanumérique (texte) · N = numérique · D = date · H = heure · DH = date et heure · B = booléen (oui / non).
**Taille** : nombre maximum de caractères pour un texte ; « texte long » pour un texte libre sans limite précise ; « 2 décimales » pour un montant en euros.
Les numéros de téléphone et les codes postaux sont de type AN : on ne fait aucun calcul avec, et ils peuvent commencer par 0.

**utilisateur**

| Code                      | Signification                                               | Type | Taille | Valeurs possibles / contrainte                                       | Source            |
| ------------------------- | ----------------------------------------------------------- | ---- | ------ | -------------------------------------------------------------------- | ----------------- |
| `utilisateur_id`          | Identifiant de l'utilisateur                                | N    | —      | Unique, attribué automatiquement                                     | —                 |
| `nom`                     | Nom de famille                                              | AN   | 50     | Obligatoire                                                          | Story 6, story 35 |
| `prenom`                  | Prénom                                                      | AN   | 50     | Obligatoire                                                          | Story 6, story 35 |
| `email`                   | Adresse mail, utilisée pour se connecter                    | AN   | 255    | Obligatoire, unique                                                  | RG-08             |
| `telephone`               | Numéro de GSM                                               | AN   | 20     | Obligatoire pour un client, vide pour un employé                     | Story 6, story 35 |
| `adresse`                 | Numéro et nom de la rue                                     | AN   | 255    | Obligatoire pour un client, vide pour un employé                     | Story 6           |
| `code_postal`             | Code postal                                                 | AN   | 5      | Obligatoire pour un client, vide pour un employé                     | Story 6           |
| `ville`                   | Ville                                                       | AN   | 100    | Obligatoire pour un client, vide pour un employé                     | Story 6           |
| `mot_de_passe_hache`      | Empreinte du mot de passe (jamais le mot de passe en clair) | AN   | 255    | Obligatoire                                                          | RG-07, story 6    |
| `date_confirmation`       | Date et heure de confirmation de l'adresse mail             | DH   | —      | Vide = compte non confirmé ; remplie dès la création pour un employé | RG-33             |
| `mot_de_passe_provisoire` | Le mot de passe doit être changé à la prochaine connexion   | B    | —      | Oui à la création et à la réactivation d'un compte employé           | RG-10 bis, RG-11  |
| `actif`                   | Le compte peut se connecter                                 | B    | —      | Non = compte désactivé                                               | RG-11             |

**role**

| Code      | Signification       | Type | Taille | Valeurs possibles / contrainte         | Source              |
| --------- | ------------------- | ---- | ------ | -------------------------------------- | ------------------- |
| `role_id` | Identifiant du rôle | N    | —      | Unique, attribué automatiquement       | —                   |
| `libelle` | Nom du rôle         | AN   | 20     | utilisateur / employé / administrateur | RG-09, RG-10, RG-12 |

**menu**

| Code                      | Signification                                              | Type | Taille      | Valeurs possibles / contrainte      | Source            |
| ------------------------- | ---------------------------------------------------------- | ---- | ----------- | ----------------------------------- | ----------------- |
| `menu_id`                 | Identifiant du menu                                        | N    | —           | Unique, attribué automatiquement    | —                 |
| `titre`                   | Titre du menu                                              | AN   | 100         | Obligatoire                         | Story 22          |
| `description`             | Description du menu                                        | AN   | texte long  | Obligatoire                         | Story 22          |
| `conditions`              | Conditions du menu (délai, matériel à restituer…)          | AN   | texte long  | Obligatoire                         | Story 5, story 22 |
| `nombre_personne_minimum` | Nombre minimum de personnes                                | N    | —           | Entier ≥ 1                          | RG-05, RG-13      |
| `prix_minimum`            | Prix du menu pour le nombre minimum de personnes           | N    | 2 décimales | > 0                                 | RG-05             |
| `stock`                   | Nombre de commandes encore possibles                       | N    | —           | Entier ≥ 0                          | RG-06             |
| `statut`                  | État de publication du menu                                | AN   | 10          | brouillon / publié / archivé        | RG-29             |
| `delai_minimum_jours`     | Délai minimum entre la commande et la prestation, en jours | N    | —           | Entier ≥ 0                          | RG-30             |
| `description_materiel`    | Description du matériel prêté avec le menu                 | AN   | texte long  | Facultatif ; vide = pas de matériel | RG-31             |

**theme**

| Code       | Signification        | Type | Taille | Valeurs possibles / contrainte                          | Source          |
| ---------- | -------------------- | ---- | ------ | ------------------------------------------------------- | --------------- |
| `theme_id` | Identifiant du thème | N    | —      | Unique, attribué automatiquement                        | —               |
| `libelle`  | Nom du thème         | AN   | 50     | Unique ; au départ : Noël, Pâques, classique, événement | RG-01, story 39 |

**regime**

| Code        | Signification         | Type | Taille | Valeurs possibles / contrainte                                                            | Source          |
| ----------- | --------------------- | ---- | ------ | ----------------------------------------------------------------------------------------- | --------------- |
| `regime_id` | Identifiant du régime | N    | —      | Unique, attribué automatiquement                                                          | —               |
| `libelle`   | Nom du régime         | AN   | 50     | Unique ; au départ : classique, végétarien, vegan, pescétarien, sans gluten, sans lactose | RG-02, story 39 |

**plat**

| Code                     | Signification                                     | Type | Taille     | Valeurs possibles / contrainte        | Source          |
| ------------------------ | ------------------------------------------------- | ---- | ---------- | ------------------------------------- | --------------- |
| `plat_id`                | Identifiant du plat                               | N    | —          | Unique, attribué automatiquement      | —               |
| `nom`                    | Nom du plat                                       | AN   | 100        | Obligatoire                           | Story 26        |
| `categorie`              | Catégorie du plat                                 | AN   | 10         | entrée / plat / dessert               | RG-03           |
| `chemin_photo`           | Emplacement du fichier de la photo sur le serveur | AN   | 255        | Facultatif                            | Story 26, RG-32 |
| `texte_alternatif_photo` | Description de la photo pour les lecteurs d'écran | AN   | 255        | Obligatoire si une photo est présente | Story 26 (RGAA) |
| `description_materiel`   | Description du matériel prêté avec le plat        | AN   | texte long | Facultatif ; vide = pas de matériel   | RG-31           |

**allergene**

| Code           | Signification              | Type | Taille | Valeurs possibles / contrainte                  | Source |
| -------------- | -------------------------- | ---- | ------ | ----------------------------------------------- | ------ |
| `allergene_id` | Identifiant de l'allergène | N    | —      | Unique, attribué automatiquement                | —      |
| `libelle`      | Nom de l'allergène         | AN   | 50     | Les 14 allergènes du règlement INCO, liste fixe | RG-04  |

**photo** (galerie d'un menu)

| Code               | Signification                                     | Type | Taille | Valeurs possibles / contrainte      | Source          |
| ------------------ | ------------------------------------------------- | ---- | ------ | ----------------------------------- | --------------- |
| `photo_id`         | Identifiant de la photo                           | N    | —      | Unique, attribué automatiquement    | —               |
| `chemin_fichier`   | Emplacement du fichier sur le serveur             | AN   | 255    | Obligatoire                         | Story 25, RG-32 |
| `texte_alternatif` | Description de la photo pour les lecteurs d'écran | AN   | 255    | Obligatoire                         | Story 25 (RGAA) |
| `est_principale`   | Photo affichée en premier                         | B    | —      | Une seule photo principale par menu | Story 25        |

**commande**

| Code                        | Signification                                         | Type | Taille      | Valeurs possibles / contrainte    | Source             |
| --------------------------- | ----------------------------------------------------- | ---- | ----------- | --------------------------------- | ------------------ |
| `commande_id`               | Identifiant de la commande                            | N    | —           | Unique, attribué automatiquement  | —                  |
| `numero_commande`           | Numéro communiqué au client (mails, bon de livraison) | AN   | 20          | Unique                            | Story 31, story 41 |
| `date_prestation`           | Date de la prestation                                 | D    | —           | Respecte le délai minimum du menu | Story 13, RG-30    |
| `heure_livraison`           | Heure de livraison souhaitée                          | H    | —           | Obligatoire                       | Story 13           |
| `nombre_personne`           | Nombre de personnes                                   | N    | —           | Entier ≥ minimum du menu          | RG-13              |
| `adresse_prestation`        | Numéro et nom de la rue de la prestation              | AN   | 255         | Obligatoire                       | Story 13           |
| `code_postal_prestation`    | Code postal de la prestation                          | AN   | 5           | Obligatoire                       | Story 13           |
| `ville_prestation`          | Ville de la prestation                                | AN   | 100         | Obligatoire                       | Story 13, RG-16    |
| `prix_menu`                 | Prix du menu validé par le client                     | N    | 2 décimales | Figé à la validation              | RG-14, RG-35       |
| `montant_reduction`         | Montant de la réduction accordée                      | N    | 2 décimales | 0 si aucune réduction ; figé      | RG-15, RG-35       |
| `prix_livraison`            | Frais de livraison                                    | N    | 2 décimales | 0 dans Bordeaux ; figé            | RG-16, RG-35       |
| `description_materiel_menu` | Matériel prêté avec le menu au moment de la commande  | AN   | texte long  | Facultatif ; figé                 | RG-31, RG-35       |

**plat_commande** (copie des plats à la validation de la commande)

| Code                   | Signification                                        | Type | Taille     | Valeurs possibles / contrainte   | Source       |
| ---------------------- | ---------------------------------------------------- | ---- | ---------- | -------------------------------- | ------------ |
| `plat_commande_id`     | Identifiant du plat commandé                         | N    | —          | Unique, attribué automatiquement | —            |
| `nom`                  | Nom du plat au moment de la commande                 | AN   | 100        | Obligatoire                      | RG-35        |
| `categorie`            | Catégorie du plat au moment de la commande           | AN   | 10         | entrée / plat / dessert          | RG-03, RG-35 |
| `description_materiel` | Matériel prêté avec le plat au moment de la commande | AN   | texte long | Facultatif                       | RG-31, RG-35 |

**changement_statut** (historique des statuts d'une commande)

| Code                   | Signification                 | Type | Taille | Valeurs possibles / contrainte                                                                                                | Source              |
| ---------------------- | ----------------------------- | ---- | ------ | ----------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `changement_statut_id` | Identifiant du changement     | N    | —      | Unique, attribué automatiquement                                                                                              | —                   |
| `statut`               | Nouveau statut de la commande | AN   | 40     | en attente / accepté / en préparation / en cours de livraison / livré / en attente du retour de matériel / terminée / annulée | RG-19, RG-20, RG-36 |
| `date_heure`           | Date et heure du changement   | DH   | —      | Obligatoire                                                                                                                   | RG-21               |

**contact** (contact du client par un employé)

| Code            | Signification                               | Type | Taille     | Valeurs possibles / contrainte                              | Source |
| --------------- | ------------------------------------------- | ---- | ---------- | ----------------------------------------------------------- | ------ |
| `contact_id`    | Identifiant du contact                      | N    | —          | Unique, attribué automatiquement                            | —      |
| `objet`         | Raison du contact                           | AN   | 15         | modification / annulation                                   | RG-23  |
| `mode`          | Moyen de contact                            | AN   | 5          | GSM / mail                                                  | RG-23  |
| `motif`         | Motif de la modification ou de l'annulation | AN   | texte long | Obligatoire                                                 | RG-23  |
| `date_heure`    | Date et heure du contact                    | DH   | —          | Obligatoire                                                 | RG-23  |
| `accord_client` | Le client a donné son accord                | B    | —          | Obligatoire pour une modification, vide pour une annulation | RG-23  |

**modification** (modification enregistrée d'une commande)

| Code              | Signification                    | Type | Taille | Valeurs possibles / contrainte   | Source             |
| ----------------- | -------------------------------- | ---- | ------ | -------------------------------- | ------------------ |
| `modification_id` | Identifiant de la modification   | N    | —      | Unique, attribué automatiquement | —                  |
| `date_heure`      | Date et heure de la modification | DH   | —      | Obligatoire                      | Story 17, story 32 |

**avis**

| Code          | Signification                   | Type | Taille     | Valeurs possibles / contrainte   | Source   |
| ------------- | ------------------------------- | ---- | ---------- | -------------------------------- | -------- |
| `avis_id`     | Identifiant de l'avis           | N    | —          | Unique, attribué automatiquement | —        |
| `note`        | Note donnée par le client       | N    | —          | Entier de 1 à 5                  | RG-27    |
| `commentaire` | Commentaire du client           | AN   | texte long | Obligatoire                      | RG-27    |
| `date_depot`  | Date et heure d'envoi de l'avis | DH   | —          | Obligatoire                      | Story 34 |

**decision_moderation**

| Code                     | Signification                | Type | Taille     | Valeurs possibles / contrainte                      | Source   |
| ------------------------ | ---------------------------- | ---- | ---------- | --------------------------------------------------- | -------- |
| `decision_moderation_id` | Identifiant de la décision   | N    | —          | Unique, attribué automatiquement                    | —        |
| `decision`               | Décision prise sur l'avis    | AN   | 10         | validé / refusé / retiré                            | RG-28    |
| `motif`                  | Motif du refus ou du retrait | AN   | texte long | Obligatoire pour refusé et retiré, vide pour validé | RG-28    |
| `date_heure`             | Date et heure de la décision | DH   | —          | Obligatoire                                         | Story 34 |

**jeton** (lien personnel envoyé par mail)

| Code               | Signification                                                    | Type | Taille | Valeurs possibles / contrainte           | Source       |
| ------------------ | ---------------------------------------------------------------- | ---- | ------ | ---------------------------------------- | ------------ |
| `jeton_id`         | Identifiant du jeton                                             | N    | —      | Unique, attribué automatiquement         | —            |
| `code`             | Empreinte du code contenu dans le lien (jamais le code en clair) | AN   | 255    | Obligatoire                              | RG-33, RG-34 |
| `type`             | Usage du lien                                                    | AN   | 20     | confirmation / réinitialisation          | RG-33, RG-34 |
| `date_expiration`  | Date et heure au-delà desquelles le lien ne fonctionne plus      | DH   | —      | Réinitialisation : 1 heure après l'envoi | RG-33, RG-34 |
| `date_utilisation` | Date et heure d'utilisation du lien                              | DH   | —      | Vide = pas encore utilisé ; usage unique | RG-33, RG-34 |

**horaire**

| Code          | Signification                           | Type | Taille | Valeurs possibles / contrainte                  | Source |
| ------------- | --------------------------------------- | ---- | ------ | ----------------------------------------------- | ------ |
| `horaire_id`  | Identifiant de la ligne d'horaires      | N    | —      | Unique, attribué automatiquement                | —      |
| `jour`        | Jour de la semaine                      | AN   | 10     | lundi à dimanche, une ligne par jour            | RG-38  |
| `ouverture_1` | Heure d'ouverture de la première plage  | H    | —      | Vide = jour fermé                               | RG-38  |
| `fermeture_1` | Heure de fermeture de la première plage | H    | —      | Postérieure à `ouverture_1`                     | RG-38  |
| `ouverture_2` | Heure d'ouverture de la deuxième plage  | H    | —      | Facultative                                     | RG-38  |
| `fermeture_2` | Heure de fermeture de la deuxième plage | H    | —      | Postérieure à `ouverture_2`, sans chevauchement | RG-38  |

### Schéma

![Modèle conceptuel de données de Vite & Gourmand : 17 entités, dont utilisateur, commande et menu au centre, reliées par 20 associations ; l'entité horaire est isolée](images/conception/mcd.svg)

Le modèle compte **17 entités** et **20 associations**. Il ne concerne que la base de données relationnelle ; les données de la base non relationnelle sont présentées plus bas.

Les cardinalités se lisent du côté de l'entité qui les porte. Par exemple, `UTILISATEUR (0,N) — passe — (1,1) COMMANDE` se lit : un utilisateur passe zéro ou plusieurs commandes ; une commande est passée par un et un seul utilisateur.

### Corrections du modèle fourni

| #   | Élément                                       | Modèle fourni                                | Modèle corrigé                                                     | Justification                                                                                                                                                                                                                   |
| --- | --------------------------------------------- | -------------------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Association `publie` (utilisateur – avis)     | utilisateur 1,1 / avis 0,n                   | Cardinalités inversées                                             | Un utilisateur publie zéro ou plusieurs avis, et un avis est publié par un seul utilisateur. Correction devenue sans objet (voir n° 3)                                                                                          |
| 2   | Association commande – avis                   | Absente                                      | `COMMANDE (0,1) — evalue — (1,1) AVIS`                             | Un avis porte sur une commande terminée, une seule fois par commande (RG-26) ; sans ce lien, impossible de savoir quelle commande un avis évalue                                                                                |
| 3   | Association `publie`                          | Présente                                     | Supprimée                                                          | Redondante : l'auteur d'un avis se retrouve par l'avis, la commande puis l'utilisateur. La garder permettrait des incohérences (un avis attribué à un autre client que celui de la commande)                                    |
| 4   | Association utilisateur – commande            | Trait direct, sans cardinalité côté commande | `UTILISATEUR (0,N) — passe — (1,1) COMMANDE`                       | Association et cardinalité manquantes. Une commande est passée par un seul client, connecté                                                                                                                                     |
| 5   | Association menu – commande                   | Trait direct, sans cardinalité côté commande | `MENU (0,N) — concerne_menu — (1,1) COMMANDE`                      | Association et cardinalité manquantes. Une commande porte sur un seul menu (RG-22). Nommée `concerne_menu` car le nom `contient` est déjà utilisé                                                                               |
| 6   | Association `adapte` (menu – régime)          | menu 1,1 / régime 0,n                        | `MENU (1,N) — adapte — (0,N) REGIME`                               | Interprétation : un menu peut cumuler plusieurs régimes (par exemple végétarien et sans gluten), pour qu'un client retrouve un menu qui respecte toutes ses contraintes. Le régime « classique » ne se combine avec aucun autre |
| 7   | Attributs de `horaire`                        | Une plage par jour                           | `jour`, `ouverture_1`, `fermeture_1`, `ouverture_2`, `fermeture_2` | Deux plages possibles par jour (RG-38). Un jour fermé n'a pas de première plage : un attribut « fermé » serait redondant et pourrait contredire les heures saisies                                                              |
| 8   | Attribut `statut` de `avis`                   | Présent                                      | Supprimé                                                           | Redondant : le statut d'un avis se déduit de sa dernière décision de modération (aucune décision : en attente)                                                                                                                  |
| 9   | Attribut `statut` de `commande`               | Présent                                      | Supprimé                                                           | Redondant : le statut actuel est donné par le dernier changement de statut                                                                                                                                                      |
| 10  | Attribut `photo` de `plat`                    | Image stockée dans la base                   | `chemin_photo`, `texte_alternatif_photo`                           | Le fichier est rangé sur le serveur, dans un emplacement où il ne peut pas être exécuté ; la base n'en garde que l'emplacement. Texte alternatif ajouté pour l'accessibilité (RGAA)                                             |
| 11  | Attribut `pret_materiel` de `commande`        | Présent                                      | Supprimé                                                           | Donnée calculée : la commande comprend du matériel si la description du matériel du menu ou d'un plat commandé est remplie                                                                                                      |
| 12  | Attribut `restitution_materiel` de `commande` | Présent                                      | Supprimé                                                           | Redondant : le matériel est restitué quand la commande passe de « en attente du retour de matériel » à « terminée » (RG-25)                                                                                                     |
| 13  | Attribut `nom` de `utilisateur`               | Absent                                       | Ajouté                                                             | Demandé à l'inscription et à la création d'un compte employé, affiché dans le détail d'une commande                                                                                                                             |
| 14  | Adresse de `utilisateur`                      | `adresse_postale`, `ville`, `pays`           | `adresse`, `code_postal`, `ville`                                  | Donnée composée découpée (une valeur par attribut), ce qui rend aussi le calcul d'itinéraire plus fiable (RG-16). Pays supprimé : la livraison se fait autour de Bordeaux (minimisation des données, RGPD)                      |
| 15  | Attribut `password` de `utilisateur`          | `password`                                   | `mot_de_passe_hache`                                               | Le mot de passe n'est jamais stocké, seulement son empreinte                                                                                                                                                                    |
| 16  | Attribut `regime` de `menu`                   | Présent                                      | Supprimé                                                           | Redondant avec l'association `adapte`, et un attribut ne peut contenir qu'un seul régime                                                                                                                                        |
| 17  | Attribut `prix_par_personne` de `menu`        | Présent                                      | Remplacé par `prix_minimum`                                        | Le prix est défini pour le nombre minimum de personnes (RG-05) ; le prix par personne se calcule                                                                                                                                |
| 18  | Attribut `conditions` de `menu`               | Absent                                       | Ajouté                                                             | Conditions affichées dans la vue détaillée avant de commander                                                                                                                                                                   |
| 19  | Attributs de `plat`                           | `titre_plat`, `photo`                        | `nom`, `categorie` ajoutés                                         | Un plat est une entrée, un plat principal ou un dessert (RG-03). Liste fixe de trois valeurs : attribut, et non entité                                                                                                          |
| 20  | Attributs de `avis`                           | `description`                                | `commentaire`, `date_depot`                                        | Vocabulaire de RG-27 ; date affichée à l'employé et utilisée pour trier les avis en attente                                                                                                                                     |
| 21  | Attribut `date_commande` de `commande`        | Présent                                      | Supprimé                                                           | Redondant : la date de la commande est celle de son premier changement de statut, « en attente »                                                                                                                                |
| 22  | Adresse de la prestation dans `commande`      | Absente                                      | `adresse_prestation`, `code_postal_prestation`, `ville_prestation` | La prestation peut avoir lieu ailleurs qu'à l'adresse du compte. Ce n'est pas une redondance : la commande garde cette adresse même si le client modifie ensuite son compte                                                     |

Autres changements : `quantite_restante` est renommé `stock`, le mot employé par RG-06 ; l'association menu – thème est renommée `appartient_theme`, car le nom `propose` était utilisé deux fois.

### Associations conformes au modèle fourni
 
- `UTILISATEUR (1,1) — possede — (0,N) ROLE` : un compte a un seul rôle (RG-09, RG-10).
- `MENU (1,1) — appartient_theme — (0,N) THEME` : un menu a un seul thème (RG-01). Seul le nom change.
- `MENU (1,N) — propose — (0,N) PLAT` : un menu contient au moins un plat ; un plat peut appartenir à plusieurs menus (RG-03).
- `PLAT (0,N) — contient — (0,N) ALLERGENE` : un plat peut contenir plusieurs allergènes (RG-04).
- `HORAIRE` reste isolée : les horaires sont un paramétrage de l'entreprise, et aucune règle ne les relie à une autre donnée.

Il n'y a pas d'entité « employé » ni « administrateur » : ce sont des utilisateurs dont le rôle diffère.
 
### Enrichissements
 
Pour chaque règle de gestion, la question posée est : que doit retenir l'application ? Une information qui n'a qu'une valeur devient un attribut ; une information qui se répète un nombre variable de fois devient une entité.
 
| # | Règle | Ajout | Justification |
|---|---|---|---|
| E1 | RG-29 | Attribut `statut` de `menu` | Brouillon, publié ou archivé |
| E2 | RG-30 | Attribut `delai_minimum_jours` de `menu` | Délai minimum de commande propre à chaque menu |
| E3 | RG-19, RG-21 | Entité `CHANGEMENT_STATUT` ; `COMMANDE (1,N) — subit — (1,1) CHANGEMENT_STATUT` ; `UTILISATEUR (0,N) — effectue — (0,1) CHANGEMENT_STATUT` | Historique des statuts avec leur date et leur heure. Une commande a au moins le statut « en attente » dès sa création. Ce premier statut, comme une annulation par le client, n'est effectué par aucun employé, d'où le minimum à 0 |
| E4 | RG-23 | Entité `CONTACT` ; `COMMANDE (0,N) — donne_lieu — (1,1) CONTACT` ; `UTILISATEUR (0,N) — contacte — (1,1) CONTACT` | Contact du client avant une modification ou une annulation par un employé : objet, mode, motif, date et heure, accord du client (vide pour une annulation). Une commande peut donner lieu à plusieurs contacts |
| E5 | Stories 17 et 32 | Entité `MODIFICATION` ; `COMMANDE (0,N) — est_modifiee — (1,1) MODIFICATION` ; `UTILISATEUR (0,N) — enregistre — (0,1) MODIFICATION` | Trace de chaque modification enregistrée, dans l'historique de la commande. Aucun employé quand le client modifie lui-même sa commande. Distincte de l'accord du client, qui n'est pas la preuve que la modification a été enregistrée |
| E6 | RG-28 | Entité `DECISION_MODERATION` ; `AVIS (0,N) — recoit — (1,1) DECISION_MODERATION` ; `UTILISATEUR (0,N) — modere — (1,1) DECISION_MODERATION` | Un avis peut recevoir plusieurs décisions (validé puis retiré, refusé puis validé), chacune avec son motif, sa date et son auteur |
| E7 | RG-29, RG-32 | Entité `PHOTO` ; `MENU (0,N) — illustre — (1,1) PHOTO` | Galerie d'images d'un menu, avec une photo principale et un texte alternatif. Un menu en brouillon peut n'avoir aucune photo |
| E8 | RG-31 | Attribut `description_materiel` de `menu` et de `plat` | Description du matériel prêté ; vide s'il n'y en a pas. « Le menu comprend du matériel » est calculé, pas stocké |
| E9 | RG-35 | Attributs `prix_menu`, `montant_reduction`, `prix_livraison`, `description_materiel_menu` de `commande` ; entité `PLAT_COMMANDE` ; `COMMANDE (1,N) — compose — (1,1) PLAT_COMMANDE` ; `PLAT_COMMANDE (0,N) — contient_fige — (0,N) ALLERGENE` | La commande garde ce que le client a validé, même si le menu ou un plat change ensuite. C'est une copie historique, pas une redondance : le prix actuel d'un menu et le prix accepté par le client ont le droit de différer. Le total se calcule à partir des montants figés. Les allergènes sont reliés directement, car leur liste réglementaire ne change pas |
| E10 | RG-33, RG-34 | Entité `JETON` ; `UTILISATEUR (0,N) — recoit_jeton — (1,1) JETON` | Liens personnels envoyés par mail (confirmation de l'adresse, réinitialisation du mot de passe), avec leur empreinte, leur expiration et leur date d'utilisation (usage unique) |
| E11 | RG-10 bis, RG-11, RG-33 | Attributs `date_confirmation`, `mot_de_passe_provisoire`, `actif` de `utilisateur` | Compte confirmé ou non, mot de passe provisoire à changer, compte actif ou désactivé |

### Règles non exprimables par le modèle
Certaines règles ne peuvent pas être imposées par les cardinalités. Elles seront vérifiées par l'application :
 
- le régime « classique » ne se combine avec aucun autre ;
- les horaires sont cohérents : fermeture après l'ouverture, plages sans chevauchement, deuxième plage seulement si la première existe (RG-38) ;
- les statuts d'une commande suivent l'ordre de RG-20, et une commande ne peut être modifiée par le client qu'au statut « en attente » (RG-22) ;
- l'accord du client est obligatoire pour une modification et vide pour une annulation (RG-23) ;
- un motif est obligatoire pour refuser ou retirer un avis ; seul un avis validé peut être retiré, et seul un avis refusé peut être revalidé (RG-28) ;
- un avis n'est possible que sur une commande terminée (RG-26), avec une note de 1 à 5 (RG-27) ;
- un menu a une seule photo principale, et au moins une photo pour être publié (RG-29) ;
- les montants, quantités et délais sont positifs, et le nombre de personnes d'une commande respecte le minimum du menu ;
- un jeton n'est valable qu'avant son expiration et s'il n'a pas encore été utilisé (RG-33, RG-34) ;
- l'adresse et le numéro de GSM sont obligatoires pour un client et absents pour un employé ;
- il n'existe qu'un seul compte administrateur (RG-12).

### Hors périmètre
 
Les évolutions suivantes ne sont pas demandées et ne sont pas modélisées : disponibilité d'un menu par période, historique des modifications des horaires, détail des valeurs avant et après une modification de commande, historique des désactivations de comptes employés, livraison hors de France.

## Données de la base non relationnelle

### Données stockées

L'expression du besoin impose que les statistiques de l'administrateur proviennent d'une base de données non relationnelle (p. 9). Cette base contient **un document par commande**, qui ne reprend que les informations utiles aux deux statistiques : le nombre de commandes par menu (RG-39) et le chiffre d'affaires par menu (RG-40).

| Champ | Signification | Utilisé pour |
|---|---|---|
| `commande_id` | Identifiant de la commande dans la base relationnelle | Retrouver le document à mettre à jour |
| `menu_id` | Identifiant du menu commandé | Regrouper les commandes par menu, filtrer par menu |
| `menu_titre` | Titre du menu au moment de la commande | Libellé des barres du graphique et des lignes du tableau |
| `date_prestation` | Date de la prestation | Filtrer par période |
| `statut` | Statut actuel de la commande | Écarter les commandes annulées ; distinguer le chiffre d'affaires réalisé et prévisionnel |
| `prix_menu` | Prix du menu validé par le client | Chiffre d'affaires |
| `montant_reduction` | Réduction accordée | Chiffre d'affaires (prix du menu après réduction) |
| `prix_livraison` | Frais de livraison | Ligne séparée du tableau |

Exemple de document :

```json
{
  "commande_id": 42,
  "menu_id": 3,
  "menu_titre": "Menu de Noël",
  "date_prestation": "2026-12-24",
  "statut": "accepté",
  "prix_menu": 675.00,
  "montant_reduction": 67.50,
  "prix_livraison": 0.00
}
```

Le document est créé à la validation d'une commande, puis mis à jour à chaque changement de statut et à chaque modification de la commande.

### Justification

- **Exigence du client** : les statistiques doivent provenir d'une base non relationnelle.
- **Lecture rapide** : chaque document contient déjà tout ce qu'une statistique affiche. Le calcul ne demande aucune jointure entre la commande, son historique de statuts et le menu.
- **Copie volontaire** : le statut actuel et le titre du menu sont recopiés, alors que le modèle relationnel ne les stocke pas en double. Ce n'est pas une redondance du modèle : la base relationnelle reste la seule source de vérité, et la base non relationnelle n'en est qu'une copie destinée à la lecture, mise à jour par l'application.
- **Minimisation des données (RGPD)** : aucune donnée personnelle n'est copiée. Le document ne contient ni le nom du client, ni son adresse, ni ses coordonnées : les statistiques n'en ont pas besoin.
- **Date de prestation** : le filtre par période porte sur la date de la prestation, car un chiffre d'affaires est réalisé lorsque la prestation est livrée (RG-40) ; la même date est utilisée pour les deux statistiques, pour qu'elles restent comparables (interprétation).