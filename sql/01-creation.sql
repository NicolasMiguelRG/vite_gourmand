-- Création des tables de la base Vite & Gourmand (MariaDB 11.8)

CREATE TABLE role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE theme (
    theme_id INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE regime (
    regime_id INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE allergene (
    allergene_id INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE utilisateur (
    utilisateur_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telephone VARCHAR(20),
    adresse VARCHAR(255),
    code_postal VARCHAR(5),
    ville VARCHAR(100),
    mot_de_passe_hache VARCHAR(255) NOT NULL,
    date_confirmation DATETIME,
    mot_de_passe_provisoire BOOLEAN NOT NULL DEFAULT FALSE,
    actif BOOLEAN NOT NULL DEFAULT TRUE,
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES role(role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE jeton (
    jeton_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(255) NOT NULL,
    type VARCHAR(20) NOT NULL,
    date_expiration DATETIME NOT NULL,
    date_utilisation DATETIME,
    utilisateur_id INT NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE menu (
    menu_id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    conditions TEXT NOT NULL,
    nombre_personne_minimum INT NOT NULL,
    prix_minimum DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    statut VARCHAR(10) NOT NULL DEFAULT 'brouillon',
    delai_minimum_jours INT NOT NULL,
    description_materiel TEXT,
    theme_id INT NOT NULL,
    FOREIGN KEY (theme_id) REFERENCES theme(theme_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE photo (
    photo_id INT AUTO_INCREMENT PRIMARY KEY,
    chemin_fichier VARCHAR(255) NOT NULL,
    texte_alternatif VARCHAR(255) NOT NULL,
    est_principale BOOLEAN NOT NULL DEFAULT FALSE,
    menu_id INT NOT NULL,
    FOREIGN KEY (menu_id) REFERENCES menu(menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE plat (
    plat_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    categorie VARCHAR(10) NOT NULL,
    chemin_photo VARCHAR(255),
    texte_alternatif_photo VARCHAR(255),
    description_materiel TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE propose (
    menu_id INT NOT NULL,
    plat_id INT NOT NULL,
    PRIMARY KEY (menu_id, plat_id),
    FOREIGN KEY (menu_id) REFERENCES menu(menu_id),
    FOREIGN KEY (plat_id) REFERENCES plat(plat_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE adapte (
    menu_id INT NOT NULL,
    regime_id INT NOT NULL,
    PRIMARY KEY (menu_id, regime_id),
    FOREIGN KEY (menu_id) REFERENCES menu(menu_id),
    FOREIGN KEY (regime_id) REFERENCES regime(regime_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE contient (
    plat_id INT NOT NULL,
    allergene_id INT NOT NULL,
    PRIMARY KEY (plat_id, allergene_id),
    FOREIGN KEY (plat_id) REFERENCES plat(plat_id),
    FOREIGN KEY (allergene_id) REFERENCES allergene(allergene_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE commande (
    commande_id INT AUTO_INCREMENT PRIMARY KEY,
    numero_commande VARCHAR(20) NOT NULL UNIQUE,
    date_prestation DATE NOT NULL,
    heure_livraison TIME NOT NULL,
    nombre_personne INT NOT NULL,
    adresse_prestation VARCHAR(255) NOT NULL,
    code_postal_prestation VARCHAR(5) NOT NULL,
    ville_prestation VARCHAR(100) NOT NULL,
    prix_menu DECIMAL(10,2) NOT NULL,
    montant_reduction DECIMAL(10,2) NOT NULL DEFAULT 0,
    prix_livraison DECIMAL(10,2) NOT NULL DEFAULT 0,
    description_materiel_menu TEXT,
    utilisateur_id INT NOT NULL,
    menu_id INT NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id),
    FOREIGN KEY (menu_id) REFERENCES menu(menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE plat_commande (
    plat_commande_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    categorie VARCHAR(10) NOT NULL,
    description_materiel TEXT,
    commande_id INT NOT NULL,
    FOREIGN KEY (commande_id) REFERENCES commande(commande_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE contient_fige (
    plat_commande_id INT NOT NULL,
    allergene_id INT NOT NULL,
    PRIMARY KEY (plat_commande_id, allergene_id),
    FOREIGN KEY (plat_commande_id) REFERENCES plat_commande(plat_commande_id),
    FOREIGN KEY (allergene_id) REFERENCES allergene(allergene_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE changement_statut (
    changement_statut_id INT AUTO_INCREMENT PRIMARY KEY,
    statut VARCHAR(40) NOT NULL,
    date_heure DATETIME NOT NULL,
    commande_id INT NOT NULL,
    utilisateur_id INT,
    FOREIGN KEY (commande_id) REFERENCES commande(commande_id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE modification (
    modification_id INT AUTO_INCREMENT PRIMARY KEY,
    date_heure DATETIME NOT NULL,
    commande_id INT NOT NULL,
    utilisateur_id INT,
    FOREIGN KEY (commande_id) REFERENCES commande(commande_id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE contact (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    objet VARCHAR(15) NOT NULL,
    mode VARCHAR(5) NOT NULL,
    motif TEXT NOT NULL,
    date_heure DATETIME NOT NULL,
    accord_client BOOLEAN,
    utilisateur_id INT NOT NULL,
    commande_id INT NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id),
    FOREIGN KEY (commande_id) REFERENCES commande(commande_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE avis (
    avis_id INT AUTO_INCREMENT PRIMARY KEY,
    note INT NOT NULL,
    commentaire TEXT NOT NULL,
    date_depot DATETIME NOT NULL,
    commande_id INT NOT NULL UNIQUE,
    FOREIGN KEY (commande_id) REFERENCES commande(commande_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE decision_moderation (
    decision_moderation_id INT AUTO_INCREMENT PRIMARY KEY,
    decision VARCHAR(10) NOT NULL,
    motif TEXT,
    date_heure DATETIME NOT NULL,
    utilisateur_id INT NOT NULL,
    avis_id INT NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id),
    FOREIGN KEY (avis_id) REFERENCES avis(avis_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE horaire (
    horaire_id INT AUTO_INCREMENT PRIMARY KEY,
    jour VARCHAR(10) NOT NULL UNIQUE,
    ouverture_1 TIME,
    fermeture_1 TIME,
    ouverture_2 TIME,
    fermeture_2 TIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;