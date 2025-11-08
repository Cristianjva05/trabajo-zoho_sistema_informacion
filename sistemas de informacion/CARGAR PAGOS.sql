-- se utiliza para buscar
SELECT p.REFERENCIA, p.DOCUMENTO, p.NAME, p.SURNAME ,P.DESCRIPCION ,p.fecha , p.valor ,c.total, p.ESTADO, c.franchise ,p.RECIBO_ICEBERG, r.VALOR_PAGADO, (p.VALOR - r.VALOR_PAGADO) AS DIFERENCIA 
from PORTAL_PAGOS_CUN.ppt_cun_transaccion_pago p
LEFT JOIN PORTAL_PAGOS_CUN.PPT_CUN_DETALLE_RESPUESTA_PAGO r ON r.REFERENCIA = p.REFERENCIA LEFT JOIN PORTAL_PAGOS_CUN.ppt_cun_respuesta_pago c ON c.REFERENCIA = p.REFERENCIA 
WHERE p.REFERENCIA  IN ('1003894591') ORDER BY p.fecha DESC
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

-- Eliminar registros de Ppt_Cun_Base_ORDENES donde recibo_agrupado coincida / EL PRIMER IN ES EL LA REFERENCIA ANTIGUA
--DELETE FROM PORTAL_PAGOS_CUN.Ppt_Cun_Base_ORDENES WHERE recibo_agrupado IN ('117905820');

-- Actualizar los registros en Ppt_Cun_Base_ORDENES donde recibo_agrupado coincida / EL PRIMER IN ES EL LA REFERENCIA ANTIGUA Y LA SEGUNDA NUEVA
--UPDATE PORTAL_PAGOS_CUN.Ppt_Cun_Base_ORDENES SET RECIBO_AGRUPADO = '116705076' WHERE recibo_agrupado IN ('117843791');

-- Eliminar registros de ppt_cun_transaccion_pago donde referencia coincida / EL PRIMER IN ES EL LA REFERENCIA NUEVA
--DELETE FROM PORTAL_PAGOS_CUN.ppt_cun_transaccion_pago WHERE referencia IN ('117843791');

-- Llamar al procedimiento almacenado para procesar pagos aproba
--/ EL PRIMER IN ES EL LA REFERENCIA ANTIGUA DESPUES ,SECUENCIA ES SIEMPRE 1 / VALOR / FRANCHISE 7 FECHA 
	BEGIN PORTAL_PAGOS_CUN.PPP_CUN_BASE_ORDENES.procesa_pagos_aprobados(116705076,1,850000, '_PSE_', TO_DATE('8/10/2025', 'DD/MM/YYYY'), '', '00', 'NORMAL'); COMMIT; END;
-- PARA CONSULTAR SI ESTA EL PAGO EN ICEBER / ES LA ANTIGUA
select P.*, ROWID from PORTAL_PAGOS_CUN.ppt_cun_detalle_respuesta_pago p where referencia  IN ('117843802')

-- SP DEL CREDITOS  
BEGIN PORTAL_PAGOS_CUN.PPP_CUN_BASE_CREDITO.procesa_pagos_aprobados(117843802,1,230000, '_PSE_', TO_DATE('30/10/2025', 'DD/MM/YYYY'), '', '00', 'NORMAL'); COMMIT; END;

