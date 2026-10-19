-- Validación del proyecto Ventas y Rentabilidad.
-- Ejecutar en la base que contiene las cinco tablas del proyecto.
-- Consultas de lectura: no crean, modifican ni eliminan registros.
-- Referencia: 3 categorías, 6 clientes, 6 productos, 37 pedidos, 74 detalles.
-- Totales completados: ventas 30050.00; costo 19720.00; beneficio 10330.00;
-- pedidos 31; margen 34.38%; ticket promedio 969.35.

SELECT 'categorias' AS tabla, COUNT(*) AS filas FROM public.categorias
UNION ALL SELECT 'clientes', COUNT(*) FROM public.clientes
UNION ALL SELECT 'productos', COUNT(*) FROM public.productos
UNION ALL SELECT 'pedidos', COUNT(*) FROM public.pedidos
UNION ALL SELECT 'detalle_pedido', COUNT(*) FROM public.detalle_pedido;

-- Ejecutar después de cargar 01_base_ventas.sql.
-- Conteos del conjunto completo, incluidos pedidos no completados.
SELECT COUNT(*) AS cantidad_pedidos FROM pedidos;
SELECT COUNT(*) AS cantidad_detalles FROM detalle_pedido;

SELECT estado, COUNT(*) AS cantidad_pedidos
FROM pedidos
GROUP BY estado
ORDER BY estado;

-- Indicadores mensuales: solo pedidos completados.
SELECT
    DATE_TRUNC('month', p.fecha)::DATE AS mes,
    COUNT(DISTINCT p.pedido_id) AS pedidos_completados,
    SUM(d.cantidad) AS unidades_vendidas,
    SUM(d.cantidad * d.precio_unitario - d.descuento_total)
        AS ventas_netas,
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
JOIN detalle_pedido AS d ON d.pedido_id = p.pedido_id
WHERE p.estado = 'completado'
GROUP BY DATE_TRUNC('month', p.fecha)::DATE
ORDER BY mes;

-- Totales generales para comparar con las seis medidas DAX.
WITH resumen AS (
    SELECT
        COUNT(DISTINCT d.pedido_id) AS pedidos_completados,
        SUM(d.cantidad * d.precio_unitario - d.descuento_total) AS ventas_netas,
        SUM(d.cantidad * d.costo_unitario) AS costo_de_ventas
    FROM public.pedidos AS p
    JOIN public.detalle_pedido AS d ON d.pedido_id = p.pedido_id
    WHERE p.estado = 'completado'
)
SELECT
    ventas_netas,
    costo_de_ventas,
    ventas_netas - costo_de_ventas AS beneficio_bruto,
    pedidos_completados,
    ROUND(100.0 * (ventas_netas - costo_de_ventas)
          / NULLIF(ventas_netas, 0), 2) AS margen_bruto_porcentaje,
    ROUND(ventas_netas / NULLIF(pedidos_completados, 0), 2) AS ticket_promedio
FROM resumen;
