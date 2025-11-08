select tramite, orden, valor_financiacion, t.*, rowid from iceberg.cunt_tramite_externo t where identificacion = '1016949319';---1  
    
select t.*, rowid from iceberg.cltiene_transaccion_his t where numidentificacion= '1016949319';--- 2

select t.*, rowid from iceberg.cltiene_360_estudiantes t where numero_documento in ('1016949319');-----3     
-------------------CONSECUTIVO_RPVI------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE ICEBERG.ORDEN o SET o.CONSECUTIVO_ACTIVACION = (
    SELECT l.LIQUIDACION FROM ICEBERG.LIQUIDACION_ORDEN l WHERE o.ORDEN = l.ORDEN AND o.PERIODO = l.PERIODO AND o.ESTADO = l.ESTADO AND o.DOCUMENTO = l.DOCUMENTO AND o.CLIENTE_SOLICITADO = l.CLIENTE)
WHERE o.PERIODO LIKE '%25%' AND o.ESTADO = 'V' AND o.DOCUMENTO = 'RPVI' AND o.CONSECUTIVO_ACTIVACION IS NULL AND o.CLIENTE_SOLICITADO IN ('1016949319') AND EXISTS 
(SELECT 1 FROM ICEBERG.LIQUIDACION_ORDEN l WHERE o.ORDEN = l.ORDEN AND o.PERIODO = l.PERIODO AND o.ESTADO = l.ESTADO AND o.DOCUMENTO = l.DOCUMENTO AND o.CLIENTE_SOLICITADO = l.CLIENTE);

SELECT O.*, ROWID FROM ICEBERG.ORDEN O WHERE O.CLIENTE_SOLICITADO = '1016949319' AND O.DOCUMENTO = 'RPVI'

---------------------COLOCAR_50%---------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO ICEBERG.cltiene_360_estudiantes SELECT * FROM ICEBERG.v_inserta_estudiantes_360  WHERE numero_documento = '1016949319' AND referencia_pago = '117800612' 