--
-- PostgreSQL database dump
--

\restrict m3Ph4HXMWvjToafwwbAZWOKzDGTYrFBRrxM9DSPGyEnTSCSQCkc1KZeD87JbuBn

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-10-18 20:52:59

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 17143)
-- Name: categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorias (
    categoria_id integer NOT NULL,
    nombre character varying(80) NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 17142)
-- Name: categorias_categoria_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.categorias ALTER COLUMN categoria_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categorias_categoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 17153)
-- Name: clientes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clientes (
    cliente_id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    ciudad character varying(80) CONSTRAINT clientes_cuidad_not_null NOT NULL,
    fecha_registro date NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 17152)
-- Name: clientes_cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.clientes ALTER COLUMN cliente_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.clientes_cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 17198)
-- Name: detalle_pedido; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_pedido (
    pedido_id integer NOT NULL,
    producto_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    costo_unitario numeric(12,2) NOT NULL,
    descuento_total numeric(12,2) DEFAULT 0 NOT NULL,
    CONSTRAINT detalle_pedido_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT detalle_pedido_check CHECK (((descuento_total >= (0)::numeric) AND (descuento_total <= ((cantidad)::numeric * precio_unitario)))),
    CONSTRAINT detalle_pedido_costo_unitario_check CHECK ((costo_unitario >= (0)::numeric)),
    CONSTRAINT detalle_pedido_precio_unitario_check CHECK ((precio_unitario >= (0)::numeric))
);


--
-- TOC entry 226 (class 1259 OID 17181)
-- Name: pedidos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pedidos (
    pedido_id integer NOT NULL,
    cliente_id integer NOT NULL,
    fecha date NOT NULL,
    estado character varying(20) NOT NULL,
    canal character varying(20) NOT NULL,
    CONSTRAINT pedidos_canal_check CHECK (((canal)::text = ANY ((ARRAY['tienda'::character varying, 'web'::character varying])::text[]))),
    CONSTRAINT pedidos_estado_check CHECK (((estado)::text = ANY ((ARRAY['completado'::character varying, 'cancelado'::character varying, 'pendiente'::character varying])::text[])))
);


--
-- TOC entry 225 (class 1259 OID 17180)
-- Name: pedidos_pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.pedidos ALTER COLUMN pedido_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pedidos_pedido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 17163)
-- Name: productos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.productos (
    producto_id integer NOT NULL,
    categoria_id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    precio_actual numeric(12,2) NOT NULL,
    costo_actual numeric(12,2) NOT NULL,
    CONSTRAINT productos_costo_actual_check CHECK ((costo_actual >= (0)::numeric)),
    CONSTRAINT productos_precio_actual_check CHECK ((precio_actual >= (0)::numeric))
);


--
-- TOC entry 223 (class 1259 OID 17162)
-- Name: productos_producto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.productos ALTER COLUMN producto_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.productos_producto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4947 (class 0 OID 17143)
-- Dependencies: 220
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categorias (categoria_id, nombre) OVERRIDING SYSTEM VALUE VALUES (4, 'Tecnología');
INSERT INTO public.categorias (categoria_id, nombre) OVERRIDING SYSTEM VALUE VALUES (5, 'Accesorios');
INSERT INTO public.categorias (categoria_id, nombre) OVERRIDING SYSTEM VALUE VALUES (6, 'Oficina');


--
-- TOC entry 4949 (class 0 OID 17153)
-- Dependencies: 222
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.clientes (cliente_id, nombre, ciudad, fecha_registro) OVERRIDING SYSTEM VALUE VALUES (1, 'Cliente Demo 01', 'Lima', '2025-12-01');
INSERT INTO public.clientes (cliente_id, nombre, ciudad, fecha_registro) OVERRIDING SYSTEM VALUE VALUES (2, 'Cliente Demo 02', 'Arequipa', '2025-12-05');
INSERT INTO public.clientes (cliente_id, nombre, ciudad, fecha_registro) OVERRIDING SYSTEM VALUE VALUES (3, 'Cliente Demo 03', 'Trujillo', '2025-12-10');
INSERT INTO public.clientes (cliente_id, nombre, ciudad, fecha_registro) OVERRIDING SYSTEM VALUE VALUES (4, 'Cliente Demo 04', 'Lima', '2025-12-15');
INSERT INTO public.clientes (cliente_id, nombre, ciudad, fecha_registro) OVERRIDING SYSTEM VALUE VALUES (5, 'Cliente Demo 05', 'Cusco', '2025-12-20');
INSERT INTO public.clientes (cliente_id, nombre, ciudad, fecha_registro) OVERRIDING SYSTEM VALUE VALUES (6, 'Cliente Demo 06', 'Arequipa', '2025-12-22');


--
-- TOC entry 4954 (class 0 OID 17198)
-- Dependencies: 227
-- Data for Name: detalle_pedido; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (1, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (1, 10, 2, 65.00, 35.00, 10.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (2, 7, 3, 280.00, 190.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (2, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (3, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (3, 9, 2, 180.00, 110.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (4, 9, 2, 180.00, 110.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (4, 10, 3, 65.00, 35.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (5, 10, 3, 65.00, 35.00, 9.75);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (5, 11, 1, 95.00, 50.00, 4.75);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (6, 11, 1, 95.00, 50.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (6, 12, 2, 550.00, 360.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (7, 12, 2, 550.00, 360.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (7, 7, 3, 280.00, 190.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (8, 7, 3, 280.00, 190.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (8, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (9, 8, 1, 650.00, 450.00, 32.50);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (9, 9, 2, 180.00, 110.00, 18.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (10, 9, 2, 180.00, 110.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (10, 10, 3, 65.00, 35.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (11, 10, 3, 65.00, 35.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (11, 11, 1, 95.00, 50.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (12, 11, 1, 95.00, 50.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (12, 12, 2, 550.00, 360.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (13, 12, 2, 550.00, 360.00, 55.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (13, 7, 3, 280.00, 190.00, 42.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (14, 7, 3, 280.00, 190.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (14, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (15, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (15, 9, 2, 180.00, 110.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (16, 9, 2, 180.00, 110.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (16, 10, 3, 65.00, 35.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (17, 10, 3, 65.00, 35.00, 9.75);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (17, 11, 1, 95.00, 50.00, 4.75);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (18, 11, 1, 95.00, 50.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (18, 12, 2, 550.00, 360.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (19, 12, 2, 550.00, 360.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (19, 7, 3, 280.00, 190.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (20, 7, 3, 280.00, 190.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (20, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (21, 8, 1, 650.00, 450.00, 32.50);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (21, 9, 2, 180.00, 110.00, 18.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (22, 9, 2, 180.00, 110.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (22, 10, 3, 65.00, 35.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (23, 10, 3, 65.00, 35.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (23, 11, 1, 95.00, 50.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (24, 11, 1, 95.00, 50.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (24, 12, 2, 550.00, 360.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (25, 12, 2, 550.00, 360.00, 55.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (25, 7, 3, 280.00, 190.00, 42.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (26, 7, 3, 280.00, 190.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (26, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (27, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (27, 9, 2, 180.00, 110.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (28, 9, 2, 180.00, 110.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (28, 10, 3, 65.00, 35.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (29, 10, 3, 65.00, 35.00, 9.75);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (29, 11, 1, 95.00, 50.00, 4.75);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (30, 11, 1, 95.00, 50.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (30, 12, 2, 550.00, 360.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (31, 12, 2, 550.00, 360.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (31, 7, 3, 280.00, 190.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (32, 7, 3, 280.00, 190.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (32, 8, 1, 650.00, 450.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (33, 8, 1, 650.00, 450.00, 32.50);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (33, 9, 2, 180.00, 110.00, 18.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (34, 9, 2, 180.00, 110.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (34, 10, 3, 65.00, 35.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (35, 10, 3, 65.00, 35.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (35, 11, 1, 95.00, 50.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (36, 11, 1, 95.00, 50.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (36, 12, 2, 550.00, 360.00, 0.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (37, 12, 2, 550.00, 360.00, 55.00);
INSERT INTO public.detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, costo_unitario, descuento_total) VALUES (37, 7, 3, 280.00, 190.00, 42.00);


--
-- TOC entry 4953 (class 0 OID 17181)
-- Dependencies: 226
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (1, 1, '2026-01-15', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (2, 1, '2026-01-05', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (3, 2, '2026-01-09', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (4, 3, '2026-01-13', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (5, 4, '2026-01-17', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (6, 5, '2026-01-21', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (7, 6, '2026-01-25', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (8, 1, '2026-02-05', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (9, 2, '2026-02-09', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (10, 3, '2026-02-13', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (11, 4, '2026-02-17', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (12, 5, '2026-02-21', 'cancelado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (13, 6, '2026-02-25', 'pendiente', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (14, 1, '2026-03-05', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (15, 2, '2026-03-09', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (16, 3, '2026-03-13', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (17, 4, '2026-03-17', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (18, 5, '2026-03-21', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (19, 6, '2026-03-25', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (20, 1, '2026-04-05', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (21, 2, '2026-04-09', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (22, 3, '2026-04-13', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (23, 4, '2026-04-17', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (24, 5, '2026-04-21', 'cancelado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (25, 6, '2026-04-25', 'pendiente', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (26, 1, '2026-05-05', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (27, 2, '2026-05-09', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (28, 3, '2026-05-13', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (29, 4, '2026-05-17', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (30, 5, '2026-05-21', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (31, 6, '2026-05-25', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (32, 1, '2026-06-05', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (33, 2, '2026-06-09', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (34, 3, '2026-06-13', 'completado', 'web');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (35, 4, '2026-06-17', 'completado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (36, 5, '2026-06-21', 'cancelado', 'tienda');
INSERT INTO public.pedidos (pedido_id, cliente_id, fecha, estado, canal) OVERRIDING SYSTEM VALUE VALUES (37, 6, '2026-06-25', 'pendiente', 'web');


--
-- TOC entry 4951 (class 0 OID 17163)
-- Dependencies: 224
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.productos (producto_id, categoria_id, nombre, precio_actual, costo_actual) OVERRIDING SYSTEM VALUE VALUES (7, 4, 'Disco SSD 1 TB', 280.00, 190.00);
INSERT INTO public.productos (producto_id, categoria_id, nombre, precio_actual, costo_actual) OVERRIDING SYSTEM VALUE VALUES (8, 4, 'Monitor 24 pulgadas', 650.00, 450.00);
INSERT INTO public.productos (producto_id, categoria_id, nombre, precio_actual, costo_actual) OVERRIDING SYSTEM VALUE VALUES (9, 5, 'Teclado mecánico', 180.00, 110.00);
INSERT INTO public.productos (producto_id, categoria_id, nombre, precio_actual, costo_actual) OVERRIDING SYSTEM VALUE VALUES (10, 5, 'Mouse inalámbrico', 65.00, 35.00);
INSERT INTO public.productos (producto_id, categoria_id, nombre, precio_actual, costo_actual) OVERRIDING SYSTEM VALUE VALUES (11, 6, 'Soporte para laptop', 95.00, 50.00);
INSERT INTO public.productos (producto_id, categoria_id, nombre, precio_actual, costo_actual) OVERRIDING SYSTEM VALUE VALUES (12, 6, 'Silla ergonómica', 550.00, 360.00);


--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 219
-- Name: categorias_categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categorias_categoria_id_seq', 6, true);


--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 221
-- Name: clientes_cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.clientes_cliente_id_seq', 6, true);


--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 225
-- Name: pedidos_pedido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pedidos_pedido_id_seq', 37, true);


--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 223
-- Name: productos_producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.productos_producto_id_seq', 12, true);


--
-- TOC entry 4784 (class 2606 OID 17151)
-- Name: categorias categorias_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_nombre_key UNIQUE (nombre);


--
-- TOC entry 4786 (class 2606 OID 17149)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (categoria_id);


--
-- TOC entry 4788 (class 2606 OID 17161)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cliente_id);


--
-- TOC entry 4794 (class 2606 OID 17213)
-- Name: detalle_pedido detalle_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_pkey PRIMARY KEY (pedido_id, producto_id);


--
-- TOC entry 4792 (class 2606 OID 17192)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (pedido_id);


--
-- TOC entry 4790 (class 2606 OID 17174)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (producto_id);


--
-- TOC entry 4797 (class 2606 OID 17214)
-- Name: detalle_pedido detalle_pedido_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(pedido_id);


--
-- TOC entry 4798 (class 2606 OID 17219)
-- Name: detalle_pedido detalle_pedido_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(producto_id);


--
-- TOC entry 4796 (class 2606 OID 17193)
-- Name: pedidos pedidos_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(cliente_id);


--
-- TOC entry 4795 (class 2606 OID 17175)
-- Name: productos productos_categoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categorias(categoria_id);


-- Completed on 2026-10-18 20:53:01

--
-- PostgreSQL database dump complete
--

\unrestrict m3Ph4HXMWvjToafwwbAZWOKzDGTYrFBRrxM9DSPGyEnTSCSQCkc1KZeD87JbuBn

