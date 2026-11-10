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
				('A'), ('B'), ('C'), ('D'), 
				('E'), ('F'), ('G'), ('H')
			) datos(grupo) 
			ON C.campeonato = 'FIFA World Cup 2022'
	ON CONFLICT(idcampeonato, grupo)
	DO NOTHING;

--5. Agregar las selecciones de cada grupo
INSERT INTO GrupoPais
	(idgrupo, idpais)
	SELECT G.id, P.id
		FROM grupo G
			JOIN campeonato C ON G.idcampeonato = C.id
			JOIN (
				VALUES
				('A', 'Catar'), 
				('A', 'Ecuador'), 
				('A', 'Senegal'), 
				('A', 'Países Bajos'),
				
				('B','Inglaterra'), 
				('B','Irán'), 
				('B','Estados Unidos'), 
				('B','Gales'),
				
				('C','Argentina'), 
				('C','Arabia Saudita'), 
				('C','México'), 
				('C','Polonia'),
				
				('D','Francia'), 
				('D','Australia'), 
				('D','Dinamarca'), 
				('D','Túnez'),
				
				('E','España'), 
				('E','Costa Rica'), 
				('E','Alemania'), 
				('E','Japón'),
				
				('F','Bélgica'), 
				('F','Canadá'), 
				('F','Marruecos'), 
				('F','Croacia'),
				
				('G','Brasil'), 
				('G','Serbia'), 
				('G','Suiza'), 
				('G','Camerún'),
				
				('H','Portugal'), 
				('H','Ghana'), 
				('H','Uruguay'), 
				('H','Corea del Sur')
			) datos(grupo, pais)
			ON G.grupo = datos.grupo
			JOIN pais P ON datos.pais = P.pais
		WHERE C.campeonato = 'FIFA World Cup 2022'
	ON CONFLICT(idgrupo, idpais)
		DO NOTHING;

--6. Agregar ciudades 
INSERT INTO Ciudad
	(ciudad, idpais)
	SELECT datos.ciudad, P.id
		FROM (
			VALUES
			('Al Khor', 'Catar'),
			('Lusail', 'Catar'),
			('Al Rayyan', 'Catar'),
			('Doha', 'Catar'),
			('Al Wakrah', 'Catar')
		) datos(ciudad, pais)
		JOIN pais P ON P.pais=datos.pais
	ON CONFLICT
		DO NOTHING;

--7. Agregar estadios
INSERT INTO estadio
	(estadio, capacidad, idciudad)
	SELECT datos.estadio, datos.capacidad, C.id
		FROM (
			VALUES
			('Al Khor', 'Al Bayt Stadium', 68895),
			('Lusail', 'Lusail Stadium', 88966),
			('Al Rayyan', 'Ahmad bin Ali Stadium', 45032),
			('Al Rayyan', 'Education City Stadium', 44667),
			('Al Rayyan', 'Khalifa International Stadium', 45857),
			('Doha', 'Al Thumama Stadium', 44400),
			('Doha', 'Stadium 974',	44089),
			('Al Wakrah', 'Al Janoub Stadium', 44325)
		) datos(ciudad, estadio, capacidad)
		JOIN ciudad C ON C.ciudad= datos.ciudad
	ON CONFLICT(estadio)
		DO UPDATE
			SET capacidad = excluded.capacidad;

