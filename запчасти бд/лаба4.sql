
--Получить список поставщик заданной детали. Для каждого поставщика указать общее количество поставок. Не забыть указать имя детали

SELECT
    suppliers.supplier_id,
    suppliers.name AS supplier_name,
    parts.part_name AS part_name,
    COUNT(purchases.supplier_id) AS total_deliveries
FROM
    suppliers
INNER JOIN purchases ON suppliers.supplier_id = purchases.supplier_id
INNER JOIN parts ON purchases.part_id = parts.part_id
WHERE
    parts.part_name = 'Заданное название детали' --!!!!
GROUP BY
    suppliers.supplier_id, supplier_name, part_name


--Получить список поставщиков, которые поставляют все детали, представленные в БД. Результат отсортировать по суммарному числу заказов каждого поставщика (по убыванию).

SELECT
    suppliers.supplier_id,
    suppliers.name AS supplier_name,
    COUNT(purchases.purchase_id) AS total_orders
FROM
    suppliers
LEFT JOIN purchases ON suppliers.supplier_id = purchases.supplier_id
GROUP BY
    suppliers.supplier_id, supplier_name
HAVING
    COUNT(purchases.purchase_id) = (SELECT COUNT(*) FROM parts)
ORDER BY
    total_orders DESC;


 --Получить список из 10-ти самых приобретаемых деталей. Для каждой такой делали указать список поставщиков в виде массива значений.

SELECT
    parts.part_id,
    parts.part_name,
    ARRAY_AGG(suppliers.name) AS suppliers_list
FROM
    parts
INNER JOIN purchases ON parts.part_id = purchases.part_id
INNER JOIN suppliers ON purchases.supplier_id = suppliers.supplier_id
GROUP BY
    parts.part_id, parts.part_name
ORDER BY
    COUNT(purchases.purchase_id) DESC
LIMIT 10;


 --Получить минимальное и максимальное значение цены, а также количество изменения цены каждого товара на заданный год.
SELECT
    p.part_id,
    p.part_name,
    COALESCE(MIN(ph.price), p.current_price) AS min_price,
    COALESCE(MAX(ph.price), p.current_price) AS max_price,
    (COALESCE(MAX(ph.price), p.current_price) - COALESCE(MIN(ph.price), p.current_price)) AS price_change
FROM
    parts AS p
LEFT JOIN price_history AS ph ON p.part_id = ph.part_id
WHERE
    EXTRACT(YEAR FROM ph.effective_date) = 2023 OR ph.effective_date IS NULL
GROUP BY
    p.part_id, p.part_name;



--Получить кросс-таблицу из итоговой таблицы R(«поставщик», «год», «общая стоимость купленных товаров»). Значения атрибута «год» представить в виде колонок кросс-таблицы.
CREATE EXTENSION IF NOT EXISTS tablefunc;

-- Создание кросс-таблицы
SELECT * FROM crosstab(
   'SELECT p.name AS "Поставщик", EXTRACT(YEAR FROM pu.purchase_date) AS "Год", 
           SUM(pu.quantity * ph.price) AS "Общая стоимость купленных товаров"
    FROM suppliers p
    LEFT JOIN purchases pu ON p.supplier_id = pu.supplier_id
    LEFT JOIN price_history ph ON pu.part_id = ph.part_id
    GROUP BY p.name, EXTRACT(YEAR FROM pu.purchase_date)
    ORDER BY p.name, EXTRACT(YEAR FROM pu.purchase_date)',
   'VALUES (2022), (2023), (2024)'
) AS ct ("Поставщик" text, "2022" numeric, "2023" numeric, "2024" numeric);


