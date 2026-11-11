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

| Acteur | Type | Hérite de |
| --- | --- | --- |
| Visiteur | Principal | — |
| Utilisateur | Principal | Visiteur |
| Employé | Principal | Visiteur |
| Administrateur | Principal | Employé |
| Service d'envoi de mails | Secondaire | — |

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

L'employé hérite des cas d'utilisation de l'espace public. À sa première connexion, il doit remplacer le mot de passe provisoire fourni par l'administrateur par un mot de passe personnel ; un mail d'alerte confirme ce changement. Il gère les menus (création, modification, suppression sous forme d'archivage) et les publie pour les rendre visibles aux clients, à condition qu'ils comportent au moins une photo. Il gère aussi les plats et leurs allergènes, les régimes et les thèmes proposés, et modifie les horaires d'ouverture. Il consulte les commandes, qu'il peut filtrer par statut ou par client, et fait évoluer leur statut ; certains changements déclenchent l'envoi d'un mail au client par le service d'envoi de mails : rappel des conditions de restitution du matériel, puis invitation à donner son avis lorsque la commande est terminée. Il ne peut modifier ou annuler la commande d'un client qu'après l'avoir contacté, en renseignant obligatoirement le mode de contact (GSM ou mail) et le motif ; le client reçoit ensuite un mail récapitulatif avec le nouveau prix, ou un mail l'informant de l'annulation et de son motif. Enfin, il modère les avis laissés par les utilisateurs, en les validant ou en les refusant, et peut retirer un avis déjà validé ; un refus ou un retrait exige un motif, communiqué au client par mail.

### Espace administrateur

![Diagramme de cas d'utilisation de l'espace administrateur](images/conception/cas-utilisation-administrateur.png)

L'administrateur hérite de l'ensemble des cas d'utilisation de l'espace employé. Il crée les comptes employés à partir du nom, du prénom et de l'adresse mail de l'employé ; un mot de passe provisoire est généré automatiquement, et l'employé est informé de la création de son compte par un mail envoyé par le service d'envoi de mails, qui ne contient jamais le mot de passe. Il peut désactiver un compte employé, par exemple en cas de départ de l'entreprise, puis le réactiver si besoin avec un nouveau mot de passe provisoire. Il peut aussi consulter l'historique des actions d'un employé. Il consulte enfin les statistiques de l'activité : le nombre de commandes par menu, hors commandes annulées, présenté sous forme de graphique comparatif et filtrable par période, et le chiffre d'affaires par menu, réalisé et prévisionnel, qu'il peut filtrer par menu et par période. Le compte administrateur unique est créé par le développeur : aucun compte administrateur ne peut être créé depuis l'application.


## Diagramme de séquence
## Modèle conceptuel de données

### Dictionnaire des données

Le dictionnaire recense toutes les données que l'application doit conserver, à partir des spécifications fonctionnelles, des règles de gestion et des user stories du [cahier des charges](02-cahier-des-charges.md). Il a été épuré avant la modélisation : il ne contient que des données élémentaires, sans donnée calculée ni redondante. Les données retirées de l'annexe sont justifiées dans le tableau des corrections.

**Types** : AN = alphanumérique (texte) · N = numérique · D = date · H = heure · DH = date et heure · B = booléen (oui / non).
**Taille** : nombre maximum de caractères pour un texte ; « texte long » pour un texte libre sans limite précise ; « 2 décimales » pour un montant en euros.
Les numéros de téléphone et les codes postaux sont de type AN : on ne fait aucun calcul avec, et ils peuvent commencer par 0.

**utilisateur**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `utilisateur_id` | Identifiant de l'utilisateur | N | — | Unique, attribué automatiquement | — |
| `nom` | Nom de famille | AN | 50 | Obligatoire | Story 6, story 35 |
| `prenom` | Prénom | AN | 50 | Obligatoire | Story 6, story 35 |
| `email` | Adresse mail, utilisée pour se connecter | AN | 255 | Obligatoire, unique | RG-08 |
| `telephone` | Numéro de GSM | AN | 20 | Obligatoire pour un client, vide pour un employé | Story 6, story 35 |
| `adresse` | Numéro et nom de la rue | AN | 255 | Obligatoire pour un client, vide pour un employé | Story 6 |
| `code_postal` | Code postal | AN | 5 | Obligatoire pour un client, vide pour un employé | Story 6 |
| `ville` | Ville | AN | 100 | Obligatoire pour un client, vide pour un employé | Story 6 |
| `mot_de_passe_hache` | Empreinte du mot de passe (jamais le mot de passe en clair) | AN | 255 | Obligatoire | RG-07, story 6 |
| `date_confirmation` | Date et heure de confirmation de l'adresse mail | DH | — | Vide = compte non confirmé ; remplie dès la création pour un employé | RG-33 |
| `mot_de_passe_provisoire` | Le mot de passe doit être changé à la prochaine connexion | B | — | Oui à la création et à la réactivation d'un compte employé | RG-10 bis, RG-11 |
| `actif` | Le compte peut se connecter | B | — | Non = compte désactivé | RG-11 |

**role**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `role_id` | Identifiant du rôle | N | — | Unique, attribué automatiquement | — |
| `libelle` | Nom du rôle | AN | 20 | utilisateur / employé / administrateur | RG-09, RG-10, RG-12 |

**menu**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `menu_id` | Identifiant du menu | N | — | Unique, attribué automatiquement | — |
| `titre` | Titre du menu | AN | 100 | Obligatoire | Story 22 |
| `description` | Description du menu | AN | texte long | Obligatoire | Story 22 |
| `conditions` | Conditions du menu (délai, matériel à restituer…) | AN | texte long | Obligatoire | Story 5, story 22 |
| `nombre_personne_minimum` | Nombre minimum de personnes | N | — | Entier ≥ 1 | RG-05, RG-13 |
| `prix_minimum` | Prix du menu pour le nombre minimum de personnes | N | 2 décimales | > 0 | RG-05 |
| `stock` | Nombre de commandes encore possibles | N | — | Entier ≥ 0 | RG-06 |
| `statut` | État de publication du menu | AN | 10 | brouillon / publié / archivé | RG-29 |
| `delai_minimum_jours` | Délai minimum entre la commande et la prestation, en jours | N | — | Entier ≥ 0 | RG-30 |
| `description_materiel` | Description du matériel prêté avec le menu | AN | texte long | Facultatif ; vide = pas de matériel | RG-31 |

**theme**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `theme_id` | Identifiant du thème | N | — | Unique, attribué automatiquement | — |
| `libelle` | Nom du thème | AN | 50 | Unique ; au départ : Noël, Pâques, classique, événement | RG-01, story 39 |

**regime**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `regime_id` | Identifiant du régime | N | — | Unique, attribué automatiquement | — |
| `libelle` | Nom du régime | AN | 50 | Unique ; au départ : classique, végétarien, vegan, pescétarien, sans gluten, sans lactose | RG-02, story 39 |

**plat**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `plat_id` | Identifiant du plat | N | — | Unique, attribué automatiquement | — |
| `nom` | Nom du plat | AN | 100 | Obligatoire | Story 26 |
| `categorie` | Catégorie du plat | AN | 10 | entrée / plat / dessert | RG-03 |
| `chemin_photo` | Emplacement du fichier de la photo sur le serveur | AN | 255 | Facultatif | Story 26, RG-32 |
| `texte_alternatif_photo` | Description de la photo pour les lecteurs d'écran | AN | 255 | Obligatoire si une photo est présente | Story 26 (RGAA) |
| `description_materiel` | Description du matériel prêté avec le plat | AN | texte long | Facultatif ; vide = pas de matériel | RG-31 |

**allergene**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `allergene_id` | Identifiant de l'allergène | N | — | Unique, attribué automatiquement | — |
| `libelle` | Nom de l'allergène | AN | 50 | Les 14 allergènes du règlement INCO, liste fixe | RG-04 |

**photo** (galerie d'un menu)

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `photo_id` | Identifiant de la photo | N | — | Unique, attribué automatiquement | — |
| `chemin_fichier` | Emplacement du fichier sur le serveur | AN | 255 | Obligatoire | Story 25, RG-32 |
| `texte_alternatif` | Description de la photo pour les lecteurs d'écran | AN | 255 | Obligatoire | Story 25 (RGAA) |
| `est_principale` | Photo affichée en premier | B | — | Une seule photo principale par menu | Story 25 |

**commande**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `commande_id` | Identifiant de la commande | N | — | Unique, attribué automatiquement | — |
| `numero_commande` | Numéro communiqué au client (mails, bon de livraison) | AN | 20 | Unique | Story 31, story 41 |
| `date_prestation` | Date de la prestation | D | — | Respecte le délai minimum du menu | Story 13, RG-30 |
| `heure_livraison` | Heure de livraison souhaitée | H | — | Obligatoire | Story 13 |
| `nombre_personne` | Nombre de personnes | N | — | Entier ≥ minimum du menu | RG-13 |
| `adresse_prestation` | Numéro et nom de la rue de la prestation | AN | 255 | Obligatoire | Story 13 |
| `code_postal_prestation` | Code postal de la prestation | AN | 5 | Obligatoire | Story 13 |
| `ville_prestation` | Ville de la prestation | AN | 100 | Obligatoire | Story 13, RG-16 |
| `prix_menu` | Prix du menu validé par le client | N | 2 décimales | Figé à la validation | RG-14, RG-35 |
| `montant_reduction` | Montant de la réduction accordée | N | 2 décimales | 0 si aucune réduction ; figé | RG-15, RG-35 |
| `prix_livraison` | Frais de livraison | N | 2 décimales | 0 dans Bordeaux ; figé | RG-16, RG-35 |
| `description_materiel_menu` | Matériel prêté avec le menu au moment de la commande | AN | texte long | Facultatif ; figé | RG-31, RG-35 |

**plat_commande** (copie des plats à la validation de la commande)

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `plat_commande_id` | Identifiant du plat commandé | N | — | Unique, attribué automatiquement | — |
| `nom` | Nom du plat au moment de la commande | AN | 100 | Obligatoire | RG-35 |
| `categorie` | Catégorie du plat au moment de la commande | AN | 10 | entrée / plat / dessert | RG-03, RG-35 |
| `description_materiel` | Matériel prêté avec le plat au moment de la commande | AN | texte long | Facultatif | RG-31, RG-35 |

**changement_statut** (historique des statuts d'une commande)

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `changement_statut_id` | Identifiant du changement | N | — | Unique, attribué automatiquement | — |
| `statut` | Nouveau statut de la commande | AN | 40 | en attente / accepté / en préparation / en cours de livraison / livré / en attente du retour de matériel / terminée / annulée | RG-19, RG-20, RG-36 |
| `date_heure` | Date et heure du changement | DH | — | Obligatoire | RG-21 |

**contact** (contact du client par un employé)

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `contact_id` | Identifiant du contact | N | — | Unique, attribué automatiquement | — |
| `objet` | Raison du contact | AN | 15 | modification / annulation | RG-23 |
| `mode` | Moyen de contact | AN | 5 | GSM / mail | RG-23 |
| `motif` | Motif de la modification ou de l'annulation | AN | texte long | Obligatoire | RG-23 |
| `date_heure` | Date et heure du contact | DH | — | Obligatoire | RG-23 |
| `accord_client` | Le client a donné son accord | B | — | Obligatoire pour une modification, vide pour une annulation | RG-23 |

**modification** (modification enregistrée d'une commande)

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `modification_id` | Identifiant de la modification | N | — | Unique, attribué automatiquement | — |
| `date_heure` | Date et heure de la modification | DH | — | Obligatoire | Story 17, story 32 |

**avis**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `avis_id` | Identifiant de l'avis | N | — | Unique, attribué automatiquement | — |
| `note` | Note donnée par le client | N | — | Entier de 1 à 5 | RG-27 |
| `commentaire` | Commentaire du client | AN | texte long | Obligatoire | RG-27 |
| `date_depot` | Date et heure d'envoi de l'avis | DH | — | Obligatoire | Story 34 |

**decision_moderation**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `decision_moderation_id` | Identifiant de la décision | N | — | Unique, attribué automatiquement | — |
| `decision` | Décision prise sur l'avis | AN | 10 | validé / refusé / retiré | RG-28 |
| `motif` | Motif du refus ou du retrait | AN | texte long | Obligatoire pour refusé et retiré, vide pour validé | RG-28 |
| `date_heure` | Date et heure de la décision | DH | — | Obligatoire | Story 34 |

**jeton** (lien personnel envoyé par mail)

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `jeton_id` | Identifiant du jeton | N | — | Unique, attribué automatiquement | — |
| `code` | Empreinte du code contenu dans le lien (jamais le code en clair) | AN | 255 | Obligatoire | RG-33, RG-34 |
| `type` | Usage du lien | AN | 20 | confirmation / réinitialisation | RG-33, RG-34 |
| `date_expiration` | Date et heure au-delà desquelles le lien ne fonctionne plus | DH | — | Réinitialisation : 1 heure après l'envoi | RG-33, RG-34 |
| `date_utilisation` | Date et heure d'utilisation du lien | DH | — | Vide = pas encore utilisé ; usage unique | RG-33, RG-34 |

**horaire**

| Code | Signification | Type | Taille | Valeurs possibles / contrainte | Source |
|---|---|---|---|---|---|
| `horaire_id` | Identifiant de la ligne d'horaires | N | — | Unique, attribué automatiquement | — |
| `jour` | Jour de la semaine | AN | 10 | lundi à dimanche, une ligne par jour | RG-38 |
| `ouverture_1` | Heure d'ouverture de la première plage | H | — | Vide = jour fermé | RG-38 |
| `fermeture_1` | Heure de fermeture de la première plage | H | — | Postérieure à `ouverture_1` | RG-38 |
| `ouverture_2` | Heure d'ouverture de la deuxième plage | H | — | Facultative | RG-38 |
| `fermeture_2` | Heure de fermeture de la deuxième plage | H | — | Postérieure à `ouverture_2`, sans chevauchement | RG-38 |