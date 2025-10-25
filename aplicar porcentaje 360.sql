--///////////////// APLICAR DESCUENTO  /////////////////




-- se utiliza para ver si esta con el porcentaje , si aparece la linia si esta con el porcentaje

SELECT c.*, rowid FROM ICEBERG.CLTIENE_360_FUERZA_COMERCIAL c  
WHERE C.NUMERODOCUMENTO IN ('45536443');


-- se utiliza por si esta en fuerza comercial y aun no se ve el descuento , si hay una linia todo esta bien, si no aparece nada toca correr el proceso EXECUTE cup_reportes_matriculas.recupera_datos_matriculas
SELECT c.*, ROWID FROM ICEBERG.CUNT_ALUMNOS_ORDENES_X_PERIODO c
WHERE C.DOC_ALUM = '45536443' AND C.DOCUMENTO = 'FAMA';

-- se corre este proceso cuando esta represados algunos descuento solo se corre cuando no aparece en CUNT_ALUMNOS_ORDENES_X_PERIODO c
EXECUTE cup_reportes_matriculas.recupera_datos_matriculas ('25V06');

