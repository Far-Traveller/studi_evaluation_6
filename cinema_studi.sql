--Se connecter à mySQL dans le terminal
mysql -u root -p

--Création BDD du cinéma
CREATE DATABASE IF NOT EXISTS cinema_studi CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

--Vous pouvez vérifier la création de la BDD avec
SHOW databases;

--Création un admin et un user pour la BDD (seulement pour des tests, sinon créer mot de passe plus sécurisé)
CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'admin-test';
GRANT ALL PRIVILEGES ON * . * TO 'Admin'@'localhost';

--Se connecter à la BDD du cinéma
USE cinema_studi;

--Vérification
STATUS;

--Création de toutes les tables
CREATE TABLE IF NOT EXISTS cinema
(
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(250) NOT NULL,
  town VARCHAR(50) NOT NULL
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS room
(
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  room_number INT NOT NULL,
  total_seats INT NOT NULL,
  cinema_id INT NOT NULL,
  FOREIGN KEY(cinema_id) REFERENCES cinema(id)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS movie
(
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  title VARCHAR(250) NOT NULL,
  length TIME NOT NULL
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS user
(
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  email VARCHAR(250) NOT NULL UNIQUE,
  firstname VARCHAR(50) NOT NULL,
  lastname VARCHAR(50) NOT NULL,
  password VARCHAR(100) NOT NULL,
  role VARCHAR(10),
  cinema_id INT,
  FOREIGN KEY(cinema_id) REFERENCES cinema(id)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS price
(
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  price INT NOT NULL
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS session
(
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  day DATE NOT NULL,
  start_time TIME NOT NULL,
  movie_id INT NOT NULL,
  room_id INT NOT NULL,
  FOREIGN KEY(movie_id) REFERENCES movie(id),
  FOREIGN KEY(room_id) REFERENCES room(id)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS reservation
(
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  booking_date DATETIME NOT NULL,
  total_places INT NOT NULL,
  price_id INT NOT NULL,
  user_id INT NOT NULL,
  session_id INT NOT NULL,
  FOREIGN KEY(price_id) REFERENCES price(id),
  FOREIGN KEY(user_id) REFERENCES user(id),
  FOREIGN KEY(session_id) REFERENCES session(id)
)ENGINE = INNODB;

--Vérification liste de toutes les tables
SHOW tables;

--Insertion de données dans les tables
INSERT INTO cinema (name, address, town)
VALUES
('FakeCine Thionville', '3 rue du cinéma', 'Thionville'),
('FakeCine Toulouse', '50 rue Taison', 'Toulouse'),
('FakeCine Lyon', '25 rue des crayons', 'Lyon'),
('FakeCine Bordeaux', '12 route des miroirs', 'Bordeaux'),
('FakeCine Lille', '9 boulevard solidarité', 'Lille'),
('FakeCine Hendaye', '35 rue de la Foret', 'Hendaye');


INSERT INTO room (room_number, total_seats, cinema_id)
VALUES
(1, 100, 1),
(2, 50, 1),
(3, 120, 1),
(4, 80, 1),
(1, 110, 2),
(2, 70, 2),
(3, 80, 2),
(4, 80, 2),
(5, 140, 2),
(1, 110, 3),
(2, 100, 3),
(3, 90, 3),
(1, 30, 4),
(2, 50, 4),
(3, 90, 4),
(4, 30, 4),
(5, 100, 4),
(6, 120, 4),
(7, 80, 4),
(1, 110, 5),
(2, 70, 5),
(3, 80, 5),
(4, 80, 5),
(5, 140, 5),
(1, 90, 6),
(2, 60, 6),
(3, 80, 6);

INSERT INTO movie (title, length)
VALUES
('Wonder Woman', '02:12:00'),
('Batman', '02:10:00'),
('Les Simpson', '01:37:00'),
('Harry Potter à l\'école des sorciers', '02:02:00'),
('La ligne verte', '03:09:00'),
('Matrix 2', '02:53:00');

--Création des administrateurs des différents cinémas
INSERT INTO user (email, firstname, lastname, password, role, cinema_id)
VALUES
('bilbonsacquet@test.fr', 'Bilbon', 'Sacquet', '$2y$13$OoGnL.dHpw1SEneS0pXmsuGEGSpOmH4WNbgZ3LkuHurIZSCEPI8xi', 'Admin' 1),
('martymcfly@test.fr', 'Marty', 'Mcfly', '$2y$13$OoGnL.dHpw1SEneS0pXmsuGEGSpOmH4WNbgZ3LkuHurIZSCEPI8xi', 'Admin', 2),
('gandalflegris@test.fr', 'Gandalf', 'Le Gris', '$2y$13$fT572qAsEMBWEamtTK6FbeR38laZLqjHt3PnStA15jatVgRWzFbLW', 'Admin', 3),
('anakinskywalker@test.fr', 'Anakin', 'Skywalker', '$2y$13$ky/P6LmPLcYNujERUZtPzuI0d41CffJeJwdZUqLvXVqREddCyw6uq', 'Admin', 4),
('chucknorris@test.fr', 'Chuck', 'Norris', '$2y$13$6RyAtx6qtpbisJ8tfrq0Luoxddq5/bHVhySBhagxV3jSzGR1R9xtq', 'Admin', 5),
('mattsmith@test.fr', 'Matt', 'Smith', '$2y$13$/e3DMrrfm85zDZ5Mhcj4vuNdKWH6doyo80UnV8zN6gBFuPXd/9USa', 'Admin', 6);

--Création des utilisateurs lambdas
INSERT INTO user (email, firstname, lastname, password)
VALUES
('themaster@test.fr', 'The', 'Master', '$2y$13$/e3DMrrfm85zDZ5Mhcj4vuNdKWH6doyo80UnV8zN6gBFuPXd/9USa'),
('chandlerbing@test.fr', 'Chandler', 'Bing', '$2y$13$OoGnL.dHpw1SEneS0pXmsuGEGSpOmH4WNbgZ3LkuHurIZSCEPI8xi'),
('jessicaday@test.fr', 'Jessica', 'Day', '$2y$13$fT572qAsEMBWEamtTK6FbeR38laZLqjHt3PnStA15jatVgRWzFbLW'),
('barneystinson@test.fr', 'Barney', 'Stinson', '$2y$13$fT572qAsEMBWEamtTK6FbeR38laZLqjHt3PnStA15jatVgRWzFbLW'),
('donaldduck@test.fr', 'Donald', 'Duck', '$2y$13$ky/P6LmPLcYNujERUZtPzuI0d41CffJeJwdZUqLvXVqREddCyw6uq');

INSERT INTO price (name, price)
VALUES
('Plein tarif', 9.20),
('Étudiant', 7.60),
('Moins de 14 ans', 5.90);


INSERT INTO session (day, start_time, movie_id, room_id)
VALUES
('2022-04-30', '18:00:00', 1, 1),
('2022-04-30', '19:00:00', 2, 2),
('2022-04-30', '21:15:00', 3, 3),
('2022-04-30', '17:30:00', 4, 4),

('2022-04-30', '12:00:00', 1, 5),
('2022-04-30', '16:00:00', 2, 6),
('2022-04-30', '18:30:00', 3, 7),
('2022-04-30', '17:20:00', 4, 8),
('2022-04-30', '18:00:00', 5, 9),

('2022-04-30', '18:00:00', 1, 10),
('2022-04-30', '19:00:00', 2, 11),
('2022-04-30', '21:15:00', 3, 12),

('2022-04-30', '18:00:00', 1, 13),
('2022-04-30', '19:00:00', 2, 14),
('2022-04-30', '21:15:00', 3, 15),
('2022-04-30', '18:00:00', 4, 16),
('2022-04-30', '16:00:00', 5, 17),
('2022-04-30', '20:15:00', 6, 18),
('2022-04-30', '14:00:00', 2, 19),

('2022-04-30', '12:00:00', 1, 20),
('2022-04-30', '16:00:00', 2, 21),
('2022-04-30', '18:30:00', 3, 22),
('2022-04-30', '17:20:00', 4, 23),
('2022-04-30', '18:00:00', 5, 24),

('2022-04-30', '18:00:00', 1, 25),
('2022-04-30', '19:00:00', 6, 26),
('2022-04-30', '21:15:00', 2, 27);

INSERT INTO reservation (booking_date, total_places, price_id, user_id, session_id)
VALUES
('2022-04-28 03:10:20', 1, 1, 1, 18 ),
('2022-04-25 10:40:23', 3, 2, 2, 2 ),
('2022-04-29 22:36:59', 2, 1, 5, 13 ),
('2022-04-28 13:13:38', 1, 3, 1, 18 ),
('2022-04-30 23:46:56', 2, 1, 3, 20 ),
('2022-04-28 09:43:34', 1, 2, 4, 9 );


-------- Tests CRUD : --------

--CREATION
INSERT INTO movie (title, length)
VALUES
('Spiderman', '01:47:00');

--READ :
SELECT title, length
FROM movie
WHERE movie.title = 'Spiderman';

--UPDATE
UPDATE movie
SET length = '02:42:00'
WHERE movie.title = 'Spiderman';

--DELETE
DELETE FROM movie
WHERE movie.title = 'Spiderman';

--Sauvegarde de la BDD
mysqldump -u root -p cinema_studi > cimema_studi.sql

--Importation de la BDD
CREATE DATABASE IF NOT EXISTS cinema_studi CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
mysqldump -u root -p cinema_studi < cimema_studi.sql
