--Ejecutar primero
CREATE DATABASE Monedas; 

--Para las siguientes instrucciones, se debe cambiar la conexión

-- Crear tabla MONEDA
CREATE TABLE Moneda( 
	Id SERIAL PRIMARY KEY, 
	Moneda VARCHAR(100) NOT NULL,
	Sigla VARCHAR(5) NOT NULL,
	Simbolo VARCHAR(5) NULL,
	Emisor VARCHAR(100) NULL,
	Imagen bytea NULL
	);

-- Crear indice para MONEDA	ordenado por MONEDA
CREATE UNIQUE INDEX ixMoneda
	ON Moneda(Moneda);

/* Crear tabla CAMBIOMONEDA */
CREATE TABLE CambioMoneda( 
	IdMoneda INTEGER NOT NULL,
	CONSTRAINT fkCambioMoneda_IdMoneda FOREIGN KEY (IdMoneda) REFERENCES Moneda(Id),
	Fecha DATE NOT NULL,
	Cambio FLOAT NOT NULL
);

-- Crear indice para CAMBIOMONEDA ordenado por MONEDA, FECHA */
CREATE UNIQUE INDEX ixCambioMoneda
	ON CambioMoneda(IdMoneda, Fecha);


--Crear la tabla PAIS
CREATE TABLE Pais(
	Id SERIAL PRIMARY KEY,
	Pais VARCHAR(50) NOT NULL,
	CodigoAlfa2 VARCHAR(5) NOT NULL,
	CodigoAlfa3 VARCHAR(5) NOT NULL, 
	IdMoneda INTEGER NOT NULL,
	CONSTRAINT fkPais_IdMoneda FOREIGN KEY (IdMoneda) REFERENCES Moneda(Id),
	Mapa bytea NULL,
	Bandera bytea NULL
	);

--Definir indice unico de PAIS
CREATE UNIQUE INDEX ixPais_Pais
	ON Pais(Pais);
