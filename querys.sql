use `bfhgoilvzaasm4ntjtvq`;
DROP TABLE productos;
DROP TABLE proveedores;
DROP TABLE categorias;

CREATE TABLE proveedores (
    id_proveedor INT NOT NULL PRIMARY KEY auto_increment,
    nombre VARCHAR(255) NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE categorias (
    id_categoria INT NOT NULL PRIMARY KEY auto_increment,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE productos (
    id_producto INT NOT NULL PRIMARY KEY auto_increment,
    nombre VARCHAR(255) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    cantidad INT NOT NULL,
    id_categoria INT NOT NULL,
    id_proveedor INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

INSERT INTO proveedores (nombre, telefono) values ('Edwin Morataya', '76543210');
INSERT INTO proveedores (nombre, telefono) values ('Iván Calderón', '78696854');
INSERT INTO proveedores (nombre, telefono) values ('Mario Pinto', '76907860');
INSERT INTO proveedores (nombre, telefono) values ('Diego Majano', '76523310');
INSERT INTO proveedores (nombre, telefono) values ('Kenia Paiz', '76512490');

INSERT INTO categorias (nombre) values ('Tecnología'), ('Ropa'), ('Electrónica'), ('Alimento'), ('Hogar');

INSERT INTO productos (nombre, precio, cantidad, id_categoria, id_proveedor) VALUES ('Celular', 280.45, 25, 1, 2), ('Tablet', 320.50, 30, 1, 3);
INSERT INTO productos (nombre, precio, cantidad, id_categoria, id_proveedor) VALUES ('Camisa', 19.99, 50, 2, 1), ('Pantalon', 29.99, 50, 2, 4);
INSERT INTO productos (nombre, precio, cantidad, id_categoria, id_proveedor) VALUES ('Set Arduino', 59.99, 20, 3, 3), ('Set para soldar', 39.99, 15, 3, 3);
INSERT INTO productos (nombre, precio, cantidad, id_categoria, id_proveedor) VALUES ('Café en grano', 9.99, 20, 4, 5), ('Coca-Cola lata', 19.99, 10, 4, 5);
INSERT INTO productos (nombre, precio, cantidad, id_categoria, id_proveedor) VALUES ('Sofá', 219.99, 10, 5, 3), ('Lampara', 39.99, 40, 5, 1);

-- OBTENER PRODUCTOS + PROVEEDOR
select p.id_producto, p.nombre, p.precio, p.cantidad, a.nombre as 'Proveedor', a.telefono from productos p
inner join proveedores a
on p.id_proveedor = a.id_proveedor
order by a.nombre;

-- MOSTRAR PRODUCTOS CON PRECIO MAYORES A 15
SELECT 
    productos.nombre,
    productos.precio,
    productos.cantidad
FROM 
    productos
WHERE 
    productos.precio > 15.00;
    
-- Listar los proveedores que no tienen teléfono registrado. 

insert into proveedores (nombre) values ('Keren Blanco');

SELECT *
FROM proveedores
Where isnull(telefono);

-- Contar cuántos productos hay por proveedor.

select COUNT(p.nombre) as 'Cantidad productos', a.nombre
from productos p
inner join proveedores a
on p.id_proveedor = a.id_proveedor
where p.id_proveedor = a.id_proveedor
group by p.id_proveedor;

-- Calcular el valor total del inventario (cantidad * precio) para cada producto.

select nombre, cantidad, precio, (cantidad * precio) as 'Valor total'
from productos;

-- Obtener el proveedor con más productos registrados.

select count(p.nombre) as total_product, a.nombre
from productos p
inner join proveedores a
on p.id_proveedor = a.id_proveedor
where p.id_proveedor = a.id_proveedor
group by p.id_proveedor
order by total_product DESC
LIMIT 1;

-- Obtener el número total de productos por cada categoría. Usa la cláusula GROUP BY para agrupar los resultados por categoría.

select COUNT(p.nombre) as 'Cantidad productos', c.nombre
from productos p
inner join categorias c
on p.id_categoria = c.id_categoria
where p.id_categoria = c.id_categoria
group by c.id_categoria;

-- Asignar una clasificación a los productos basándote en su precio: "Alto" para productos con un precio mayor a 20.00, y "Bajo" para los demás. Utiliza la cláusula CASE.

select id_producto, nombre, precio, cantidad,
CASE 
	when precio > 20 then 'Alto'
    else 'Bajo'
end as clasificacion
from productos
order by clasificacion;

-- Obtener todos los productos junto con el nombre del proveedor, incluso si algunos proveedores no tienen productos asociados. Usa la cláusula LEFT JOIN.

select p.id_proveedor, p.nombre, a.id_producto, a.nombre, a.precio, a.cantidad
from proveedores p
left join productos a
on p.id_proveedor = a.id_proveedor
order by p.id_proveedor asc;

-- Calcular el precio promedio de los productos en cada categoría. Usa la cláusula GROUP BY para agrupar los productos por categoría.

SELECT 
    categorias.nombre AS categoria,
    AVG(productos.precio) AS precio_promedio
FROM 
    productos
JOIN 
    categorias ON productos.id_categoria = categorias.id_categoria
GROUP BY 
    categorias.nombre;

-- Filtrar las categorías que tienen más de dos productos registrados. Utiliza la cláusula HAVING para aplicar una condición de agregación.

select c.id_categoria, c.nombre, count(p.nombre) as cant_productos
from productos p
inner join categorias c
on p.id_categoria = c.id_categoria
group by c.id_categoria
having cant_productos > 2;

-- Aumentar en un 10% el precio de todos los productos de la categoría "Electrónica" u otra categoría.

update productos set precio = precio * 1.10 where id_categoria = 3;

-- Obtener el producto más caro de cada categoría. Utiliza una subconsulta en la cláusula WHERE para obtener el máximo precio por categoría.
select * from productos;

select c.id_categoria, c.nombre, p.nombre, p.precio
from categorias c
inner join productos p
on c.id_categoria = p.id_categoria
where p.precio = (select max(p1.precio) 
					from productos p1
                    where p1.id_categoria = c.id_categoria)
order by c.nombre;

-- Verificar si hay proveedores que tienen productos cuyo precio es menor a 10.00. Utiliza la cláusula EXISTS con una subconsulta.

select *
from proveedores p
where exists( 
	select 1 
    from productos pr
    where pr.id_proveedor = p.id_proveedor and pr.precio <10.00);

