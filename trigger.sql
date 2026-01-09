--Блокировка места
CREATE OR REPLACE FUNCTION trg_equipment_update()
RETURNS TRIGGER AS $$
DECLARE
    v_gameplace_id INTEGER;
    v_broken_count INTEGER;
    v_busy_count INTEGER;
BEGIN
    v_gameplace_id := NEW.gameplace_id;

    -- Считаем, есть ли сломанное оборудование
    SELECT COUNT(*) INTO v_broken_count
    FROM equipment
    WHERE gameplace_id = v_gameplace_id
      AND status IN ('broken');

    -- Считаем активные сессии
    SELECT COUNT(*) INTO v_busy_count
    FROM session
    WHERE gameplace_id = v_gameplace_id
      AND actual_end IS NULL;

    -- Если есть сломанное оборудование → место в сервисе
    IF v_broken_count > 0 THEN
        UPDATE gameplace
        SET status = 'service'
        WHERE gameplace_id = v_gameplace_id;

    -- Если нет сломанного оборудования и нет активных сессий → место свободно
    ELSIF v_busy_count = 0 THEN
        UPDATE gameplace
        SET status = 'free'
        WHERE gameplace_id = v_gameplace_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER equipment_update_trigger
AFTER UPDATE ON equipment
FOR EACH ROW
EXECUTE FUNCTION trg_equipment_update();
