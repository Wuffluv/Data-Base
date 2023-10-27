 запрос для нахождения поставщика 
 с самой высокой общей стоимостью закупок в базе данных

 -- Создаем временную таблицу для результатов запроса
CREATE TEMP TABLE top_supplier AS
SELECT suppliers.supplier_id, suppliers.name, SUM(purchases.quantity * parts.current_price) AS total_purchases
FROM suppliers
INNER JOIN purchases ON suppliers.supplier_id = purchases.supplier_id
INNER JOIN parts ON purchases.part_id = parts.part_id
GROUP BY suppliers.supplier_id, suppliers.name
ORDER BY total_purchases DESC
LIMIT 1;

-- Выводим содержимое временной таблицы
SELECT * FROM top_supplier;


Таблица с количеством деталей, купленных каждым поставщиком:
-- Создаем временную таблицу для результатов запроса
CREATE TEMP TABLE parts_purchased_by_supplier AS
SELECT suppliers.supplier_id, suppliers.name, parts.part_name, SUM(purchases.quantity) AS total_quantity_purchased
FROM suppliers
INNER JOIN purchases ON suppliers.supplier_id = purchases.supplier_id
INNER JOIN parts ON purchases.part_id = parts.part_id
GROUP BY suppliers.supplier_id, suppliers.name, parts.part_name;

-- Выводим содержимое временной таблицы
SELECT * FROM parts_purchased_by_supplier;



Таблица с количеством деталей, проданных по каждой цене:
-- Создаем временную таблицу для результатов запроса
CREATE TEMP TABLE parts_sold_by_price AS
SELECT parts.part_id, parts.part_name, parts.current_price, SUM(purchases.quantity) AS total_quantity_sold
FROM parts
INNER JOIN purchases ON parts.part_id = purchases.part_id
GROUP BY parts.part_id, parts.part_name, parts.current_price;

-- Выводим содержимое временной таблицы
SELECT * FROM parts_sold_by_price;
