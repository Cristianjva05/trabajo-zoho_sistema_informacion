/***********************************************************************************************
PROCESO: Aplicación del 50% de financiación (Proceso manual/automático)
------------------------------------------------------------------------------------------------
DESCRIPCIÓN GENERAL:
Este proceso permite aplicar manualmente el 50% de financiación a un estudiante cuando el 
proceso automático no se ejecuta correctamente. 
Sucede normalmente cuando:
- El estudiante no tiene cargado el pago de la RPVI.
- No existe la RPI correspondiente.
- El estudiante no está “Apto”.

------------------------------------------------------------------------------------------------
VALIDACIONES PREVIAS:
1. Verificar en ICEBERG si el estudiante tiene RPVI del periodo requerido.
2. Confirmar que la FAMA (Factura de Matrícula) no esté liquidada.
3. Validar que la RPVI aparezca con estado “Liquidado”.
   - Si no está liquidada, se debe revisar en Cartera de ICEBERG si existe saldo a favor.
   - En caso de existir saldo, solicitar que se crucen los valores.

------------------------------------------------------------------------------------------------
PROCEDIMIENTO GENERAL:
1. Revisar en la tabla **LIQUIDACION_ORDEN** si la RPVI está liquidada.
2. Si está liquidada, verificar en la tabla **cltiene_360_estudiantes** (tabla 3)
   que el proceso no esté registrado.
3. Obtener la referencia de pago desde la tabla **cunt_tramite_externo** (tabla 1).
4. Usar la vista **v_inserta_estudiantes_360** para realizar el INSERT en 
   **cltiene_360_estudiantes**, aplicando así el 50%.

------------------------------------------------------------------------------------------------
TABLAS Y OBJETOS INVOLUCRADOS:
- ICEBERG.LIQUIDACION_ORDEN → Liquidaciones por orden.
- ICEBERG.cunt_tramite_externo → Trámites realizados por el estudiante.
- ICEBERG.cltiene_transaccion_his → Historial de transacciones del estudiante.
- ICEBERG.cltiene_360_estudiantes → Estado de financiación (50%, 100%, anulado).
- ICEBERG.v_inserta_estudiantes_360 → Vista utilizada para insertar el registro del 50%.
- ICEBERG.ORDEN → Contiene los consecutivos de activación asociados a RPVI.

***********************************************************************************************/


/*-----------------------------------------------------------
SECCIÓN 1: CONSULTAS DE VALIDACIÓN
-----------------------------------------------------------*/

/* Buscar la liquidación de una orden específica */
SELECT * 
FROM ICEBERG.LIQUIDACION_ORDEN 
WHERE orden = 110672;


/* Ver todos los trámites realizados por el estudiante */
SELECT tramite, orden, valor_financiacion, t.*, rowid 
FROM iceberg.cunt_tramite_externo t 
WHERE identificacion = '1030660896';  --- Tabla 1


/* Ver historial de transacciones del estudiante */
SELECT t.*, rowid 
FROM iceberg.cltiene_transaccion_his t 
WHERE numidentificacion = '1030660896';  --- Tabla 2


/* Ver estado de financiación del estudiante
   ESTADO_FINANCIACION:
   - 0 → 50%
   - 1 → 100%
   - 2 → Anulado

   Esta tabla también se usa para anular un 50%, 
   cambiando el estado de financiación a 2 (en ambas columnas).
*/
SELECT referencia_pago, orden_cun, valor_financiacion, ESTADO_FINANCIACION, t.*
FROM iceberg.cltiene_360_estudiantes t 
WHERE numero_documento IN ('1030660896', '');  --- Tabla 3



/*-----------------------------------------------------------
SECCIÓN 2: APLICAR EL 50%
-----------------------------------------------------------*/

/* Insertar el pago en la tabla 360 para aplicar el 50%
   - La referencia de pago se obtiene desde la Tabla 1 (campo “tramite”)
   - Se toma de la vista v_inserta_estudiantes_360
*/
INSERT INTO ICEBERG.cltiene_360_estudiantes
SELECT * 
FROM ICEBERG.v_inserta_estudiantes_360  
WHERE numero_documento = '1030660896' 
  AND referencia_pago = '118417700';


/* Validar que el registro se haya insertado correctamente */
SELECT referencia_pago, orden_cun, valor_financiacion, ESTADO_FINANCIACION, t.* 
FROM ICEBERG.cltiene_360_estudiantes t 
WHERE numero_documento = '1037654927' 
  AND referencia_pago = '118401659';


/* Consultar nuevamente en la vista para validar origen de datos */
SELECT * 
FROM ICEBERG.v_inserta_estudiantes_360  
WHERE numero_documento = '1037654927' 
  AND referencia_pago = '118401659';



/*-----------------------------------------------------------
SECCIÓN 3: ACTUALIZAR CONSECUTIVO RPVI
-----------------------------------------------------------*/

/* Actualiza el campo CONSECUTIVO_ACTIVACION en la tabla ORDEN
   tomando el valor de LIQUIDACION correspondiente a la orden y periodo.
   Solo actualiza cuando el consecutivo es NULL.
*/
UPDATE ICEBERG.ORDEN o 
SET o.CONSECUTIVO_ACTIVACION = (
    SELECT l.LIQUIDACION 
    FROM ICEBERG.LIQUIDACION_ORDEN l 
    WHERE o.ORDEN = l.ORDEN 
      AND o.PERIODO = l.PERIODO 
      AND o.ESTADO = l.ESTADO 
      AND o.DOCUMENTO = l.DOCUMENTO 
      AND o.CLIENTE_SOLICITADO = l.CLIENTE
)
WHERE o.PERIODO LIKE '%25%' 
  AND o.ESTADO = 'V' 
  AND o.DOCUMENTO = 'RPVI' 
  AND o.CONSECUTIVO_ACTIVACION IS NULL 
  AND o.CLIENTE_SOLICITADO IN ('1016949319')
  AND EXISTS (
    SELECT 1 
    FROM ICEBERG.LIQUIDACION_ORDEN l 
    WHERE o.ORDEN = l.ORDEN 
      AND o.PERIODO = l.PERIODO 
      AND o.ESTADO = l.ESTADO 
      AND o.DOCUMENTO = l.DOCUMENTO 
      AND o.CLIENTE_SOLICITADO = l.CLIENTE
  );


/* Validar que se haya actualizado correctamente el consecutivo */
SELECT O.*, ROWID 
FROM ICEBERG.ORDEN O 
WHERE O.CLIENTE_SOLICITADO = '1016949319' 
  AND O.DOCUMENTO = 'RPVI';
