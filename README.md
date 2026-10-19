# Análisis de ventas y rentabilidad con PostgreSQL y Power BI

Desarrollé este proyecto para analizar las ventas de un negocio simulado y comparar su desempeño por mes, producto, categoría y canal. Trabajé con PostgreSQL para almacenar y consultar los datos, y con Power BI para preparar la información, relacionar las tablas y construir el reporte interactivo.

Mi objetivo fue seguir el proceso completo: partir de registros de pedidos, definir indicadores con reglas claras y comprobar que los resultados de SQL coincidieran con los de Power BI antes de presentarlos.

**Periodo:** enero a junio de 2026.  
**Moneda:** soles peruanos (S/).  
**Tipo de proyecto:** personal, con datos simulados.

## Qué permite analizar

El reporte responde estas preguntas:

- ¿Cuánto se vendió y qué beneficio bruto generaron las ventas?
- ¿Cómo se distribuyeron las ventas entre los seis meses?
- ¿Qué productos aportaron más beneficio bruto?
- ¿Qué categorías y canales concentraron mayores ventas?
- ¿Cómo cambian los indicadores al seleccionar un mes, una categoría o una ciudad?

## Herramientas utilizadas

| Herramienta | Uso en el proyecto |
| --- | --- |
| PostgreSQL | Almacenamiento de las tablas y consultas de análisis. |
| pgAdmin | Ejecución de scripts y revisión de resultados SQL. |
| Power Query | Preparación de las tablas y asignación de tipos de datos. |
| Power BI Desktop | Modelo de relaciones, medidas DAX y visualización. |
| DAX | Cálculo de indicadores que responden al contexto de filtros. |

## Archivos principales

| Archivo | Contenido |
| --- | --- |
| `README.md` | Descripción del proyecto, reglas de cálculo, medidas y validación. |
| `Ventas_Rentabilidad.pbix` | Archivo de Power BI con el modelo y el reporte interactivo. |
| `Ventas_Rentabilidad.pdf` | Exportación estática de la tabla de validación y del resumen de ventas. |

El PDF permite revisar el resultado visual. La interacción con las segmentaciones y los cálculos del modelo se encuentra en el archivo `.pbix`.

## Datos y modelo

La base de trabajo se llama `portafolio_ventas`. El conjunto simulado contiene 37 pedidos y 74 registros de detalle. De los pedidos, 31 están completados, tres pendientes y tres cancelados.

Importé las cinco tablas relacionadas en lugar de cargar únicamente un resumen mensual. Así pude conservar el detalle necesario para analizar productos, categorías, ciudades y canales desde un mismo modelo.

| Tabla en Power BI | Qué representa | Nivel de detalle |
| --- | --- | --- |
| `clientes` | Clientes y atributos como la ciudad. | Un registro por cliente. |
| `pedidos` | Fecha, cliente, canal y estado de cada pedido. | Un registro por pedido. |
| `detalle_pedido` | Productos incluidos en los pedidos, cantidades, precios, costos y descuentos. | Una línea de producto dentro de un pedido. |
| `productos` | Catálogo de productos y su categoría. | Un registro por producto. |
| `categoria` | Clasificación de los productos. | Un registro por categoría. |

La tabla de categorías de origen se trabajó como `categorias`; en el modelo de Power BI aparece como `categoria`.

### Relaciones

Conservé relaciones de uno a varios y dirección de filtro única desde el lado uno hacia el lado varios.

| Lado uno | Lado varios | Clave de relación |
| --- | --- | --- |
| `clientes` | `pedidos` | `cliente_id` |
| `pedidos` | `detalle_pedido` | `pedido_id` |
| `productos` | `detalle_pedido` | `producto_id` |
| `categoria` | `productos` | `categoria_id` |

Este modelo conserva la estructura relacional del origen. `detalle_pedido` concentra los importes utilizados en los cálculos. Los filtros de ciudad llegan a esta tabla a través de `pedidos`, y los de categoría llegan a través de `productos`.

## Preparación en Power Query

Conecté Power BI a PostgreSQL en modo **Importar**. Esto permite trabajar con una copia de los datos; los cambios del origen se incorporan al actualizar el reporte.

Durante la preparación:

- Simplifiqué los nombres de las consultas.
- Quité las columnas de navegación con contenido de tipo `Table`, conservando las claves necesarias para las relaciones.
- Configuré los identificadores y las cantidades como números enteros.
- Configuré las fechas como tipo fecha.
- Utilicé número decimal fijo para precios, costos y descuentos.
- Mantuve los atributos descriptivos como texto.

Estas transformaciones quedan registradas en los pasos aplicados de Power Query y se vuelven a ejecutar al actualizar los datos.

## Reglas de cálculo

Definí los indicadores con estas reglas:

1. **Solo los pedidos con estado `completado` se consideran ventas.** Los pendientes y cancelados permanecen en el origen, pero quedan fuera de los indicadores comerciales de esta versión.
2. La venta neta de una línea es `cantidad × precio_unitario − descuento_total`.
3. `descuento_total` es el descuento de la línea completa: se resta una sola vez y no se multiplica por la cantidad.
4. El costo de ventas se obtiene de `cantidad × costo_unitario`, usando el costo registrado en el detalle del pedido.
5. El beneficio bruto es la diferencia entre ventas netas y costo de ventas. No descuenta gastos operativos, financieros ni impuestos.
6. Los pedidos se cuentan de forma distinta para evitar duplicarlos cuando incluyen varios productos.
7. El margen se calcula sobre los totales del contexto seleccionado; no es un promedio simple de los márgenes de cada producto.

## Medidas DAX

Creé las seis medidas en `detalle_pedido`. Utilicé medidas para que los resultados se recalculen según las selecciones del reporte.

### Ventas netas

```dax
Ventas Netas =
CALCULATE(
    SUMX(
        detalle_pedido,
        detalle_pedido[cantidad] * detalle_pedido[precio_unitario]
            - detalle_pedido[descuento_total]
    ),
    KEEPFILTERS(pedidos[estado] = "completado")
)
```

`SUMX` evalúa el importe de cada línea. `CALCULATE` aplica la condición de pedido completado y `KEEPFILTERS` la intersecta con los filtros existentes sobre el estado.

### Costo de ventas

```dax
Costo de Ventas =
CALCULATE(
    SUMX(
        detalle_pedido,
        detalle_pedido[cantidad] * detalle_pedido[costo_unitario]
    ),
    KEEPFILTERS(pedidos[estado] = "completado")
)
```

### Beneficio bruto

```dax
Beneficio Bruto =
[Ventas Netas] - [Costo de Ventas]
```

### Pedidos completados

```dax
Pedidos Completados =
CALCULATE(
    DISTINCTCOUNT(detalle_pedido[pedido_id]),
    KEEPFILTERS(pedidos[estado] = "completado")
)
```

Conté los pedidos desde el detalle para que la medida también responda a los filtros de producto y categoría. Si un pedido contiene productos de varias categorías, puede aparecer en el conteo de cada una; por eso, esos subtotales de pedidos no deben sumarse para obtener el total general.

### Margen bruto

```dax
Margen Bruto =
DIVIDE([Beneficio Bruto], [Ventas Netas])
```

Apliqué formato de porcentaje con dos decimales. No multipliqué la fórmula por 100. `DIVIDE` devuelve un resultado vacío cuando el denominador es cero.

### Ticket promedio

```dax
Ticket Promedio =
DIVIDE([Ventas Netas], [Pedidos Completados])
```

Sin filtros de producto o categoría, representa la venta neta promedio por pedido completado. Al filtrar una categoría, muestra las ventas de esa categoría divididas entre los pedidos que la contienen; no incluye el resto del importe de esos pedidos.

### Agrupación mensual

Creé esta columna calculada en `pedidos`:

```dax
Mes =
FORMAT(pedidos[fecha], "yyyy-MM")
```

El formato permite ordenar los meses cronológicamente como texto. En esta versión lo utilicé para agrupar las ventas de los seis meses; no implementé cálculos de inteligencia de tiempo con una tabla calendario.

## Diseño del reporte

### Resumen de Ventas

La página principal contiene:

- Seis tarjetas: ventas netas, beneficio bruto, costo de ventas, pedidos completados, margen bruto y ticket promedio.
- Un gráfico de líneas con las ventas netas por mes.
- Un gráfico de barras con el beneficio bruto por producto, ordenado de mayor a menor.
- Dos gráficos de barras para comparar ventas por categoría y canal.
- Tres segmentaciones: mes, categoría y ciudad.
- Conclusiones generales del semestre.

Elegí las barras para comparar magnitudes y el gráfico de líneas para observar la distribución mensual. Los indicadores monetarios se muestran en soles y el margen, como porcentaje.

Las segmentaciones permiten explorar distintos grupos de datos. Las conclusiones escritas corresponden al semestre completo y **no cambian al aplicar filtros**, tal como se indica en la página.

### Validación

Conservé una página con una tabla de las seis medidas para contrastar los totales con SQL. En el archivo entregado esta página aparece como **Página 1**.

## Validación contra SQL

Antes de dar por terminados los indicadores, comparé los resultados de Power BI con las consultas SQL. Ambos cálculos consideran únicamente pedidos completados.

| Indicador | Total sin filtros |
| --- | ---: |
| Ventas netas | S/ 30,050.00 |
| Costo de ventas | S/ 19,720.00 |
| Beneficio bruto | S/ 10,330.00 |
| Pedidos completados | 31 |
| Margen bruto | 34.38 % |
| Ticket promedio | S/ 969.35 |

También utilicé el resumen mensual como referencia:

| Mes | Pedidos completados | Ventas netas |
| --- | ---: | ---: |
| 2026-01 | 7 | S/ 7,235.50 |
| 2026-02 | 4 | S/ 3,294.50 |
| 2026-03 | 6 | S/ 6,465.50 |
| 2026-04 | 4 | S/ 3,294.50 |
| 2026-05 | 6 | S/ 6,465.50 |
| 2026-06 | 4 | S/ 3,294.50 |
| **Total** | **31** | **S/ 30,050.00** |

### Consulta mensual de referencia

```sql
SELECT
    DATE_TRUNC('month', p.fecha)::DATE AS mes,
    COUNT(DISTINCT p.pedido_id) AS pedidos_completados,
    SUM(d.cantidad) AS unidades_vendidas,
    SUM(
        d.cantidad * d.precio_unitario - d.descuento_total
    ) AS ventas_netas,
    SUM(d.cantidad * d.costo_unitario) AS costo_total,
    SUM(
        d.cantidad * (d.precio_unitario - d.costo_unitario)
        - d.descuento_total
    ) AS beneficio_bruto,
    ROUND(
        100.0 * SUM(
            d.cantidad * (d.precio_unitario - d.costo_unitario)
            - d.descuento_total
        ) / NULLIF(
            SUM(d.cantidad * d.precio_unitario - d.descuento_total),
            0
        ),
        2
    ) AS margen_bruto_porcentaje,
    ROUND(
        SUM(d.cantidad * d.precio_unitario - d.descuento_total)
        / NULLIF(COUNT(DISTINCT p.pedido_id), 0),
        2
    ) AS ticket_promedio
FROM pedidos AS p
JOIN detalle_pedido AS d
    ON d.pedido_id = p.pedido_id
WHERE p.estado = 'completado'
GROUP BY DATE_TRUNC('month', p.fecha)::DATE
ORDER BY mes;
```

La consulta agrupa por mes y cuenta los pedidos una sola vez aunque tengan varias líneas. `NULLIF` evita dividir entre cero. En SQL el margen se expresa entre 0 y 100; en DAX se conserva como proporción y se presenta mediante el formato porcentaje.

## Resultados principales

### Enero concentró las mayores ventas

Enero registró S/ 7,235.50, aproximadamente el 24.08 % de las ventas del semestre. Tuvo siete pedidos completados, un beneficio bruto de S/ 2,485.50 y un ticket promedio de S/ 1,033.64.

Para explicar su diferencia frente a otros meses, compararía el número de pedidos, el ticket y la composición de productos. El total mensual por sí solo no permite identificar una causa.

### El monitor de 24 pulgadas aportó el mayor beneficio bruto

El monitor generó S/ 2,502.50 de beneficio bruto sobre S/ 8,352.50 de ventas netas. Su margen fue de 29.96 % y aportó aproximadamente el 24.23 % del beneficio bruto total.

Distinguí ambos porcentajes: el margen relaciona el beneficio del monitor con sus propias ventas; la participación lo relaciona con el beneficio de todos los productos. Liderar en beneficio absoluto no implica tener el mayor margen porcentual.

### Tecnología lideró en ventas por categoría

Tecnología acumuló S/ 15,912.50, equivalentes al 52.95 % de las ventas del semestre. Su beneficio bruto fue S/ 4,932.50 y su margen, 31.00 %.

Aunque concentró más de la mitad de las ventas, su margen estuvo por debajo del margen general de 34.38 %. Esto muestra por qué conviene revisar ventas y rentabilidad de forma conjunta.

### Tienda superó a web en ventas netas

El canal tienda registró mayores ventas acumuladas que web. Este resultado describe la distribución de ventas del conjunto simulado, pero no permite afirmar que los clientes prefieran comprar presencialmente.

Para profundizar, compararía la cantidad de pedidos, el ticket promedio y el margen de cada canal. Las motivaciones de compra requerirían información adicional.

## Cómo revisar el proyecto

### Consultar el resultado

1. Revisar `Ventas_Rentabilidad.pdf` para ver la tabla de validación y el dashboard.
2. Abrir `Ventas_Rentabilidad.pbix` en Power BI Desktop para explorar el reporte interactivo.
3. En **Resumen de Ventas**, seleccionar un mes, una categoría o una ciudad.
4. Consultar los valores y limpiar las selecciones para volver al total del semestre.
5. Comparar los indicadores generales con la tabla de validación.

El archivo se trabajó en modo Importar: los datos ya cargados forman parte del modelo. Consultar esa copia y actualizarla desde PostgreSQL son operaciones diferentes.

### Actualizar desde PostgreSQL

La actualización requiere tener disponible la base original y sus datos. El `.pbix` y la consulta mensual de este README no sustituyen los scripts de creación y carga.

1. Disponer de la base `portafolio_ventas` y las cinco tablas de origen.
2. Configurar la conexión PostgreSQL en Power BI Desktop. La conexión local utilizada durante el desarrollo fue `localhost:5432`.
3. Ajustar servidor y base de datos si el entorno es diferente e introducir las credenciales del servidor correspondiente.
4. Comprobar que la consulta `categoria` mantiene su correspondencia con la tabla de categorías del origen.
5. Actualizar los datos y contrastar los seis indicadores con los resultados de referencia, siempre que se conserve el mismo conjunto simulado.

## Alcance y limitaciones

- Los datos son simulados. Los resultados sirven para demostrar el proceso de análisis, no para describir un negocio real.
- Las repeticiones de importes entre meses provienen del patrón de generación; no demuestran estacionalidad.
- El beneficio mostrado es bruto. No representa utilidad neta ni incorpora gastos operativos.
- El reporte se limita a seis meses y no incluye comparaciones interanuales, metas ni pronósticos.
- Las conclusiones son texto estático; los visuales y medidas sí responden a los filtros.
- La versión entregada corresponde a Power BI Desktop y una exportación PDF. No incluye publicación en Power BI Service ni actualización programada.

## Qué desarrollé y qué ampliaría

En este proyecto trabajé la conexión entre PostgreSQL y Power BI, la preparación de datos en Power Query, las relaciones entre tablas y el cálculo de indicadores con DAX. La comprobación contra SQL me permitió revisar la lógica de los indicadores antes de centrarme en el diseño.

En una siguiente versión incorporaría una tabla calendario, comparaciones contra el mes anterior y una página de detalle por producto. También separaría el análisis de pedidos pendientes y cancelados para estudiar su distribución sin mezclarlos con las ventas completadas.

---

**Autora:** Daniela Araceli Gómez Flores  
**Proyecto personal de portafolio | Ingeniería de Software**
