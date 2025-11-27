-- LA MARCA DE PAGO ES EL APARTADO DE SINU QUE ESTA EN ROJITO , DEBA QUEDAR EN VERDE 
-- 1. PARA HACER ESO SE DEBE VERIFICAR QUE LA PERSONA HAYA FINANCIACION 
-- 2. VERIFICAR EN ICEBER QUE LA FAMA ESTE LIQUIDAD , Y CUENTE CON LAS CUOTAS ACTIVA IGUAL QUE EN CTAYUDA SI BUSCA FINANCIAR

/*LA EXISTE DOS MASCAS DE PAGO , LA FINANCIERA , Y LA ACCADEMICA , LA FINANCIERA ES LA FAMA LIQUIDADA Y LA ACADEMICA ES FINR17 QUE LA MATRICULA APARESCA EN VERDE */




UPDATE --Modifica los registros existentes en una tabla
--select * from 
  src_enc_liquidacion L 
SET 
  L.est_liquidacion = 1 --1 ES QUITAR MARCA DE PAGO , Y 2 ES COLOCAR
WHERE -- Clausula que determina cuentos registros se actualizaran
  L.id_alum_programa IN (
                          SELECT  
                            P.id_alum_programa
                               --Descomentarear para validar datos
                        /*    , b.num_identificacion       
                              , b.nom_largo
                              , u.cod_unidad
                              , u.nom_unidad
                              , p.cod_periodo                                                          
                     */   FROM 
                            bas_tercero B
                            , src_alum_programa P
                            , src_uni_academica U
                          WHERE 
                            B.id_tercero = P.id_tercero
                            AND B.num_identificacion IN ('1014253764') --Numero de identificacion
                            AND U.cod_unidad = P.cod_unidad
                          --AND P.cod_pensum = '1110' 
                          --AND P.cod_unidad = 'VTE01'
                        )
  AND L.cod_periodo = '25V06';
