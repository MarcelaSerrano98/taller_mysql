### Consultas básicas

1. Consulta todos los datos de la tabla `usuarios` para ver la lista completa de clientes.

    SELECT * FROM usuarios;

2. Muestra los nombres y correos electrónicos de todos los clientes que residen en la ciudad de Madrid.

    SELECT nombre, email from usuarios WHERE ciudad = 'Madrid';

3. Obtén una lista de productos con un precio mayor a $100.000, mostrando solo el nombre y el precio.

    SELECT * FROM productos;
    SELECT nombre,precio from productos WHERE precio>100000;

4. Encuentra todos los empleados que tienen un salario superior a $2.500.000, mostrando su nombre, puesto y salario.

    SELECT * FROM empleados;
    SELECT  nombre, puesto, salario from empleados 
    INNER JOIN usuarios
    WHERE salario>2500000 and tipo_id = 2;


5. Lista los nombres de los productos en la categoría "Electrónica", ordenados alfabéticamente haciendo uso del operador `LIKE`.

    SELECT nombre
    FROM productos
    WHERE categoria LIKE 'Electrónica'
    ORDER BY nombre ASC;

6. Muestra los detalles de los pedidos que están en estado "Pendiente", incluyendo el ID del pedido, el ID del cliente y la fecha del pedido.

    SELECT pedido_id, cliente_id, fecha_pedido
    FROM pedidos
    WHERE estado = 'Pendiente'
    ORDER BY fecha_pedido;

7. Encuentra el nombre y el precio del producto más caro en la base de datos.

    SELECT nombre, precio
    FROM productos
    WHERE precio = (SELECT MAX(precio) FROM productos);

8. Obtén el total de pedidos realizados por cada cliente, mostrando el ID del cliente y el total de pedidos.

        SELECT cliente_id, COUNT(*) AS total_pedidos
        FROM pedidos
        GROUP BY cliente_id
        ORDER BY total_pedidos DESC;

9. Calcula el promedio de salario de todos los empleados en la empresa.

    SELECT ROUND(AVG(salario), 2) AS promedio_salario
    FROM empleados;

10. Encuentra el número de productos en cada categoría, mostrando la categoría y el número de productos.

SELECT categoria, COUNT(*) AS num_productos
FROM productos
GROUP BY categoria
ORDER BY num_productos DESC;

11. Obtén una lista de productos con un precio mayor a $75 USD, mostrando solo el nombre, el precio y su respectivo precio en USD.
SELECT nombre,
       precio,
       ROUND(precio / 3853.19, 2) AS precio_usd
FROM productos
WHERE precio > 288989.25
ORDER BY precio DESC;

12. Lista todos los proveedores registrados.

SELECT proveedor_id, nombre, email, telefono, ciudad, pais, fecha_registro
FROM proveedores
ORDER BY nombre;


### Consultas multitabla joins

1. Encuentra los nombres de los clientes y los detalles de sus pedidos.

SELECT 
  c.usuario_id AS cliente_id,
  c.nombre AS cliente,
  p.pedido_id,
  p.fecha_pedido,
  p.estado,
  dp.detalle_id,
  prod.producto_id,
  prod.nombre AS producto,
  dp.cantidad,
  dp.precio_unitario
FROM usuarios c
JOIN pedidos p ON c.usuario_id = p.cliente_id
JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
JOIN productos prod ON dp.producto_id = prod.producto_id
WHERE c.tipo_id = 1;  -- asegurar que son clientes

2. Lista todos los productos pedidos junto con el precio unitario de cada pedido
SELECT
  dp.pedido_id,
  dp.detalle_id,
  dp.producto_id,
  pr.nombre AS producto,
  dp.cantidad,
  dp.precio_unitario
FROM detalles_pedidos dp
JOIN productos pr ON dp.producto_id = pr.producto_id
ORDER BY dp.pedido_id;



3. Encuentra los nombres de los clientes y los nombres de los empleados que gestionaron sus pedidos
SELECT
  uc.nombre AS cliente,
  p.pedido_id,
  ue.nombre AS empleado,
  e.puesto
FROM pedidos p
JOIN usuarios uc ON p.cliente_id = uc.usuario_id
JOIN empleados e ON p.empleado_id = e.empleado_id
JOIN usuarios ue ON e.usuario_id = ue.usuario_id;


4. Muestra todos los pedidos y, si existen, los productos en cada pedido, incluyendo los pedidos sin productos usando `LEFT JOIN`
SELECT
  p.pedido_id,
  p.fecha_pedido,
  p.estado,
  c.nombre AS cliente,
  dp.detalle_id,
  dp.producto_id,
  prod.nombre AS producto,
  dp.cantidad,
  dp.precio_unitario
FROM pedidos p
JOIN usuarios c ON p.cliente_id = c.usuario_id
LEFT JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
LEFT JOIN productos prod ON dp.producto_id = prod.producto_id
ORDER BY p.pedido_id;


5. Encuentra los productos y, si existen, los detalles de pedidos en los que no se ha incluido el producto usando `RIGHT JOIN`.

SELECT
  prod.producto_id,
  prod.nombre AS producto,
  dp.pedido_id,
  dp.cantidad,
  dp.precio_unitario
FROM detalles_pedidos dp
RIGHT JOIN productos prod ON dp.producto_id = prod.producto_id
ORDER BY prod.producto_id;


SELECT
  prod.producto_id,
  prod.nombre AS producto
FROM detalles_pedidos dp
RIGHT JOIN productos prod ON dp.producto_id = prod.producto_id
WHERE dp.pedido_id IS NULL;

6. Lista todos los empleados junto con los pedidos que han gestionado, si existen, usando `LEFT JOIN` para ver los empleados sin pedidos.
SELECT
  e.empleado_id,
  ue.nombre AS empleado,
  e.puesto,
  p.pedido_id,
  p.fecha_pedido,
  p.estado
FROM empleados e
JOIN usuarios ue ON e.usuario_id = ue.usuario_id
LEFT JOIN pedidos p ON e.empleado_id = p.empleado_id
ORDER BY e.empleado_id;

7. Encuentra los empleados que no han gestionado ningún pedido usando un `LEFT JOIN` combinado con `WHERE`.
SELECT
  e.empleado_id,
  ue.nombre AS empleado,
  e.puesto
FROM empleados e
JOIN usuarios ue ON e.usuario_id = ue.usuario_id
LEFT JOIN pedidos p ON e.empleado_id = p.empleado_id
WHERE p.pedido_id IS NULL;

8. Calcula el total gastado en cada pedido, mostrando el ID del pedido y el total, usando `JOIN`.
SELECT
  dp.pedido_id,
  SUM(dp.cantidad * dp.precio_unitario) AS total_pedido
FROM detalles_pedidos dp
GROUP BY dp.pedido_id
ORDER BY dp.pedido_id;


9. Realiza un `CROSS JOIN` entre clientes y productos para mostrar todas las combinaciones posibles de clientes y productos.

SELECT
  c.usuario_id AS cliente_id,
  c.nombre AS cliente,
  prod.producto_id,
  prod.nombre AS producto
FROM usuarios c
CROSS JOIN productos prod
WHERE c.tipo_id = 1
ORDER BY c.usuario_id, prod.producto_id;


10. Encuentra los nombres de los clientes y los productos que han comprado, si existen, incluyendo los clientes que no han realizado pedidos usando `LEFT JOIN`.
SELECT
  c.usuario_id AS cliente_id,
  c.nombre AS cliente,
  p.pedido_id,
  prod.producto_id,
  prod.nombre AS producto,
  dp.cantidad,
  dp.precio_unitario
FROM usuarios c
LEFT JOIN pedidos p ON c.usuario_id = p.cliente_id
LEFT JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
LEFT JOIN productos prod ON dp.producto_id = prod.producto_id
WHERE c.tipo_id = 1
ORDER BY c.usuario_id;


11. Listar todos los proveedores que suministran un determinado producto.

SELECT
  prov.proveedor_id,
  prov.nombre AS proveedor,
  prov.email,
  prov.telefono
FROM proveedores prov
JOIN proveedores_productos pp ON prov.proveedor_id = pp.proveedor_id
WHERE pp.producto_id = 1; 

SELECT
  prov.proveedor_id,
  prov.nombre AS proveedor,
  prov.email,
  prov.telefono
FROM proveedores prov
JOIN proveedores_productos pp ON prov.proveedor_id = pp.proveedor_id
JOIN productos pr ON pp.producto_id = pr.producto_id
WHERE pr.nombre = 'Laptop';  -- <- reemplaza 'Laptop' por el nombre buscado
