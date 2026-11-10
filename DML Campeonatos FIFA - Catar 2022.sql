-- Script IDEMPOTENTE para registrar la información del mundial Catar 2022, incluyendo:
-- * Paises Participantes
-- * Paises Organizadores
-- * Grupos y los paises integrantes
-- * Ciudades y Estadios
-- * Encuentros de la fase de grupos

--1. Agregar Paises
INSERT INTO pais
	(pais, entidad)
	VALUES
	('Catar', 'Asociación de Fútbol de Catar'), 
	('Ecuador', ''), 
	('Senegal', 'Federación Senegalesa de Fútbol'), 
	('Países Bajos', ''), 
	('Inglaterra', ''), 
	('Irán', ''),
	('Estados Unidos', ''), 
	('Gales', ''), 
	('Argentina', ''),
	('Arabia Saudita', ''),
	('México', ''), 
	('Polonia', ''), 
	('Francia', ''), 
	('Australia', ''), 
	('Dinamarca', ''), 
	('Túnez', ''), 
	('España', ''), 
	('Costa Rica', ''), 
	('Alemania', ''), 
	('Japón', ''), 
	('Bélgica', ''),
	('Canadá', ''),
	('Marruecos', ''),
	('Croacia', ''),
	('Brasil', 'Confederación Brasileña de Fútbol'),
	('Serbia', ''),
	('Suiza', ''),
	('Camerún', ''),
	('Portugal', ''),
	('Ghana', ''),
	('Uruguay', ''),
	('Corea del Sur', '')
	ON CONFLICT(pais)
	DO UPDATE
		SET entidad = excluded.entidad
		WHERE excluded.entidad<>'';

--2. Agregar Campeonato
INSERT INTO campeonato
	(campeonato, año)
	VALUES('FIFA World Cup 2022', 2022)
	ON CONFLICT(campeonato)
	DO UPDATE
		SET año=excluded.año;

--3. Agregar Paises Organizadores
INSERT INTO campeonatopais
	(idcampeonato, idpais)
	SELECT C.id, P.id
		FROM campeonato C, pais P
		WHERE P.pais IN ('Catar')
			AND campeonato = 'FIFA World Cup 2022'
	ON CONFLICT(idcampeonato, idpais)
	DO NOTHING;

--4. Agregar los grupos
INSERT INTO grupo
	(idcampeonato, grupo)
	SELECT C.id, datos.grupo
		FROM campeonato C
			JOIN (
			VALUES 
				('A'), ('B'), ('C'), ('D'), ('E'), ('F'), 
				('G'), ('H'), ('I'), ('J'), ('K'), ('L')
			) datos(grupo) 
			ON C.campeonato = 'FIFA World Cup 2022'
	ON CONFLICT(idcampeonato, grupo)
	DO NOTHING;

/*
A	Catar, Ecuador, Senegal, Países Bajos
B	Inglaterra, Irán, Estados Unidos, Gales
C	Argentina, Arabia Saudita, México, Polonia
D	Francia, Australia, Dinamarca, Túnez
E	España, Costa Rica, Alemania, Japón
F	Bélgica, Canadá, Marruecos, Croacia
G	Brasil, Serbia, Suiza, Camerún
H	Portugal, Ghana, Uruguay, Corea del Sur
*/