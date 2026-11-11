SELECT C.campeonato, STRING_AGG(P.pais, ', ') Organizadores, G.grupo, GP.idgrupo, PG.pais
	FROM campeonato C
		JOIN campeonatopais CP ON C.id = CP.idcampeonato
		JOIN pais P ON CP.idpais = P.id
		LEFT JOIN grupo G ON G.idcampeonato = C.id
		LEFT JOIN grupopais GP ON G.id = GP.idgrupo
		LEFT JOIN pais PG ON GP.idpais = PG.id
	WHERE C.campeonato = 'FIFA World Cup 2022'
	GROUP BY C.campeonato, G.grupo, GP.idgrupo, PG.pais

SELECT ciudad, estadio, capacidad
	FROM vEstadios
	WHERE pais='Catar'

SELECT C.ciudad, E.estadio, E.capacidad
	FROM ciudad C
		JOIN pais P ON C.idpais = P.id
		JOIN estadio E ON E.idciudad = C.id
		WHERE P.pais='Catar'

SELECT *
	FROM vEncuentros
	WHERE campeonato = 'FIFA World Cup 2022'

SELECT *
	FROM fObtenerTablaPosiciones(103)