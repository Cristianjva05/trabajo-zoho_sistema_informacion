/***********************************************************************************************
PROCESO: Ajuste de porcentaje según promoción
------------------------------------------------------------------------------------------------
DESCRIPCIÓN GENERAL:
Este proceso valida y ajusta los descuentos o promociones aplicables a los estudiantes
nuevos en el sistema ICEBERG. 

Antes de aplicar cualquier promoción, se debe verificar en el sistema SINU que el 
estudiante **no sea antiguo**, ya que las promociones solo aplican para estudiantes nuevos.

------------------------------------------------------------------------------------------------
VALIDACIONES PRINCIPALES:
1. Confirmar si la línea del estudiante está creada en la tabla **CLTIENE_360_FUERZA_COMERCIAL**.
2. Revisar los descuentos activos en **CUNT_DATOS_AVAL_X_FUERZA**.
3. Validar en **CUNT_ALUMNOS_ORDENES_X_PERIODO**:
   - Que la persona tenga la clase actual correspondiente al periodo.
   - Que el campo “NUEVO” indique que es estudiante nuevo.
   - Que los datos coincidan con los registros visibles en el módulo 360.
4. En caso de no tener actualizadas las promociones, ejecutar los procedimientos
   que recalculan los descuentos por periodo (SP: `cup_reportes_matriculas.recupera_datos_matriculas`).

------------------------------------------------------------------------------------------------
TABLAS Y OBJETOS INVOLUCRADOS:
- ICEBERG.CLTIENE_360_FUERZA_COMERCIAL → Contiene la relación entre estudiantes y fuerza comercial.
- ICEBERG.CUNT_DATOS_AVAL_X_FUERZA → Registra los descuentos y promociones activas.
- ICEBERG.CUNT_ALUMNOS_ORDENES_X_PERIODO → Muestra información académica del estudiante 
  (estado, tipo de inscripción, clase actual, etc.).
- Procedimiento: `cup_reportes_matriculas.recupera_datos_matriculas` → 
  Recalcula o actualiza las promociones en los periodos definidos.

***********************************************************************************************/


/*-----------------------------------------------------------
SECCIÓN 1: VALIDACIÓN DE LÍNEA EN 360
-----------------------------------------------------------*/

/* Verificar si la línea del estudiante está creada en el módulo 360 */
SELECT c.*, rowid 
FROM ICEBERG.CLTIENE_360_FUERZA_COMERCIAL c  
WHERE c.NUMERODOCUMENTO IN ('40612531');



/*-----------------------------------------------------------
SECCIÓN 2: CONSULTA DE DESCUENTOS ACTIVOS
-----------------------------------------------------------*/

/* Consultar los descuentos o promociones activas en el sistema */
SELECT *  
FROM ICEBERG.CUNT_DATOS_AVAL_X_FUERZA cdaxf;

/* Ajustar fecha de vencimiento de grupo de facturacion */

SELECT * FROM ICEBERG.VENCIMIENTO_PERIODO
WHERE PERIODO = '25P06' AND 
GRUPO = '' ;


/*-----------------------------------------------------------
SECCIÓN 3: VALIDACIÓN DE CLASE ACTUAL Y ESTADO DEL ESTUDIANTE
-----------------------------------------------------------*/

/* Validar si el estudiante cuenta con la clase actual correspondiente al periodo.
   - La línea debe aparecer marcada como NUEVO.
   - Debe coincidir con la información registrada en 360.
   - Solo así aplican los descuentos por promoción.
*/
SELECT c.NUEVO, c.TIP_INSCR, c.CLASE_ACTUAL, c.*
FROM ICEBERG.CUNT_ALUMNOS_ORDENES_X_PERIODO c
WHERE c.DOC_ALUM IN ('40612531', '') 
  AND c.DOCUMENTO = 'FAMA';



/*-----------------------------------------------------------
SECCIÓN 4: ACTUALIZACIÓN DE PROMOCIONES PENDIENTES
-----------------------------------------------------------*/

/* Ejecutar procedimientos que recalculan o actualizan los descuentos/promociones
   para los periodos indicados. 
   (Se recomienda ejecutar uno por uno según el periodo necesario)
*/
CALL cup_reportes_matriculas.recupera_datos_matriculas('26ES1');
CALL cup_reportes_matriculas.recupera_datos_matriculas('25ET5');
CALL cup_reportes_matriculas.recupera_datos_matriculas('2026A');
CALL cup_reportes_matriculas.recupera_datos_matriculas('25ES4');
CALL cup_reportes_matriculas.recupera_datos_matriculas('25E05');
CALL cup_reportes_matriculas.recupera_datos_matriculas('26ES1');

