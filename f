 FUNCTION GDEFU_VALDIA_PROCESO(p_opcion NUMBER)
    RETURN NUMBER
  IS

  --MES_ACTUAL = Noviembre
     CURSOR cur_mesActual is
     SELECT TO_CHAR(sysdate, 'Month', 'NLS_DATE_LANGUAGE=Spanish') FROM DUAL;

  --MES_COMPARAR = Octubre
     CURSOR cur_comparar is
     SELECT TO_CHAR(sysdate-7, 'Month', 'NLS_DATE_LANGUAGE=Spanish') FROM DUAL;

 v_mesActual      VARCHAR2(100);
 v_mesComparar    VARCHAR2(100);
 vnu_numeses      NUMBER;

 BEGIN

   v_mesActual    := NULL;
   v_mesComparar  := NULL;
   vnu_numeses    := 0;

   OPEN cur_mesActual;
   FETCH cur_mesActual INTO v_mesActual;
   CLOSE cur_mesActual;

   OPEN cur_comparar;
   FETCH cur_comparar INTO v_mesComparar;
   CLOSE cur_comparar;



        IF  v_mesActual = v_mesComparar THEN

           IF p_opcion = 1 THEN

              vnu_numeses  := SUBSTR( GDE.CPFU_GET_VALOR_PARAMGENERALES('IC_NMESI'),1,2);

           END IF;

           IF p_opcion = 2 THEN

              vnu_numeses  := SUBSTR( GDE.CPFU_GET_VALOR_PARAMGENERALES('IC_NMESI'),4,5);

           END IF;

        ELSE

           IF p_opcion = 1 THEN

              vnu_numeses  := SUBSTR( GDE.CPFU_GET_VALOR_PARAMGENERALES('IC_NMESF'),1,2);

           END IF;

           IF p_opcion = 2 THEN

              vnu_numeses  := SUBSTR( GDE.CPFU_GET_VALOR_PARAMGENERALES('IC_NMESF'),4,5);

           END IF;

        END IF;


        IF vnu_numeses = 0 THEN

            INSERT INTO TEMP VALUES
              (TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),NULL,NULL,
              'PR_EJECUTA_CONSUMOS_GDE_ALFA-GDEFU_VALDIA_PROCESO ERROR..PARAMETROS NO CONFIGURADOS IC_NMESI, IC_NMESF ..');
            COMMIT;
        END IF;


        RETURN vnu_numeses;

 EXCEPTION WHEN OTHERS THEN
    --Si se genera un error en el proceso notificarlo
    INSERT INTO TEMP VALUES
      (TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),NULL,NULL,
      'PR_EJECUTA_CONSUMOS_GDE_ALFA - GDEFU_VALDIA_PROCESO ERROR AL VALIDAR DIA..');
    COMMIT;

    RETURN vnu_numeses;

 END GDEFU_VALDIA_PROCESO;
