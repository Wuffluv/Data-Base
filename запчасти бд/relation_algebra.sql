--Извлечение данных из произвольной таблицы:
SELECT * FROM suppliers;

--Проекция данных на произвольной таблице с вычисляемым столбцом (например, суммирование цен покупок):
SELECT s.supplier_id, s.name, SUM(pa.current_price * pu.quantity) as total_purchase_price
FROM suppliers s
INNER JOIN purchases pu ON s.supplier_id = pu.supplier_id
INNER JOIN parts pa ON pu.part_id = pa.part_id
GROUP BY s.supplier_id, s.name;

--Фильтрация данных с использованием различных выражений:
--Использование LIKE для поиска по части названия детали:

SELECT * FROM parts WHERE part_name LIKE 'Деталь%';

--Использование IN для фильтрации по нескольким значениям артикула:

SELECT * FROM parts WHERE part_number IN ('Артикул 1', 'Артикул 2');

--Использование BETWEEN для фильтрации по диапазону цен:

SELECT * FROM parts WHERE current_price BETWEEN 100.00 AND 150.00;


--Внутреннее INNER JOIN соединение (получение данных из двух таблиц, где есть совпадение):

SELECT suppliers.name, purchases.purchase_date
FROM suppliers
INNER JOIN purchases ON suppliers.supplier_id = purchases.supplier_id;

--Внешнее LEFT JOIN (или LEFT OUTER JOIN) соединение (вывод данных из левой таблицы и совпадающие данные из правой):

SELECT suppliers.name, purchases.purchase_date
FROM suppliers
LEFT JOIN purchases ON suppliers.supplier_id = purchases.supplier_id;

--Внешнее RIGHT JOIN (или RIGHT OUTER JOIN) соединение (вывод данных из правой таблицы и совпадающие данные из левой):

SELECT suppliers.name, purchases.purchase_date
FROM suppliers
RIGHT JOIN purchases ON suppliers.supplier_id = purchases.supplier_id;

--Объединение данных (UNION) из двух таблиц:

SELECT supplier_id, 'Supplier' AS source FROM suppliers
UNION
SELECT part_id, 'Part' AS source FROM parts;

--Пересечение данных (INTERSECT) из двух таблиц:

SELECT supplier_id FROM suppliers
INTERSECT
SELECT supplier_id FROM purchases;


