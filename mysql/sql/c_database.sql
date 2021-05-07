DROP TABLE IF EXISTS User;

CREATE TABLE User (
    id_user int PRIMARY KEY auto_increment,
    name VARCHAR(20) NOT NULL
);

INSERT INTO User VALUE(1, "Felipe Grings");
INSERT INTO User VALUE(2, "José Homffman");
INSERT INTO User VALUE(3, "Andreas Pulber");
INSERT INTO User VALUE(4, "Maria Silva");
INSERT INTO User VALUE(5, "Elis Debbuger");

DROP TABLE IF EXISTS Card;

CREATE TABLE Card (
    id_card int PRIMARY KEY auto_increment,
    id_user int,
    title VARCHAR(40) NOT NULL,
    description VARCHAR(200),
    color VARCHAR(6) CONSTRAINT color_out_of_range CHECK (color = 6),
    FOREIGN KEY (id_user) REFERENCES User (id_user)
);

INSERT INTO Card VALUE(1, NULL,"Engenheiro", "uahs buashd oiqm opiu qmwçl", NULL);
INSERT INTO Card VALUE(2, NULL,"Tecnico", "uahs buashd oiqm opiu qmwçl", NULL);
INSERT INTO Card VALUE(3, NULL,"Gerente", "uahs buashd oiqm opiu qmwçl", NULL);
INSERT INTO Card VALUE(4, NULL,"Analista", "uahs buashd oiqm opiu qmwçl", NULL);
