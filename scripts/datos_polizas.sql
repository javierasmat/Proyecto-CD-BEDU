DECLARE
  cCodProd     VARCHAR2(4);
  cLinea       VARCHAR2(4000);
  dFecha       DATE;
  --
  CURSOR c_Prod IS
    SELECT CodProd FROM PRODUCTO WHERE CodProd LIKE 'VI%' AND CodProd NOT IN ('VI29','VI31');
  CURSOR c_Poliza IS
    SELECT IdePol, CodProd, NumPol, CodOfiEmi, codMoneda, TO_CHAR(FecIniVig,'DD-MM-YYYY') AS FecIniVig, 
           TO_CHAR(FecFinVig,'DD-MM-YYYY') AS FecFinVig, TO_CHAR(FecEmi,'DD-MM-YYYY') AS FecEmi, 
           StsPol, NumRen
    FROM POLIZA WHERE CodProd = cCodProd AND dFecha BETWEEN FecInivig AND NVL(Fecanul, FecFinVig) AND ROWNUM <= 550
    ORDER BY IdePol DESC;
  --
  rPol      c_Poliza%ROWTYPE;
  --
  CURSOR c_Asegurado (nIdePol  NUMBER) IS
    SELECT IdeAseg, IdePol, CodPlan, RevPlan, TO_CHAR(FecIng, 'DD-MM-YYYY') AS FecIng,
    (SELECT Sexo FROM CLIENTE WHERE CodCli = aseg.CodCli) AS Sexo,
    (SELECT CEIL(MONTHS_BETWEEN(TRUNC(SYSDATE), FecNac)/12) FROM CLIENTE WHERE CodCli = aseg.CodCli) AS Edad,
    (SELECT DescPlanProd FROM PLAN_PROD WHERE CodProd = cCodProd AND CodPlan = aseg.CodPlan AND RevPlan = aseg.RevPlan) AS DescPlan,
    (SELECT muni.DescMunicipio FROM MUNICIPIO muni, TERCERO terc, CLIENTE clie WHERE muni.CodPais = terc.CodPais 
      AND muni.CodEstado = terc.CodEstado AND muni.CodCiudad = terc.CodCiudad AND muni.CodMunicipio = terc.CodMunicipio
      AND terc.TipoId = clie.TipoId AND terc.SerieId = clie.SerieId AND terc.NumId = clie.NumId
      AND terc.DvId = clie.DvId AND clie.CodCli = aseg.CodCli) AS MunicipioCli,
    (SELECT muni.DescCiudad FROM CIUDAD muni, TERCERO terc, CLIENTE clie WHERE muni.CodPais = terc.CodPais 
      AND muni.CodEstado = terc.CodEstado AND muni.CodCiudad = terc.CodCiudad AND terc.TipoId = clie.TipoId 
      AND terc.SerieId = clie.SerieId AND terc.NumId = clie.NumId AND terc.DvId = clie.DvId 
      AND clie.CodCli = aseg.CodCli) AS CiudadCli,
    (SELECT muni.DescEstado FROM ESTADO muni, TERCERO terc, CLIENTE clie WHERE muni.CodPais = terc.CodPais 
      AND muni.CodEstado = terc.CodEstado AND terc.TipoId = clie.TipoId AND terc.SerieId = clie.SerieId 
      AND terc.NumId = clie.NumId AND terc.DvId = clie.DvId AND clie.CodCli = aseg.CodCli) AS EstadoCli,
    (SELECT terc.zip FROM TERCERO terc, CLIENTE clie WHERE terc.TipoId = clie.TipoId AND terc.SerieId = clie.SerieId 
      AND terc.NumId = clie.NumId AND terc.DvId = clie.DvId AND clie.CodCli = aseg.CodCli) AS CodPostal
    FROM   ASEGURADO aseg
    WHERE  IdePol = nIdePol;
  --
  rAseg    c_Asegurado%ROWTYPE;
  --
  CURSOR c_Coberturas (nIdeAseg  NUMBER) IS
    SELECT CAS.IdeCobert, CAS.CodCobert, CAS.StsCobert, CAS.SumaAsegMoneda, CAS.PrimaMoneda, CAS.Tasa, 
           CAS.MtoRecFijo, (SELECT DescCobert FROM COBERT WHERE CodCobert = CAS.CodCobert) AS NomCobert
    FROM   COBERT_ASEG CAS
    WHERE  CAS.IdeAseg = nIdeAseg;
  --
  rCob    c_Coberturas%ROWTYPE;
BEGIN
  dFecha := TRUNC(SYSDATE);
  --
  OPEN c_Prod;
  LOOP
    FETCH c_Prod INTO cCodProd;
    EXIT WHEN c_Prod%NOTFOUND;
    --
    OPEN c_Poliza;
    LOOP
      FETCH c_Poliza INTO rPol;
      EXIT WHEN c_Poliza%NOTFOUND;
      cLinea := rPol.IdePol||'|'||rPol.CodProd||'-'||rPol.NumPol||'-'||rPol.CodOfiEmi||'|'||rPol.FecIniVig||'|'||rPol.FecFinVig||'|'||rPol.NumRen;
      --
      OPEN c_Asegurado(rPol.IdePol);
      LOOP
        FETCH c_Asegurado INTO rAseg;
        EXIT WHEN c_Asegurado%NOTFOUND;
        cLinea := cLinea||'|'||rAseg.Sexo||'|'||rAseg.Edad||'|'||rAseg.DescPlan||'|'||rAseg.Sexo||'|'||rAseg.Edad||'|'||rAseg.EstadoCli||'|'||rAseg.CiudadCli
                        ||'|'||rAseg.MunicipioCli||'|'||rAseg.CodPostal;
        --
        OPEN c_Coberturas(rAseg.IdeAseg);
        LOOP
          FETCH c_Coberturas INTO rCob;
          EXIT WHEN c_Coberturas%NOTFOUND;
          --
          cLinea := cLinea||'|'||rCob.NomCobert||'|'||rCob.SumaAsegMoneda||'|'||rCob.PrimaMoneda||'|'||rCob.Tasa;
          dbms_output.put_line(cLinea);
        END LOOP;
        CLOSE c_Coberturas;
      END LOOP;
      CLOSE c_Asegurado;
    END LOOP;
    CLOSE c_Poliza;
  END LOOP;
  CLOSE c_Prod;
  END;
/
