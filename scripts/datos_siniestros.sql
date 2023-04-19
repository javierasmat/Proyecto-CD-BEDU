DECLARE
  cCodProd     VARCHAR2(4);
  cLinea       VARCHAR2(4000);
  dFecha       DATE;
  c_EsSin      NUMBER(1);
  nCOVID       NUMBER(6);
  nNoCovid     NUMBER(6);
  nTumorMal    NUMBER(6);
  nDiabetes    NUMBER(6);
  nNeumonia    NUMBER(6);
  nParoInf     NUMBER(6);
  nInsuResp    NUMBER(6);
  nInsuRenal   NUMBER(6);
  nCirrosis    NUMBER(6);
  nChoque      NUMBER(6);
  nAcidosis    NUMBER(6);
  nAsfixia     NUMBER(6);
  nOtros       NUMBER(6);
  cSexo        VARCHAR2(1);
  --
  CURSOR c_Prod IS
    SELECT CodProd FROM PRODUCTO WHERE CodProd LIKE 'VI%' AND CodProd NOT IN ('VI29','VI31');
  --
  CURSOR c_Siniestro IS
    SELECT snt.IdeSin, snt.NumSin, snt.CodSin, snt.FecOcurr, snt.IdePol,
           (SELECT (SELECT Descrip FROM LVAL WHERE TipoLval = 'DASINVI' AND CodLval = dpsv.CodDiagnostico) 
             FROM DATOS_PART_SINIESTRO_VIDA dpsv WHERE dpsv.IdeSin = snt.IdeSin) AS Diagnostico,
           (SELECT CodProd||'-'||NumPol||'-'||CodOfiEmi FROM POLIZA WHERE IdePol = snt.IdePol) AS NumPoliza,
           (SELECT Sexo FROM CLIENTE WHERE CodCli = (SELECT CodCli FROM ASEGURADO WHERE IdeAseg = cra.IdeAseg)) AS Sexo,
           (SELECT CEIL(MONTHS_BETWEEN(snt.FecOcurr, FecNac)/12) FROM CLIENTE 
              WHERE CodCli = (SELECT CodCli FROM ASEGURADO WHERE IdeAseg = cra.IdeAseg)) AS Edad,
           NVL((SELECT NVL(IndCobBas, 'N') FROM COBERT_PLAN_PROD WHERE CodProd = snt.CodSin AND CodPlan = cra.CodPlan AND RevPlan = cra.RevPlan
                 AND CodRamoPlan = cra.CodRamoCert AND CodCobert = cra.CodCobert),'N') AS IndFallece,
           NVL((SELECT NVL(SUM(dap.MtoAprobNetoMoneda),0) FROM APROB_SIN asi, DET_APROB dap WHERE asi.IdeSin = snt.IdeSin
              AND dap.IdeSin = asi.IdeSin AND dap.Numaprob = asi.NumAprob AND dap.IdeRes = cra.IdeRes AND asi.StsAprob IN ('PAG','PGP')),0) AS MtoPagado,
           NVL((SELECT NVL(SUM(dap.MtoAprobNetoMoneda),0) FROM APROB_SIN asi, DET_APROB dap WHERE asi.IdeSin = snt.IdeSin
              AND dap.IdeSin = asi.IdeSin AND dap.Numaprob = asi.NumAprob AND dap.IdeRes = cra.IdeRes AND asi.StsAprob = 'ACT'),0) AS MtoAprobado,
           NVL((SELECT NVL(crm.MtoResMoneda,0) FROM COB_RES_MOD crm WHERE crm.IdeSin = snt.IdeSin AND crm.CodPlan = cra.CodPlan AND crm.RevPlan = cra.RevPlan
               AND crm.CodRamoCert = cra.CodRamoCert AND crm.IdeRes = cra.IdeRes AND crm.NumModRes = (SELECT MAX(NumModRes) FROM COB_RES_MOD
                  WHERE IdeSin = snt.IdeSin AND CodPlan = cra.CodPlan AND RevPlan = cra.RevPlan AND CodRamoCert = cra.CodRamoCert
                  AND IdeRes = cra.IdeRes)),0) AS MtoReservado, 
           cra.CodCobert, (SELECT CodDiagnostico FROM DATOS_PART_SINIESTRO_VIDA dpsv WHERE dpsv.IdeSin = snt.IdeSin) AS CodDiag
    FROM   SINIESTRO snt, COB_RES_ASEG cra
    WHERE  snt.StsSin IN ('ACT','PAG','PGP')
    AND    cra.IdeSin = snt.IdeSin AND snt.CodSin = cCodProd
    AND    snt.FecOcurr BETWEEN ADD_MONTHS(dFecha, -48) AND dFecha;
  --
  rSin      c_Siniestro%ROWTYPE;
BEGIN
  dFecha := TRUNC(SYSDATE);
  --
  cLinea := 'ID|IDSIN|NUMSIN|CODSIN|OCURRIDO|DIAGNOSTICO|POLIZA|SEXO|EDAD|FALLECIDO|COVID|SOSPECHA COVID|TUMOR MALIGNO|DIABETES|NEUMONIA|PARO O INFARTO'||
            '|INSUFICIENCIA RESPIRATORIA|INSUFICIENCIA RENAL|CIRROSIS|CHOQUE MEDICO|ACIDOSIS|ASFIXIA|OTRAS CAUSAS';
  dbms_output.put_line(cLinea);
  OPEN c_Prod;
  LOOP
    FETCH c_Prod INTO cCodProd;
    EXIT WHEN c_Prod%NOTFOUND;
    --
    OPEN c_Siniestro;
    LOOP
      FETCH c_Siniestro INTO rSin;
      EXIT WHEN c_Siniestro%NOTFOUND;
      --
      IF rSin.Sexo = 'F' THEN
         cSexo := '0';
      ELSIf rSin.Sexo = 'M' THEN
         cSexo := '1';
      ELSE --No esta definido
         cSexo := '2';
      END IF;
      cLinea := rSin.IdePol||'|'||rSin.IdeSin||'|'||rSin.NumSin||'|'||rSin.CodSin||'|'||rSin.FecOcurr||'|'||rSin.Diagnostico||'|'||rSin.NumPoliza||'|'||
                cSexo||'|'||rSin.Edad||'|'||rSin.IndFallece||'|';
      --Evaluamos diagnostico
      nCOVID := 0;
      nNoCovid := 0;
      nTumorMal := 0;
      nDiabetes := 0;
      nNeumonia := 0;
      nParoInf := 0;
      nInsuResp := 0;
      nInsuRenal := 0;
      nCirrosis := 0;
      nChoque := 0;
      nAcidosis := 0;
      nAsfixia := 0;
      nOtros := 0;
      --
      IF rSin.CodDiag IN ('B972', 'U07.1', 'U071') THEN
         nCOVID := 1;
      ELSIF rSin.CodDiag IN ('U07.2', 'U072') THEN
         nNocovid := 1;
      ELSIF rSin.CodDiag IN ('C18', 'C50') THEN
         nTumorMal := 1;
      ELSIF rSin.CodDiag IN ('E10', 'E14') THEN
         nDiabetes := 1;
      ELSIF rSin.CodDiag IN ('J12', 'J129','J18','J189') THEN
         nNeumonia := 1;
      ELSIF rSin.CodDiag IN ('I21', 'I219','I46') THEN
         nParoInf := 1;
      ELSIF rSin.CodDiag IN ('J96', 'J960') THEN
         nInsuResp := 1;
      ELSIF rSin.CodDiag IN ('N17', 'N18') THEN
         nInsuRenal := 1;
      ELSIF rSin.CodDiag IN ('K703', 'K74') THEN
         nCirrosis := 1;
      ELSIF rSin.CodDiag IN ('R57', 'R570','R571','R579') THEN
         nChoque := 1;
      ELSIF rSin.CodDiag IN ('E872') THEN
         nAcidosis := 1;
      ELSIF rSin.CodDiag IN ('R090') THEN
         nAsfixia := 1;
      ELSE
         nOtros := 1;
      END IF;
      cLinea := cLinea||nCOVID||'|'||nNoCovid||'|'||nTumorMal||'|'||nDiabetes||'|'||nNeumonia||'|'||nParoInf||'|'||nInsuResp||'|'||nInsuRenal||
                '|'||nCirrosis||'|'||nChoque||'|'||nAcidosis||'|'||nAsfixia||'|'||nOtros;
      dbms_output.put_line(cLinea);
    END LOOP;
    CLOSE c_Siniestro;
  END LOOP;
  CLOSE c_Prod;
END;
/
