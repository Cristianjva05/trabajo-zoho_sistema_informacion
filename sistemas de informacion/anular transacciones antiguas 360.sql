--///////////////// Anular antiguas transacciones  /////////////////



-- SE UTILIZA PARA REVISAR el credito que tiene los estudiates 

SELECT * FROM ICEBERG.CUNT_TRAMITE_EXTERNO c 
WHERE IDENTIFICACION = '1116553208';


-- QUEDA TODOS LOS MOVIMIENTO QUE REALIZA EL ESTUDIANTE
SELECT * FROM iceberg.cltiene_transaccion_his t


-- es la informacion que ve el usuario , en si para anular una transaccion se debe cambiar el codigo
SELECT * FROM iceberg.cltiene_360_estudiantes t