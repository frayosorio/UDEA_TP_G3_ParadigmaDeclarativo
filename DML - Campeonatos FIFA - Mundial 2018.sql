--Script para alimentar la información del Campeonato Mundial de la FIFA 2018

--0. Asegurar que el autonumérico de los campos ID esté sincronizado
SELECT setval(
    pg_get_serial_sequence('pais', 'id'),
    COALESCE((SELECT MAX(id) FROM pais) + 1, 1),
    false
);

SELECT setval(
    pg_get_serial_sequence('campeonato', 'id'),
     COALESCE((SELECT MAX(id) FROM campeonato) + 1, 1),
    false
);

SELECT setval(
    pg_get_serial_sequence('grupo', 'id'),
    COALESCE((SELECT MAX(id) FROM grupo) + 1, 1),
    false
);

SELECT setval(
    pg_get_serial_sequence('ciudad', 'id'),
     COALESCE((SELECT MAX(id) FROM ciudad) + 1, 1),
    false
);

SELECT setval(
    pg_get_serial_sequence('estadio', 'id'),
    COALESCE((SELECT MAX(id) FROM estadio) + 1, 1),
    false
);

SELECT setval(
    pg_get_serial_sequence('encuentro', 'id'),
     COALESCE((SELECT MAX(id) FROM encuentro) + 1, 1),
    false
);


--1. Actualización de Paises
INSERT INTO pais (pais, entidad)
	VALUES
	('Rusia',''),
	('Arabia Saudita',''),
	('Egipto',''),
	('Uruguay',''),
	
	('Portugal',''),
	('España',''),
	('Marruecos',''),
	('Irán',''),
	
	('Francia',''),
	('Australia',''),
	('Perú',''),
	('Dinamarca',''),
	
	('Argentina',''),
	('Islandia',''),
	('Croacia',''),
	('Nigeria',''),
	
	('Brasil',''),
	('Suiza',''),
	('Costa Rica',''),
	('Serbia',''),
	
	('Alemania',''),
	('México',''),
	('Suecia',''),
	('Corea del Sur',''),
	
	('Bélgica',''),
	('Panamá',''),
	('Túnez',''),
	('Inglaterra',''),
	
	('Colombia',''),
	('Japón',''),
	('Polonia',''),
	('Senegal','')
	
	ON CONFLICT (pais) DO NOTHING;

--2. Actualización del Campeonato
INSERT INTO campeonato (campeonato, año)
	VALUES ('FIFA World Cup 2018', 2018)
	ON CONFLICT(campeonato) DO NOTHING;

--3. Actualización de los paises organizadores del Campeonato
INSERT INTO campeonatopais
	(idcampeonato, idpais)
	SELECT C.id, P.id
		FROM campeonato C, pais P
		WHERE C.campeonato = 'FIFA World Cup 2018'
			AND P.pais IN ('Rusia')
	ON CONFLICT(idcampeonato, idpais) DO NOTHING;

--4. Actualización de Grupos
INSERT INTO grupo (idcampeonato, grupo)
	SELECT c.id, g.grupo
		FROM campeonato c
			JOIN (VALUES ('A'),('B'),('C'),('D'),('E'),('F'),('G'),('H')) g(grupo)
				ON c.campeonato = 'FIFA World Cup 2018'
	ON CONFLICT DO NOTHING;

--5. Actualización de los paises en los grupos
INSERT INTO grupopais
    (idgrupo, idpais)
	SELECT g.id, p.id
		FROM grupo g
			JOIN campeonato c 
			    ON g.idcampeonato = c.id 
			    AND c.campeonato = 'FIFA World Cup 2018'
			
			JOIN (
			    VALUES
			    -- Grupo A
			    ('Rusia','A'),
			    ('Arabia Saudita','A'),
			    ('Egipto','A'),
			    ('Uruguay','A'),
			
			    -- Grupo B
			    ('Portugal','B'),
			    ('España','B'),
			    ('Marruecos','B'),
			    ('Irán','B'),
			
			    -- Grupo C
			    ('Francia','C'),
			    ('Australia','C'),
			    ('Perú','C'),
			    ('Dinamarca','C'),
			
			    -- Grupo D
			    ('Argentina','D'),
			    ('Islandia','D'),
			    ('Croacia','D'),
			    ('Nigeria','D'),
			
			    -- Grupo E
			    ('Brasil','E'),
			    ('Suiza','E'),
			    ('Costa Rica','E'),
			    ('Serbia','E'),
			
			    -- Grupo F
			    ('Alemania','F'),
			    ('México','F'),
			    ('Suecia','F'),
			    ('Corea del Sur','F'),
			
			    -- Grupo G
			    ('Bélgica','G'),
			    ('Panamá','G'),
			    ('Túnez','G'),
			    ('Inglaterra','G'),
			
			    -- Grupo H
			    ('Colombia','H'),
			    ('Japón','H'),
			    ('Polonia','H'),
			    ('Senegal','H')
			
			) datos(pais, grupo)
			    ON g.grupo = datos.grupo
		
		JOIN pais p 
		    ON p.pais = datos.pais
	
	ON CONFLICT(idgrupo, idpais) DO NOTHING;

--6. Actualización de Ciudades
INSERT INTO ciudad
    (ciudad, idpais)
	SELECT datos.ciudad, p.id
		FROM (
		    VALUES
		    ('Moscú','Rusia'),
		    ('San Petersburgo','Rusia'),
		    ('Sochi','Rusia'),
		    ('Kazan','Rusia'),
		    ('Ekaterimburgo','Rusia'),
		    ('Samara','Rusia'),
		    ('Saransk','Rusia'),
		    ('Rostov del Don','Rusia'),
		    ('Volgogrado','Rusia'),
		    ('Kaliningrado','Rusia'),
		    ('Nizhni Nóvgorod','Rusia')
		) AS datos(ciudad, pais)
		JOIN pais p ON p.pais = datos.pais
	ON CONFLICT (idpais, ciudad) DO NOTHING;
		

--7. Actualización de Estadios
INSERT INTO estadio
    (estadio, idciudad, capacidad)
	SELECT datos.estadio, c.id, datos.capacidad
		FROM (
		    VALUES
		    ('Luzhniki Stadium','Moscú',81000),
		    ('Spartak Stadium','Moscú',45000),
		    ('Saint Petersburg Stadium','San Petersburgo',68000),
		    ('Fisht Stadium','Sochi',48000),
		    ('Kazan Arena','Kazan',45000),
		    ('Ekaterinburg Arena','Ekaterimburgo',35000),
		    ('Samara Arena','Samara',45000),
		    ('Mordovia Arena','Saransk',44000),
		    ('Rostov Arena','Rostov del Don',45000),
		    ('Volgograd Arena','Volgogrado',45000),
		    ('Kaliningrad Stadium','Kaliningrado',35000),
		    ('Nizhny Novgorod Stadium','Nizhni Nóvgorod',45000)
			) AS datos(estadio, ciudad, capacidad)	
			JOIN ciudad c ON c.ciudad = datos.ciudad
	ON CONFLICT (estadio) DO NOTHING;

--8. Actualización de Encuentros
INSERT INTO encuentro 
	(idpais1, idpais2, fecha, idestadio, idfase, idcampeonato, goles1, goles2)
	SELECT 
	    p1.id, p2.id,
	    datos.fecha::DATE,
	    e.id,
	    1,
	    c.id,
	    datos.g1,
	    datos.g2
	FROM (VALUES
			
			-- =====================
			-- GRUPO A
			-- =====================
			('Rusia','Arabia Saudita','2018-06-14','Luzhniki Stadium',5,0),
			('Egipto','Uruguay','2018-06-15','Ekaterinburg Arena',0,1),
			('Rusia','Egipto','2018-06-19','Saint Petersburg Stadium',3,1),
			('Uruguay','Arabia Saudita','2018-06-20','Rostov Arena',1,0),
			('Uruguay','Rusia','2018-06-25','Samara Arena',3,0),
			('Arabia Saudita','Egipto','2018-06-25','Volgograd Arena',2,1),
			
			-- =====================
			-- GRUPO B
			-- =====================
			('Portugal','España','2018-06-15','Fisht Stadium',3,3),
			('Marruecos','Irán','2018-06-15','Saint Petersburg Stadium',0,1),
			('Portugal','Marruecos','2018-06-20','Luzhniki Stadium',1,0),
			('Irán','España','2018-06-20','Kazan Arena',0,1),
			('Irán','Portugal','2018-06-25','Mordovia Arena',1,1),
			('España','Marruecos','2018-06-25','Kaliningrad Stadium',2,2),
			
			-- =====================
			-- GRUPO C
			-- =====================
			('Francia','Australia','2018-06-16','Kazan Arena',2,1),
			('Perú','Dinamarca','2018-06-16','Mordovia Arena',0,1),
			('Dinamarca','Australia','2018-06-21','Samara Arena',1,1),
			('Francia','Perú','2018-06-21','Ekaterinburg Arena',1,0),
			('Dinamarca','Francia','2018-06-26','Luzhniki Stadium',0,0),
			('Australia','Perú','2018-06-26','Fisht Stadium',0,2),
			
			-- =====================
			-- GRUPO D
			-- =====================
			('Argentina','Islandia','2018-06-16','Spartak Stadium',1,1),
			('Croacia','Nigeria','2018-06-16','Kaliningrad Stadium',2,0),
			('Argentina','Croacia','2018-06-21','Nizhny Novgorod Stadium',0,3),
			('Nigeria','Islandia','2018-06-22','Volgograd Arena',2,0),
			('Nigeria','Argentina','2018-06-26','Saint Petersburg Stadium',1,2),
			('Islandia','Croacia','2018-06-26','Rostov Arena',1,2),
			
			-- =====================
			-- GRUPO E
			-- =====================
			('Brasil','Suiza','2018-06-17','Rostov Arena',1,1),
			('Costa Rica','Serbia','2018-06-17','Samara Arena',0,1),
			('Brasil','Costa Rica','2018-06-22','Saint Petersburg Stadium',2,0),
			('Serbia','Suiza','2018-06-22','Kaliningrad Stadium',1,2),
			('Serbia','Brasil','2018-06-27','Spartak Stadium',0,2),
			('Suiza','Costa Rica','2018-06-27','Nizhny Novgorod Stadium',2,2),
			
			-- =====================
			-- GRUPO F
			-- =====================
			('Alemania','México','2018-06-17','Luzhniki Stadium',0,1),
			('Suecia','Corea del Sur','2018-06-18','Nizhny Novgorod Stadium',1,0),
			('Corea del Sur','México','2018-06-23','Rostov Arena',1,2),
			('Alemania','Suecia','2018-06-23','Fisht Stadium',2,1),
			('Corea del Sur','Alemania','2018-06-27','Kazan Arena',2,0),
			('México','Suecia','2018-06-27','Ekaterinburg Arena',0,3),
			
			-- =====================
			-- GRUPO G
			-- =====================
			('Bélgica','Panamá','2018-06-18','Fisht Stadium',3,0),
			('Túnez','Inglaterra','2018-06-18','Volgograd Arena',1,2),
			('Bélgica','Túnez','2018-06-23','Spartak Stadium',5,2),
			('Inglaterra','Panamá','2018-06-24','Nizhny Novgorod Stadium',6,1),
			('Inglaterra','Bélgica','2018-06-28','Kaliningrad Stadium',0,1),
			('Panamá','Túnez','2018-06-28','Mordovia Arena',1,2),
			
			-- =====================
			-- GRUPO H
			-- =====================
			('Colombia','Japón','2018-06-19','Mordovia Arena',1,2),
			('Polonia','Senegal','2018-06-19','Spartak Stadium',1,2),
			('Japón','Senegal','2018-06-24','Ekaterinburg Arena',2,2),
			('Polonia','Colombia','2018-06-24','Kazan Arena',0,3),
			('Japón','Polonia','2018-06-28','Volgograd Arena',0,1),
			('Senegal','Colombia','2018-06-28','Samara Arena',0,1)
			
			) AS datos(pais1, pais2, fecha, estadio, g1, g2)
	
		JOIN pais p1 ON p1.pais = datos.pais1
		JOIN pais p2 ON p2.pais = datos.pais2
		JOIN estadio e ON e.estadio = datos.estadio
		JOIN campeonato c ON c.campeonato = 'FIFA World Cup 2018'
		JOIN fase F ON F.fase = 'Grupos'
	ON CONFLICT (idpais1, idpais2, idfase, idcampeonato)
	DO UPDATE SET
	    fecha = EXCLUDED.fecha,
	    idestadio = EXCLUDED.idestadio,
	    goles1 = EXCLUDED.goles1,
	    goles2 = EXCLUDED.goles2;