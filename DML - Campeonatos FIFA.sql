--0. Asegurar que el autonumérico de los campos ID esté sincronizado
SELECT setval(
    pg_get_serial_sequence('fase', 'id'),
     COALESCE((SELECT MAX(id) FROM fase) + 1, 1),
    false
);


--1. Crear las fases
INSERT INTO fase
	(fase)
	VALUES ('Eliminatorias'), 
		('Grupos'),
		('Diesciseisavos de Final'),
		('Octavos de Final'),
		('Cuartos de Final'),
		('Semifinal'),
		('Final')
	ON CONFLICT(fase) DO NOTHING;

