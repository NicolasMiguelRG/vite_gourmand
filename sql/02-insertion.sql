-- Insertion des données de démonstration de la base Vite & Gourmand (MariaDB 11.8)
-- À exécuter après 01-creation.sql, sur une base vide.

INSERT INTO role (libelle) VALUES
    ('ROLE_UTILISATEUR'),
    ('ROLE_EMPLOYE'),
    ('ROLE_ADMINISTRATEUR');

INSERT INTO theme (libelle) VALUES
    ('Noël'),
    ('Pâques'),
    ('Classique'),
    ('Événement');

INSERT INTO regime (libelle) VALUES
    ('Classique'),
    ('Végétarien'),
    ('Vegan'),
    ('Pescétarien'),
    ('Sans gluten'),
    ('Sans lactose');

INSERT INTO allergene (libelle) VALUES
    ('Céréales contenant du gluten'),
    ('Crustacés'),
    ('Œufs'),
    ('Poissons'),
    ('Arachides'),
    ('Soja'),
    ('Lait'),
    ('Fruits à coque'),
    ('Céleri'),
    ('Moutarde'),
    ('Graines de sésame'),
    ('Anhydride sulfureux et sulfites'),
    ('Lupin'),
    ('Mollusques');

INSERT INTO utilisateur (nom, prenom, email, telephone, adresse, code_postal, ville, mot_de_passe_hache, date_confirmation, mot_de_passe_provisoire, actif, role_id) VALUES
    ('Martin', 'José', 'jose.martin@example.com', NULL, NULL, NULL, NULL, '$2y$13$9WNtiKYz10A6o2sNC3xNiOpb5aWrVQR/Mk.1LjrFrdg9qvIxsaA8C', '2026-10-01 09:00:00', FALSE, TRUE, 3),
    ('Bernard', 'Julie', 'julie.bernard@example.com', NULL, NULL, NULL, NULL, '$2y$13$ejqrhZN0mYoF2.c08NZZyuZbJW436coh8cJ0X6d8JBWlrbUbkN2LC', '2026-10-01 09:00:00', FALSE, TRUE, 2),
    ('Petit', 'Thomas', 'thomas.petit@example.com', NULL, NULL, NULL, NULL, '$2y$13$8jL3jt5t3Y7E8DZnzyiXje5B42Z/R8jO9bDjDSl8nriEsuQ477A3S', '2026-10-01 09:00:00', FALSE, FALSE, 2),
    ('Dupont', 'Marie', 'marie.dupont@example.com', '0639980101', '15 rue Sainte-Catherine', '33000', 'Bordeaux', '$2y$13$8w7YL1KcA5fBYJZTQeftaOohHIlG6owaBKuOTdAnU9h7OMIceRrh.', '2026-10-01 09:00:00', FALSE, TRUE, 1),
    ('Moreau', 'Lucas', 'lucas.moreau@example.com', '0639980102', '12 avenue de l''Yser', '33700', 'Mérignac', '$2y$13$jxQD1C2/vkAYL9SRYCCHSOu93vPAp4VnKD36edROXxk9TSaDGpM1m', '2026-10-01 09:00:00', FALSE, TRUE, 1);

INSERT INTO menu (titre, description, conditions, nombre_personne_minimum, prix_minimum, stock, statut, delai_minimum_jours, description_materiel, theme_id) VALUES
    ('Menu de Noël traditionnel', 'Courges rôties aux céréales, légumes de saison et bûche glacée, pour un Noël sans viande.', 'À commander au moins 7 jours avant la prestation. À conserver au réfrigérateur et à consommer dans les 24 heures.', 6, 180.00, 10, 'publié', 7, NULL, 1),
    ('Réveillon de Noël', 'Volaille rôtie aux herbes, pommes de terre dorées et choux de Bruxelles, comme à la maison.', 'À commander au moins 10 jours avant la prestation. À conserver au réfrigérateur et à consommer dans les 24 heures.', 8, 240.00, 0, 'publié', 10, NULL, 1),
    ('Noël en famille', 'Filet de bœuf en croûte d''épices, gratin de pommes de terre et légumes rôtis, à partager en famille.', 'À commander au moins 10 jours avant la prestation. À conserver au réfrigérateur et à consommer dans les 24 heures.', 10, 280.00, 5, 'publié', 10, NULL, 1),
    ('Brunch de Pâques', 'Œufs brouillés aux herbes, quiche aux asperges et gâteau au chocolat, pour un brunch de Pâques convivial.', 'À commander au moins 5 jours avant la prestation. À conserver au réfrigérateur et à consommer dans les 24 heures.', 8, 160.00, 8, 'publié', 5, NULL, 2),
    ('Buffet d''entreprise', 'Pièces salées, plateau de fromages et mignardises, servis en buffet pour vos événements professionnels.', 'À commander au moins 14 jours avant la prestation. À conserver au réfrigérateur et à consommer dans les 24 heures. Le matériel prêté doit être restitué selon les conditions générales de vente.', 15, 375.00, 6, 'publié', 14, 'Deux chauffe-plats et quatre plateaux de service.', 4),
    ('Menu du terroir', 'Pâté de campagne, blanquette de veau et tarte aux pommes, une cuisine simple et généreuse.', 'À commander au moins 3 jours avant la prestation. À conserver au réfrigérateur et à consommer dans les 24 heures.', 4, 120.00, 0, 'archivé', 3, NULL, 3),
    ('Menu vegan de printemps', 'Velouté de petits pois, curry de légumes de printemps et salade de fruits frais, sans aucun produit d''origine animale.', 'À commander au moins 5 jours avant la prestation. À conserver au réfrigérateur et à consommer dans les 24 heures.', 6, 150.00, 0, 'brouillon', 5, NULL, 3);

INSERT INTO photo (chemin_fichier, texte_alternatif, est_principale, menu_id) VALUES
    ('menu-noel-traditionnel-1.jpg', 'Courges rôties farcies aux céréales sur un plat de service', TRUE, 1),
    ('menu-noel-traditionnel-2.jpg', 'Part de bûche glacée sur une assiette', FALSE, 1),
    ('reveillon-de-noel.jpg', 'Volaille rôtie aux herbes entourée de pommes de terre dorées', TRUE, 2),
    ('noel-en-famille.jpg', 'Table de fête dressée pour un repas de Noël en famille', TRUE, 3),
    ('brunch-de-paques.jpg', 'Table de brunch avec œufs brouillés, quiche et gâteau au chocolat', TRUE, 4),
    ('buffet-entreprise.jpg', 'Buffet de pièces salées et plateau de fromages', TRUE, 5),
    ('menu-du-terroir.jpg', 'Blanquette de veau servie dans une cocotte', TRUE, 6);

INSERT INTO plat (nom, categorie, chemin_photo, texte_alternatif_photo, description_materiel) VALUES
    ('Velouté de potimarron', 'entrée', NULL, NULL, NULL),
    ('Courges rôties aux céréales', 'plat', NULL, NULL, NULL),
    ('Bûche glacée', 'dessert', 'buche-glacee.jpg', 'Bûche glacée décorée de fruits rouges', NULL),
    ('Saumon fumé et blinis', 'entrée', NULL, NULL, NULL),
    ('Volaille rôtie aux herbes', 'plat', NULL, NULL, NULL),
    ('Filet de bœuf en croûte d''épices', 'plat', NULL, NULL, NULL),
    ('Œufs brouillés aux herbes', 'entrée', NULL, NULL, NULL),
    ('Quiche aux asperges', 'plat', NULL, NULL, NULL),
    ('Gâteau au chocolat', 'dessert', NULL, NULL, NULL),
    ('Pièces salées assorties', 'entrée', NULL, NULL, NULL),
    ('Plateau de fromages', 'plat', NULL, NULL, 'Planche à fromages en bois.'),
    ('Mignardises', 'dessert', NULL, NULL, NULL),
    ('Pâté de campagne', 'entrée', NULL, NULL, NULL),
    ('Blanquette de veau', 'plat', NULL, NULL, NULL),
    ('Tarte aux pommes', 'dessert', NULL, NULL, NULL),
    ('Velouté de petits pois', 'entrée', NULL, NULL, NULL),
    ('Curry de légumes de printemps', 'plat', NULL, NULL, NULL),
    ('Salade de fruits frais', 'dessert', NULL, NULL, NULL);

INSERT INTO propose (menu_id, plat_id) VALUES
    (1, 1), (1, 2), (1, 3),
    (2, 4), (2, 5), (2, 3),
    (3, 1), (3, 6), (3, 3),
    (4, 7), (4, 8), (4, 9),
    (5, 10), (5, 11), (5, 12),
    (6, 13), (6, 14), (6, 15),
    (7, 16), (7, 17), (7, 18);

INSERT INTO adapte (menu_id, regime_id) VALUES
    (1, 2), (2, 1), (3, 1),
    (4, 2), (5, 1), (6, 1),
    (7, 3), (7, 2), (7, 6);

-- Allergènes des plats (exemples plausibles, à remplacer par les fiches du traiteur)
-- Plats 5 (volaille) et 18 (salade de fruits) : aucun allergène, donc aucune ligne.
INSERT INTO contient (plat_id, allergene_id) VALUES
    (1, 7), (1, 9),
    (2, 1), (2, 8),
    (3, 3), (3, 7),
    (4, 1), (4, 3), (4, 4), (4, 7),
    (6, 1), (6, 10),
    (7, 3), (7, 7),
    (8, 1), (8, 3), (8, 7),
    (9, 1), (9, 3), (9, 7),
    (10, 1), (10, 3), (10, 7), (10, 11),
    (11, 7),
    (12, 1), (12, 3), (12, 7), (12, 8),
    (13, 3), (13, 12),
    (14, 1), (14, 7), (14, 9),
    (15, 1), (15, 3), (15, 7),
    (16, 9),
    (17, 6), (17, 8);

-- Commandes d'exemple, dans l'ordre où elles ont été passées.
-- Prix figés (RG-35) : prix du menu = prix minimum ÷ nombre minimum × personnes (RG-14) ;
-- réduction de 10 % dès le minimum + 5 personnes (RG-15) ;
-- livraison gratuite à Bordeaux, 5 € + 0,59 €/km ailleurs : Mérignac à 20 km = 16,80 € (RG-16).
--  1. Lucas, Buffet d'entreprise, 20 pers. : terminée (matériel rendu), avis refusé
--  2. Marie, Menu du terroir, 4 pers. : terminée, avis validé
--  3. Marie, Buffet d'entreprise, 15 pers. : terminée (matériel rendu), avis validé
--  4. Marie, Menu du terroir, 6 pers. : terminée, avis en attente
--  5. Marie, Réveillon de Noël, 8 pers. : annulée par un employé après contact
--  6. Lucas, Buffet d'entreprise, 15 pers. : livrée
--  7. Marie, Noël en famille, 10 pers. : acceptée, modifiée par un employé après contact
--  8. Lucas, Menu de Noël traditionnel, 12 pers. : en attente, modifiée par le client
INSERT INTO commande (numero_commande, date_prestation, heure_livraison, nombre_personne, adresse_prestation, code_postal_prestation, ville_prestation, prix_menu, montant_reduction, prix_livraison, description_materiel_menu, utilisateur_id, menu_id) VALUES
    ('VG-2026-0001', '2026-10-16', '11:30:00', 20, '12 avenue de l''Yser', '33700', 'Mérignac', 500.00, 50.00, 16.80, 'Deux chauffe-plats et quatre plateaux de service.', 5, 5),
    ('VG-2026-0002', '2026-10-10', '12:00:00', 4, '15 rue Sainte-Catherine', '33000', 'Bordeaux', 120.00, 0.00, 0.00, NULL, 4, 6),
    ('VG-2026-0003', '2026-11-14', '11:30:00', 15, '15 rue Sainte-Catherine', '33000', 'Bordeaux', 375.00, 0.00, 0.00, 'Deux chauffe-plats et quatre plateaux de service.', 4, 5),
    ('VG-2026-0004', '2026-11-07', '12:00:00', 6, '15 rue Sainte-Catherine', '33000', 'Bordeaux', 180.00, 0.00, 0.00, NULL, 4, 6),
    ('VG-2026-0005', '2026-12-24', '19:00:00', 8, '15 rue Sainte-Catherine', '33000', 'Bordeaux', 240.00, 0.00, 0.00, NULL, 4, 2),
    ('VG-2026-0006', '2026-11-27', '11:30:00', 15, '12 avenue de l''Yser', '33700', 'Mérignac', 375.00, 0.00, 16.80, 'Deux chauffe-plats et quatre plateaux de service.', 5, 5),
    ('VG-2026-0007', '2026-12-25', '11:30:00', 10, '15 rue Sainte-Catherine', '33000', 'Bordeaux', 280.00, 0.00, 0.00, NULL, 4, 3),
    ('VG-2026-0008', '2026-12-20', '12:00:00', 12, '12 avenue de l''Yser', '33700', 'Mérignac', 360.00, 36.00, 16.80, NULL, 5, 1);

-- Composition figée de chaque commande (copie des plats du menu à la validation, RG-35)
INSERT INTO plat_commande (nom, categorie, description_materiel, commande_id) VALUES
    ('Pièces salées assorties', 'entrée', NULL, 1),
    ('Plateau de fromages', 'plat', 'Planche à fromages en bois.', 1),
    ('Mignardises', 'dessert', NULL, 1),
    ('Pâté de campagne', 'entrée', NULL, 2),
    ('Blanquette de veau', 'plat', NULL, 2),
    ('Tarte aux pommes', 'dessert', NULL, 2),
    ('Pièces salées assorties', 'entrée', NULL, 3),
    ('Plateau de fromages', 'plat', 'Planche à fromages en bois.', 3),
    ('Mignardises', 'dessert', NULL, 3),
    ('Pâté de campagne', 'entrée', NULL, 4),
    ('Blanquette de veau', 'plat', NULL, 4),
    ('Tarte aux pommes', 'dessert', NULL, 4),
    ('Saumon fumé et blinis', 'entrée', NULL, 5),
    ('Volaille rôtie aux herbes', 'plat', NULL, 5),
    ('Bûche glacée', 'dessert', NULL, 5),
    ('Pièces salées assorties', 'entrée', NULL, 6),
    ('Plateau de fromages', 'plat', 'Planche à fromages en bois.', 6),
    ('Mignardises', 'dessert', NULL, 6),
    ('Velouté de potimarron', 'entrée', NULL, 7),
    ('Filet de bœuf en croûte d''épices', 'plat', NULL, 7),
    ('Bûche glacée', 'dessert', NULL, 7),
    ('Velouté de potimarron', 'entrée', NULL, 8),
    ('Courges rôties aux céréales', 'plat', NULL, 8),
    ('Bûche glacée', 'dessert', NULL, 8);

-- Allergènes figés de chaque plat commandé (mêmes allergènes que le plat d'origine)
INSERT INTO contient_fige (plat_commande_id, allergene_id) VALUES
    (1, 1), (1, 3), (1, 7), (1, 11),
    (2, 7),
    (3, 1), (3, 3), (3, 7), (3, 8),
    (4, 3), (4, 12),
    (5, 1), (5, 7), (5, 9),
    (6, 1), (6, 3), (6, 7),
    (7, 1), (7, 3), (7, 7), (7, 11),
    (8, 7),
    (9, 1), (9, 3), (9, 7), (9, 8),
    (10, 3), (10, 12),
    (11, 1), (11, 7), (11, 9),
    (12, 1), (12, 3), (12, 7),
    (13, 1), (13, 3), (13, 4), (13, 7),
    (15, 3), (15, 7),
    (16, 1), (16, 3), (16, 7), (16, 11),
    (17, 7),
    (18, 1), (18, 3), (18, 7), (18, 8),
    (19, 7), (19, 9),
    (20, 1), (20, 10),
    (21, 3), (21, 7),
    (22, 7), (22, 9),
    (23, 1), (23, 8),
    (24, 3), (24, 7);

-- Historique des statuts (RG-19 à RG-21, RG-36).
-- « en attente » est créé automatiquement à la commande : aucun employé (utilisateur_id NULL).
-- Les autres changements sont faits par Julie (2) ou José (1).
INSERT INTO changement_statut (statut, date_heure, commande_id, utilisateur_id) VALUES
    ('en attente', '2026-10-01 10:00:00', 1, NULL),
    ('accepté', '2026-10-01 14:00:00', 1, 2),
    ('en préparation', '2026-10-16 08:00:00', 1, 2),
    ('en cours de livraison', '2026-10-16 10:30:00', 1, 2),
    ('livré', '2026-10-16 11:15:00', 1, 2),
    ('en attente du retour de matériel', '2026-10-16 11:20:00', 1, 2),
    ('terminée', '2026-10-20 16:00:00', 1, 2),

    ('en attente', '2026-10-02 09:30:00', 2, NULL),
    ('accepté', '2026-10-02 15:00:00', 2, 2),
    ('en préparation', '2026-10-10 08:00:00', 2, 2),
    ('en cours de livraison', '2026-10-10 11:00:00', 2, 2),
    ('livré', '2026-10-10 11:45:00', 2, 2),
    ('terminée', '2026-10-10 11:50:00', 2, 2),

    ('en attente', '2026-10-28 18:00:00', 3, NULL),
    ('accepté', '2026-10-29 09:00:00', 3, 1),
    ('en préparation', '2026-11-14 08:00:00', 3, 2),
    ('en cours de livraison', '2026-11-14 10:30:00', 3, 2),
    ('livré', '2026-11-14 11:20:00', 3, 2),
    ('en attente du retour de matériel', '2026-11-14 11:25:00', 3, 2),
    ('terminée', '2026-11-18 15:00:00', 3, 1),

    ('en attente', '2026-11-01 20:00:00', 4, NULL),
    ('accepté', '2026-11-02 09:00:00', 4, 2),
    ('en préparation', '2026-11-07 08:00:00', 4, 2),
    ('en cours de livraison', '2026-11-07 11:00:00', 4, 2),
    ('livré', '2026-11-07 11:40:00', 4, 2),
    ('terminée', '2026-11-07 11:45:00', 4, 2),

    ('en attente', '2026-11-10 11:00:00', 5, NULL),
    ('annulée', '2026-11-12 10:15:00', 5, 2),

    ('en attente', '2026-11-10 15:00:00', 6, NULL),
    ('accepté', '2026-11-11 09:00:00', 6, 2),
    ('en préparation', '2026-11-27 08:00:00', 6, 2),
    ('en cours de livraison', '2026-11-27 10:30:00', 6, 2),
    ('livré', '2026-11-27 11:15:00', 6, 2),

    ('en attente', '2026-11-20 19:00:00', 7, NULL),
    ('accepté', '2026-11-21 09:30:00', 7, 2),

    ('en attente', '2026-11-25 21:00:00', 8, NULL);

-- Modifications enregistrées : commande 7 par Julie (après contact), commande 8 par le client lui-même (NULL)
INSERT INTO modification (date_heure, commande_id, utilisateur_id) VALUES
    ('2026-11-22 10:05:00', 7, 2),
    ('2026-11-26 08:30:00', 8, NULL);

-- Contacts du client avant une modification ou une annulation par un employé (RG-23)
-- accord_client : obligatoire pour une modification, vide (NULL) pour une annulation
INSERT INTO contact (objet, mode, motif, date_heure, accord_client, utilisateur_id, commande_id) VALUES
    ('annulation', 'GSM', 'Fermeture exceptionnelle le 24 décembre : l''entreprise ne peut pas assurer la prestation.', '2026-11-12 10:00:00', NULL, 2, 5),
    ('modification', 'mail', 'Heure de livraison avancée à 11 h 30 pour organiser les tournées du 25 décembre.', '2026-11-22 10:00:00', TRUE, 2, 7);

-- Avis sur les commandes terminées (RG-26, RG-27)
INSERT INTO avis (note, commentaire, date_depot, commande_id) VALUES
    (1, 'Livreur très désagréable. Appelez-moi au 06 39 98 01 02 pour que je vous dise ce que j''en pense.', '2026-10-21 08:00:00', 1),
    (5, 'Repas délicieux et livré à l''heure, toute la famille a apprécié la blanquette.', '2026-10-11 10:00:00', 2),
    (4, 'Buffet copieux et bien présenté, le matériel était pratique. Un peu plus de choix dans les mignardises serait un plus.', '2026-11-19 09:00:00', 3),
    (4, 'Très bon pâté de campagne et des portions généreuses.', '2026-11-08 12:00:00', 4);

-- Décisions de modération (RG-28). L'avis 4 n'a aucune décision : il est en attente.
INSERT INTO decision_moderation (decision, motif, date_heure, utilisateur_id, avis_id) VALUES
    ('refusé', 'Le commentaire contient un numéro de téléphone et vise personnellement un membre de l''équipe.', '2026-10-21 10:00:00', 2, 1),
    ('validé', NULL, '2026-10-12 09:00:00', 2, 2),
    ('validé', NULL, '2026-11-19 14:00:00', 1, 3);

-- Horaires d'ouverture (RG-38) : deux plages le samedi, dimanche fermé (première plage vide)
INSERT INTO horaire (jour, ouverture_1, fermeture_1, ouverture_2, fermeture_2) VALUES
    ('lundi', '09:00:00', '18:00:00', NULL, NULL),
    ('mardi', '09:00:00', '18:00:00', NULL, NULL),
    ('mercredi', '09:00:00', '18:00:00', NULL, NULL),
    ('jeudi', '09:00:00', '18:00:00', NULL, NULL),
    ('vendredi', '09:00:00', '18:00:00', NULL, NULL),
    ('samedi', '09:00:00', '12:00:00', '14:00:00', '18:00:00'),
    ('dimanche', NULL, NULL, NULL, NULL);