CREATE TABLE soccer_players (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  team_id INTEGER,
  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  sponsor VARCHAR(255) NOT NULL,
  country_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE leagues (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  country VARCHAR(255) NOT NULL
);

INSERT INTO
  leagues (id, name)
VALUES
  (1, "La Liga BBVA", "Spain"),
  (2, "France Ligue 1", "France"),
  (3, "Primier League", "England")

INSERT INTO
  teams (id, name, sponsor, country_id)
VALUES
  (1, "FC Barcelona", "Nike",1),
  (2, "Real Madrid", "Adidas",1),
  (3, "PSG", "Nike",2),
  (4, "Liverpool", "New Balance",3),

INSERT INTO
  soccer_players (id, name, team_id )
VALUES
  (1, "Messi", 1),
  (2, "Inestia", 1),
  (3, "Suarez", 1),
  (4, "Neymar", 2),
  (5, "Modric", 3),
  (6, "Pirlo", NULL)
