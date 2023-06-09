# Proyecto para Ciencia de Datos (Demo Day)
## :rocket: Proyecto: Siniestralidad por COVID y otras causas en Seguros de Vida (ultimos 4 años)
**Data Science - BEDU**   
*Javier E. Asmat Venegas*   

![imagen](imagenes/seguro_vida.jpg)
###### [Imagen de rawpixel.com en Freepik](https://www.freepik.es/vector-gratis/ilustracion-seguro-vida_2605710.htm#page=2&query=seguro%20vida&position=25&from_view=keyword&track=ais)
---

### :capital_abcd: Introducción
El proyecto se basa en datos reales obtenidos de los ultimos 4 años de una compañia de seguros. Los datos corresponden a los siniestros ocurridos en dicho periodo de tiempo obteniendose entre otros
datos las causas de dicho siniestro (COVID y otras causas). Se evaluo casos de personas fallecidas como vivas. Dentro de la información que se evalua además de las causas del siniestro se considera el sexo y la edad de la
persona o asegurado.

### :dart: Objetivos y Tareas

- Obtener los datos de un modelo de base de datos relacional y extraer los datos a un formato CSV.

- Realizar análisis exploratorio de los datos con el fin de obtener estadísticas sobre los datos obtenidos.

- Utilizar __Python__ sobre la IDE __Jupyter Notebooks__ para realizar labores de predicción, clasificación, entre otras posibles.

- No fue necesario realizar labores de limpieza de los datos pues previamente se obtuve desde una BD con datos ya limpios. Esto permite realizar las tareas de predicción y/o clasificación sin mayor proceso.

- Con base en el campo que nos permite determinar si el paciente tuvo COVID o no, evaluaremos diferentes modelos de regresión y clasificación con el fin de encontrar el mejor posible para 
predecir este dato en otros asegurados.

---

### :ballot_box_with_check: Obtención y extracción de los datos

Los datos se obtuvieron de una Base de Datos __ORACLE__ pues en ella se encuentran estos sobre los que realizaremos
el análisis exploratorio más detallado. Se contó inicialmente con los siguientes conjuntos de datos:

- [datos_polizas.csv](datasets/datos_polizas.csv)
- [datos_polizas_2.csv](datasets/datos_polizas_2.csv)
- [datos_polizas_3.csv](datasets/datos_polizas_3.csv)
- [datos_siniestros.csv](datasets/datos_siniestros.csv)
- [datos_siniestros_2.csv](datasets/datos_siniestros_2.csv)

Previo a la carga de datos, se reviso la información a recuperar por ello se extrajo tanto de las pólizas en vigor o vigentes como de los siniestros ocurridos en los ultimos 4 años.
Se analizo la información obtenida y derivado de esto se determino que los datos mas acordes **para los fines de este proyecto únicamente son los referentes a los siniestros**.

El proceso de obtención de los datos así como el de extracción de la información se puede consultar en los siguientes scripts:

- [Polizas](scripts/datos_polizas.sql) 
- [Siniestros](scripts/datos_siniestros.sql)

---

### :ballot_box_with_check: Análisis Exploratorio de Datos

<details><summary><strong>Análisis de tendencia central y visual por medio de Pandas (<em><a href="notebooks/aed.ipynb">notebook</a>)</em></strong> </summary>
	<p>

**Variables numéricas (edad)**

- Medidas de tendencia central y variabilidad

	```
    count    10451.000000
    mean        53.721749
    std         13.321296
    min         19.000000
    25%         44.000000
    50%         56.000000
    75%         64.000000
    max         98.000000
   ```

   - La edad promedio es 53.72
   - La edad mínima es 19
   - La edad máxima es 98
   - El 25% de los datos tienen un valor menor a 44
   - El 50% de los datos tienen un valor menor a 56 (mediana)
   - El 75% de los datos tienen un valor menor a 64
   - Rango intercuartilico: 20
   - La desviación estándar es 13.32 (hip: están ligeramente dispersos)

- Diagrama de caja e Histograma

	El siguiente diagrama confirma los resultados anteriores. Los bigotes nos indican que los valores de 19 y 98 son *raros* por lo que se consideran atípicos.

	![imagen](imagenes/boxplot.png)

	Podemos comprobar esto con un histograma. Los valores más elevados corresponden con el promedio y los más pequeños con los valores atípicos que muestra el diagrama de caja.

	![imagen](imagenes/histograma.png)

**Variables categóricas**

- Tabla de contingencia (causa COVID x Sexo x Edad)

   ```
   SEXO	    0	     1	    total
   COVID	0	1	 0	  1	
   EDAD					
   19	    1	0	 3	  0	    4
   20	    0	0	 3	  0	    3
   21	    1	0	 8	  0	    9
   22	    3	0	24	  0	   27
   23	    5	0	21	  0	   26
   ...	...	...	...	...	...
   93   	1	0	 1	  0	    2
   94	    0	0	 1	  0	    1
   97    	1	0	 0	  0	    1
   98	    2	0	 0	  0	    2
   total 2180 417 6318 1536	10451
   ```

   Algunas interpretaciones:

   - 417 mujeres tuvieron un siniestro a causa del COVID.
   - 1536 hombres tuvieron un siniestro a causa del COVID.
   - 8498 personas (hombres y mujeres) fallecieron por otras causas o tuvieron algún siniestro que no causo fallecimiento.

- Tabla de contingencia (siniestros por sospecha de covid)

   ```
   COVID	        0 	       1	total
   SOSPECHA COVID	0	  1	   0	
   SEXO				
     0	         2060	120	 417	2597
     1	         5863	455	1536	7854
   total	     7923	575	1953	10451
   ```

   Algunas interpretaciones:

   - 575 personas (entre hombres y mujeres) tuvieron un siniestro por sospecha de COVID.
   - 1953 personas (entre hombres y mujeres) tuvieron un siniestro a causa de COVID. Los valores coinciden con los mostrados en la tabla anterior.

- Tabla de contingencia (fallecidos y vivos por sexo)

   ```
   FALLECIDO	N	   S	total
   SEXO			
           0  808	1789	 2597
           1 1990	5864	 7854
   total  	 2798	7653	10451
   ```

   Algunas interpretaciones:

   - 2597 mujeres sufrieron algún siniestro de las cuales 808 permanecen vivos y 1789 fallecieron.
   - 7854 hombres sufrieron algún siniestro de los cuales 1990 permanecen vivos y 5864 fallecieron.

- Tabla de contigencia (Sexo x Fallecidos x COVID)

   ```
   FALLECIDO	      N	    S	        total
   COVID	  0	      1	    0	   1	
   SEXO					
       0	782	     26	 1398	 391	 2597
       1	1912	 78	 4406	1458	 7854
   total	2694	104	 5804	1849	10451
   ```

   Algunas interpretaciones:

   - 104 personas que tuvieron COVID sobrevivieron.
   - 1849 personas que tuvieron COVID fallecieron.
   - 26 mujeres sobrevivieron al COVID y 391 fallecieron a causa del COVID.
   - 78 hombres sobrevivieron al COVID y 1458 fallecieron a causa del COVID.

</p>
</details>

Luego de los datos revisados se puede deducir que el conjunto de datos nos permite determinar que asegurados fallecieron y cuales sobrevivieron sea por COVID o por otras causas.

---

### :ballot_box_with_check: Clasificación

A continuación se muestran algunas técnicas de predicción basadas en clasificación.

<details><summary><strong>Matriz de confusión (<em><a href="notebooks/matriz_decision.ipynb">notebook</a>)</em></strong> </summary>

<p>

Para analizar los resultados se usó una matriz de confusión entrenando el 60% de los datos y como prueba 40%. Primero como dato de salida el SEXO

![imagen](imagenes/matriz_confusion.png)

<br/>

Interpretación:

```
Precision     : 75.87370450711015%
Sensibilidad  : 99.74651457541192%
Especificidad :  2.341463414634146%
Exactitud     : 75.86701745993781%
```

Nos dice que la precisión y exactitud son buenas, la sensibilidad es bastante buena. Sin embargo la especificidad es muy baja lo cual indica que hubo muchos datos que fueron incorrectamente clasificados como negativos.

Luego usamos como dato de salida si ha fallecido o a sobrevivido

![imagen](imagenes/matriz_confusion_f.png)

<br/>

Interpretación:

```
Precision     : 89.44281524926686%
Sensibilidad  : 88.77749029754204%
Especificidad : 70.24793388429752%
Exactitud     : 83.95120784501316%
```

Nos dice que la precisión, exactitud y sensibilidad son buenas. La especificidad también es buena, esto nos lleva a deducir que el algoritmo usando este valor de predicción es el adecuado.

</p>
</details>

<details><summary><strong>Grafica de pares (<em><a href="notebooks/grafica_pares.ipynb">notebook</a>)</em></strong> </summary>

<p>

Se observa en la grafica siguiente que no existe correlación entre las variables por lo que realizar una regresión lineal no es la opción.

![imagen](imagenes/graficas_pares.png)

</p>
</details>

<br/>

<strong>Clasificación Supervisada</strong>
<p>
Usaremos los datos para predecir el fallecimiento o sobreviviencia de un asegurado. Optaremos por usar las siguientes técnicas de clasificación.
</p>

<details><summary><strong>Árboles de Decisión (<em><a href="notebooks/arbol_decision.ipynb">notebook</a>)</em></strong> </summary>
<p>

La idea detrás de un árbol de decisión consiste en ir tomando decisiones de forma encadenada e ir descartando soluciones hasta quedarnos con una sola salida, en este caso el valor de la variable `FALLECIDO`. De esta forma el método llamado *random forest*, consiste en tomar varios árboles (bosque) con las siguientes características:

1. Cada árbol de decisión debe ser independiente.
1. Cada árbol debe ser entrenado aleatoriamente,
1. La información que reciben los árboles debe ser distinta para que se basen en distintas características.

Una vez que todos los árboles se han entrenado, se hace un *consenso* para decidir el resultado de una predicción. Cada uno de los árboles *vota* y la clase más votada es la que define a qué clase pertenece el dato.

En este caso se hizo el mismo proceso que con la regresión logística: se separo el conjunto en entrenamiento y prueba, se entrenó y se midió el desempeño usando una matriz de confusión y las fórmulas para interpretar los resultados.

![imagen](imagenes/matriz_rf.png)

```
Precision     : 91.62595952547103%
Sensibilidad  : 86.04193971166448%
Especificidad : 78.7422497785651%
Exactitud     : 84.070796460177%
```

Vemos nuevamente que los valores de precisión, sensibilidad, especificidad y exactitud son buenos. También se observa que la precisión y especificidad mejoro respecto a la primera matriz de decisión obtenida.

Cada uno de los árboles tiene una forma similar a la siguiente. Se muestra en el ejemplo el árbol 8 del bosque.

![imagen](imagenes/arbol.png)

</p>
</details>

<details><summary><strong>Naïve Bayes (<em><a href="notebooks/naive_bayes.ipynb">notebook</a>)</em></strong> </summary>
<p>	

Este clasificador se basa en la noción de las características de un objeto que contribuyen a su categorización. Se muestran de la misma manera su matriz de confusión y métricas.

![imagen](imagenes/bayes.png)

Interpretación:

```
Precision     : 96.64948453608247%
Sensibilidad  : 61.75889328063241%
Especificidad : 94.32314410480349%
Exactitud     : 70.67687156182731%
```

En este caso aunque mejoró la precisión y la especificidad, la exactitud y sensibilidad bajaron demasiado.

</p>
</details>

<details><summary><strong>Red Neuronal (<em><a href="notebooks/red_neuronal.ipynb">notebook</a>)</em></strong> </summary>
<p>	

Este clasificador puede entrenar con cualquier clase de dato numerico. Se muestran de la misma manera su matriz de confusión y métricas.

![imagen](imagenes/neuronal.png)

Interpretación:

```
Precision     : 91.23108665749656%
Sensibilidad  : 86.75604970569%
Especificidad : 77.29296527159394%
Exactitud     : 84.2143027983736%
```

En este caso los valores obtenidos se asemejan a los obtenidos en el arbol de decisión.

</p>
</details>
<br/>

<u>**Clasificación No Supervisada**</u>

Podemos usar la clasificación No Supervisada como una alternativa que permita clasificar los casos correctamente mediante clusterización, de forma tal que si el modelo genera correctamente las clases, podemos usar el modelo como predictor. En esta caso usamos los datos originales para comparar con la salida de nuestro modelo. Para este caso se obtó por usar *K-Means*.

<details><summary><strong>K-Means (<em><a href="notebooks/kmeans.ipynb">notebook</a>)</em></strong> </summary>
<p>	

Este algoritmo muy útil cuando tenemos un dataset que queremos dividir por grupos pero no sabemos exactamente qué grupos queremos y cuáles son sus características. Lo único que tenemos que decidir de antemano es cuántos grupos queremos, y el algoritmo intentará agrupar nuestros datos en esa cantidad de grupos.

Se obtuvo la siguiente matriz:

![imagen](imagenes/kmeans.png)

Interpretación:

```
Precision     : 50.14018691588785%
Sensibilidad  : 28.041290996994643%
Especificidad : 23.731236597569694%
Exactitud     : 26.887379198162854%
```

De todos nuestros modelos evaluados fue el de peor resultados.

</p>
</details>

---

### :ballot_box_with_check: Conclusiones

Con base en los distintos trabajos de análisis y definición de modelos se dan las siguientes conclusiones:

- Los conjuntos de datos originales no son iguales entre sí, por lo que se deben analizar por separado al tener columnas distintas. Para este caso evaluamos personas fallecidas y con sobrevivencia

- La edad promedio de personas siniestradas ronda los 53 años (para esta muestra).

- Hay algunos casos *raros* con pacientes de 19 y 98 años.

- No es posible hacer una regresión lineal dado que la mayoría de datos son categóricos.

- Los mejores modelos de predicción fueron los árboles de decisión y la red neuronal con diferencias mínimas.

---

### :ballot_box_with_check: Trabajo a futuro

- Limpiar e integrar todos los conjuntos de datos.

- Replicar el proceso para todas las causas de fallecimiento para determinar cual es la mayor causistica y con ello tratar de prevenir a nuestros asegurados para tratar de disminuir esta tasa de mortalidad.

- Recabar nuevos datos para detectar otros motivos de fallecimiento, integrando en este caso algunos datos cuantitativos además de la edad.
