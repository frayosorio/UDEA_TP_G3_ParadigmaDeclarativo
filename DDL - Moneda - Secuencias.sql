DO $$
DECLARE
    sigIdPais INTEGER;
    sigIdMoneda INTEGER;
BEGIN
    -- 1. Obtener el siguiente ID disponible para cada tabla
    SELECT COALESCE(MAX(Id), 0) + 1 INTO sigIdPais FROM Pais;
    SELECT COALESCE(MAX(Id), 0) + 1 INTO sigIdMoneda FROM Moneda;

    -- 2. Sincronizar las secuencias nativas generadas por el tipo SERIAL
    -- Nota: PostgreSQL nombra estas secuencias por defecto como: nombretabla_id_seq
    
    EXECUTE format('ALTER SEQUENCE pais_id_seq RESTART WITH %s', sigIdPais);
    EXECUTE format('ALTER SEQUENCE moneda_id_seq RESTART WITH %s', sigIdMoneda);

END $$;