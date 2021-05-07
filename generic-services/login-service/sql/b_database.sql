DROP TABLE IF EXISTS Permission;

CREATE TABLE Permission (
    id_permission int PRIMARY KEY auto_increment,
    service_name VARCHAR(40)
);

INSERT INTO Permission VALUE(1,"get-last-imc");
INSERT INTO Permission VALUE(2,"add-imc");
INSERT INTO Permission VALUE(3,"remove-imc");

DROP TABLE IF EXISTS Role;

CREATE TABLE Role (
    id_role int PRIMARY KEY auto_increment,
    name VARCHAR(20)
);

INSERT INTO Role VALUE(1,"Gerente");
INSERT INTO Role VALUE(2,"Tecnico");


DROP TABLE IF EXISTS RolePermission;

CREATE TABLE RolePermission (
    id_role_permission int PRIMARY KEY auto_increment,
    id_role int NOT NULL,
    id_permission int NOT NULL,
    
	FOREIGN KEY (id_role) REFERENCES Role (id_role),
    FOREIGN KEY (id_permission) REFERENCES Permission (id_permission)
);

INSERT INTO RolePermission VALUE(1,1,1);
INSERT INTO RolePermission VALUE(2,1,2);
INSERT INTO RolePermission VALUE(3,1,3);

INSERT INTO RolePermission VALUE(4,2,1);
INSERT INTO RolePermission VALUE(5,2,2);

DROP TABLE IF EXISTS User;

CREATE TABLE User (
    id_user int PRIMARY KEY auto_increment,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(30) NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(20) NOT NULL,
    token VARCHAR(126),
    phone VARCHAR(20) NOT NULL,
    id_role int,

    FOREIGN KEY (id_role) REFERENCES Role (id_role)
);

INSERT INTO User VALUE(1,"admin","admin","Gerente","Eng","nb_iot@gmail.com",123,"2321231233",1);
INSERT INTO User VALUE(2,"user","user","Tecnico","2","nb_iot@gmail.com",1,"1231231233",1);
INSERT INTO User VALUE(9,"user8","user8","Not","8","nb_iot@gmail.com",2,"1231231233",2);