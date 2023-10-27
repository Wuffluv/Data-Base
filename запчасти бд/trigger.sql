 -- триггер, который будет автоматически обновлять эту таблицу при изменении цен в таблице "Детали".
CREATE OR REPLACE FUNCTION update_price_history()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO price_history (part_id, price, effective_date)
    VALUES (NEW.part_id, NEW.current_price, now());

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER price_update_trigger
AFTER UPDATE ON parts
FOR EACH ROW
EXECUTE FUNCTION update_price_history();



____________________________________________

-- Обновление цены в таблице "Детали" (сработает триггер)
UPDATE parts
SET current_price = 60.00
WHERE part_id = 1;
