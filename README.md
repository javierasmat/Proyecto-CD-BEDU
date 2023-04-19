# Proyecto para Ciencia de Datos (Demo Day)
## :rocket: Proyecto: Causas de Siniestralidad en Seguros de Vida (ultimos 4 años)
**Data Science - BEDU**   
*Javier E. Asmat Venegas*   

![imagen](imagenes/seguro_vida.jpg)
###### [Imagen de rawpixel.com en Freepik](https://www.freepik.es/vector-gratis/ilustracion-seguro-vida_2605710.htm#page=2&query=seguro%20vida&position=25&from_view=keyword&track=ais)
---

### :capital_abcd: Introducción
El proyecto se basa en datos reales obtenidos de los ultimos 4 años de una compañia de seguros. Los datos corresponden a los siniestros ocurridos en dicho periodo de tiempo obteniendose entre otros
datos las causas de dicho siniestro. Se evaluo solo casos de personas fallecidas. Dentro de la información que se evalua además de las causas del fallecimiento se considera el sexo y la edad de la
persona fallecida.

### :dart: Objetivos y Tareas

- Obtener los datos de un modelo de base de datos relacional y extraer los datos a un formato CSV.

- Realizar análisis exploratorio de los datos con el fin de obtener estadísticas sobre los datos obtenidos.

- Utilizar __Python__ sobre la IDE __Jupyter Notebooks__ para realizar labores de predicción, clasificación, entre otras posibles.

- Realizar labores de limpieza de los datos con el fin de tener un conjunto de datos limpio y bien estructurado que permita realizar las tareas de predicción y/o clasificación.

- Con base en el campo que nos permite determinar si el paciente tuvo COVID o no, evaluaremos diferentes modelos de regresión y clasificación con el fin de encontrar el mejor posible para 
predecir este dato en otros asegurados.

---

### :ballot_box_with_check: Obtención y extracción de los datos

Los datos se obtuvieron de una Base de Datos __ORACLE__ pues en ella se encuentran los datos sobre los que realizaremos
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

<details><summary><strong>Análisis de tendencia central y visual por medio de Pandas (<em><a href="notebooks/eda.ipynb">notebook</a>)</em></strong> </summary>
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

	El siguiente diagrama confirma los resultados anteriores. Los bigotes nos indican que los valores de 18 y 95 son *raros* por lo que se consideran atípicos.

	![imagen](imagenes/boxplot.png)

	Dato que también podemos comprobar con un histograma. Los valores más elevados corresponden con el promedio y los más pequeños con los valores atípicos que muestra el diagrama de caja.

	![imagen](imagenes/histograma.png)

**Variables categóricas**

- Moda de algunas de las variables

  ```
  region   sex  alcohol  tobacco  khat  pain_swallowing  weight_loss
  OROMIA   0.0      1.0      1.0   1.0              1.0          1.0
  ```
  ```   
   cough  status_patient  
     1.0             1.0  
  ```

  Interpretación:

  - La mayoría de casos se encuentran en OROMIA.
  - La mayoría de casos son del genero '0'.
  - La mayoría de casos toman alcohol.
  - La mayoría de casos fuman tabaco.
  - La mayoría de casos fuman khat.
  - La mayoría de casos tienen dolor al tragar.
  - La mayoría de casos perdieron peso.

- Tabla de contingencia (causas)

   ```
   khat            0            1             total
   alcohol         0     1      0      1           
   tobacco         0  1  0   1  0   1  0    1      
   status_patient                                  
   0               0  0  0  10  1   4  0   24    39
   1               6  6  4  66  8  37  3  180   310
   total           6  6  4  76  9  41  3  204   349
   ```

   ![imagen](imagenes/causas.png)

   Algunas interpretaciones:

   - 204 personas tomaban alcohol y fumaban tanto tabaco como khat de las cuales sobrevivieron 24 y fallecieron 180.
   - 76 personas tomaban alcohol y fumaban tabaco pero no khat de las cuales sobrevivieron 10 y fallecieron 66.
   - 6 personas no tomaban alcohol y no fumaban ni tabaco ni khat de las cuales fallecieron todas.

- Tabla de contingencia (síntomas)

   ```
   pain_swallowing  0          1              total
   cough            0   1      0       1           
   weight_loss      0   0  1   0  1    0    1      
   status_patient                                  
   0                1   2  1   1  0    9   25    39
   1                1   8  6  11  6  109  169   310
   total            2  10  7  12  6  118  194   349
   ```

   ![imagen](imagenes/sintomas.png)

   Algunas interpretaciones:

   - 118 personas tuvieron dolor al tragar y tos pero no perdieron peso, de las cuales sobrevivieron 9 y fallecieron 109.
   - 194 personas tuvieron dolor al tragar, todos y perdida de peso, de las cuales sobrevivieron 25 y fallecieron 169.
   - 12 personas tuvieron dolor al tragar, no tuvieron tos ni perdida de peso, de las cuales sobrevivió 1 y fallecieron 11,

- Tabla de contingencia (tratamiento)

   ```
   chemotherapy      0              1           total
   radiotherapy      0       1      0      1         
   surgery           0    1  0  1   0   1  0  1      
   status_patient                                    
   0                 2   17  1  1  10   4  2  2    39
   1               109  120  6  4  46  15  7  3   310
   total           111  137  7  5  56  19  9  5   349
   ```

   ![imagen](imagenes/tratamiento.png)


   Algunas interpretaciones:

   - 56 personas fueron tratadas con quimiterapia sin radioterapia ni cirugía de las cuales 10 sobrevivieron y 46 murieron.
   - 137 personas fueron operadas, no tuvieron quimiterapia ni radioterapia, de las cuales 17 sobrevivieron y 120 murieron.
   - 111 personas no recibieron ningún tratamiento, de las cuales 2 sobrevivieron y 109 murieron.

</p>
</details>

Al finalizar esta etapa, se pudo apreciar que el conjunto de datos podría no ser útil para detectar patrones de supervivencia pero sí de fallecimiento.

---

### :ballot_box_with_check: Clasificación

A continuación se muestran algunas técnicas de predicción basadas en clasificación.

Para realizar el entrenamiento con todos los modelos se siguieron los siguientes pasos:

1. Como datos de entrada se eligieron todos los campos menos la llave primaria, la región y por supuesto la columna que nos indica el estado del paciente.

1. Como dato de salida se eligió únicamente el estado del paciente.

1. Separar el conjunto de datos en entrenamiento y prueba (70%/30%).

1. Realizar el entrenamiento.

Para analizar los resultados se usó una matriz de confusión.

![imagen](imagenes/matriz_interp.png)

Una interpretación de los resultados de esta matriz, se puede dar mediante las siguientes fórmulas:

1. Precisión: De todas las clasificaciones positivas que hicimos, ¿cuántas de ésas eran en realidad positivas?
   
   *precision = VP / (VP + FP)*

1. Exactitud: Del total de clasificaciones que hicimos, ¿cuántas fueron clasificadas correctamente?
   
   *exactitud = (VP + VN) / (VP + FN + FP + VN)*

1. Sensibilidad: De todas las clasificaciones positivas que había en realidad, ¿cuántas fueron clasificadas correctamente como positivas?
   
   *sensibilidad = VP / (VP + FN)*

1. Especificidad: De todas las clasificaciones negativas que había en realidad, ¿cuántas fueron clasificadas correctamente como negativas?
   
   *especificidad = VN / (VN + FP)*


Adicionalmente se aplicó PCA para reducir el número de columnas. Con este paso se pretende comparar si todos los modelos definidos tienen alguna mejora. En este caso, ninguno de los modelos presentó una mejora considerable por lo que no se muestan en este documento, sin embargo pueden observarse en el *notebook* de cada modelo. Los resultados de PCA se guardaron en un archivo CSV ([_**notebook**_](notebooks/pca.ipynb)).

El número de componentes se elegió estableciente la varianza de las componentes. En este caso se usó una varianza del 95%. Como referencia se consultó [esta referencia](https://www.mikulskibartosz.name/pca-how-to-choose-the-number-of-components/).

<br/>

<u>**Regresión Lineal**</u>

Se inició este proyecto con la idea de encontrar alguna correlación entre las distintas variables. Sin embargo al sólo contar con una variable cuantitativa, de descartó el uso de una regresión lineal. Esto se puede corroborar con la siguiente gráfica de pares.

<details><summary><strong>Gráfica de pares (<em><a href="notebooks/regresion.ipynb">notebook</a>)</em></strong> </summary>
	<p>

![imagen](imagenes/regresion.png)

</p>
</details>
<br/>

<u>**Clasificación Supervisada**</u>

Podemos usar los datos para *predecir* si un paciente puede o no sobrevivir usando un método de Clasificación Binaria Supervisada dado que sólo tenemos dos posibles valores. Se optó por emplear tres técnicas de clasificación.

<details><summary><strong>Regresión logística (<em><a href="notebooks/logistica.ipynb">notebook</a>)</em></strong> </summary>
	<p>

Podemos usar regresión logística en este caso la cuál modela el problema por medio del *sigmoidal* que permite dejar los valores en cero de un lado y los de uno en el otro:

<img src="imagenes/sigmoidal.png" width="300" height="300">

Para el modelo generado se obtuvo la siguiente matriz:

![imagen](imagenes/matriz_confusion.png)

Interpretación:

```
Precision: 0.941747572815534
Exactitud: 0.9428571428571428
Sensibilidad: 1.0
Especificidad: 0.25
```

Lo cual nos dice que la precisión, exactitud y sensibilidad es bastante buena. Sin embargo la especificad es muy baja lo cual indica que hubo muchos datos que fueron incorrectamente clasificados como negativos. Dicho de otra forma, el modelo fue bueno para clasificar fallecimientos pero no tanto para sobrevivientes. Esto se debe quizá a que tenemos más datos de fallecimientos.

</p>
</details>

<details><summary><strong>Árboles de Decisión (<em><a href="notebooks/random_forest.ipynb">notebook</a>)</em></strong> </summary>
<p>

La idea detrás de un árbol de decisión consiste en ir tomando decisiones de forma encadenada e ir descartando soluciones hasta quedarnos con una sola salida, en este caso el valor de la variable `status_patient`. De esta forma el método llamado *random forest*, consiste en tomar varios árboles (bosque) con las siguientes características:

1. Cada árbol de decisión debe ser independiente.
1. Cada árbol debe ser entrenado aleatoriamente,
1. La información que reciben los árboles debe ser distinta para que se basen en distintas características.

Una vez que todos los árboles se han entrenado, se hace un *consenso* para decidir el resultado de una predicción. Cada uno de los árboles *vota* y la clase más votada es la que define a qué clase pertenece el dato.

En este caso se hizo el mismo proceso que con la regresión logística: se separo el conjunto en entrenamiento y prueba, se entrenó y se midió el desempeño usando una matriz de confusión y las fórmulas para interpretar los resultados.

![imagen](imagenes/matriz_rf.png)

```
Precision: 0.9320388349514563
Exactitud: 0.9238095238095239
Sensibilidad: 0.9896907216494846
Especificidad: 0.125
```

Donde vemos que nuevamente la especificidad es bastante baja.

Cada uno de los árboles tiene una forma similar a la siguiente. Se muestra en el ejemplo el árbol 18 del bosque.

![imagen](imagenes/arbol.png)

</p>
</details>

<details><summary><strong>Naïve Bayes (<em><a href="notebooks/naive_bayes.ipynb">notebook</a>)</em></strong> </summary>
<p>	

Este clasificador se basa en la noción de las características de un objeto que contribuyen a su categorización. Se muestran de la misma manera su matriz de confusión y métricas.

![imagen](imagenes/bayes.png)

Interpretación:

```
Precision: 0.8333333333333334
Exactitud: 0.2571428571428571
Sensibilidad: 0.16666666666666666
Especificidad: 0.8
```

En este caso aunque mejoró considerablemente la especificidad, la exactitud y sensibilidad bajaron demasiado.

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
Precision: 0.89937106918239
Exactitud: 0.47564469914040114
Sensibilidad: 0.4612903225806452
Especificidad: 0.5897435897435898
```

Notamos como de todos nuestros modelos fue el peor evaluado.

</p>
</details>

---

### :ballot_box_with_check: Conclusiones

Con base en los distintos trabajos de análisis y definición de modelos se dan las siguientes conclusiones:

- Los conjuntos de datos originales no son iguales entre sí, por lo que se deben analizar por separado al tener columnas distintas. Motivo por el cuál sólo se hizo el análisis sobre casos de Cáncer de Esófago.

- La edad promedio de personas con cáncer de esófago ronda los 50 años (para esta muestra).

- Hay algunos casos *raros* con pacientes de 18 y 95 años.

- En su mayoría los casos se encontraron en OROMIA, las posibles causas se deben a que los pacientes toman alcohol y fuman. En su mayoría tuvieron síntomas como tos, dolor al tragar y pérdida de peso.

- No es posible hacer una regresión lineal dado que la mayoría de datos son categóricos.

- Los mejores modelos de predicción fueron la regresión logística y los árboles de decisión con diferencias mínimas.

- No se sugiere usar el conjunto de datos para detectar si el paciente vivirá, esto se puede apreciar con el cálculo de la especificidad en todos los modelos que se definieron. En todos los casos fue bajo, lo cual nos indica que los datos fueron incorrectamente clasificados como negativos en su mayoría.

---

### :ballot_box_with_check: Trabajo a futuro

- Limpiar e integrar todos los conjuntos de datos.

- Recabar información sobre las categorías incluidas en los conjuntos de datos pues algunos datos son desconocidos tales como el género (¿qué significa 0 y qué 1?).

- Replicar el proceso para los datos de cáncer colorectal y de próstata. Es probable que con estos conjuntos de datos sí sea posible determinar si el paciente vivirá. 

- Recabar nuevos datos para detectar otros tipos de cancer, integrando en este caso algunos datos cuantitativos además de la edad.
