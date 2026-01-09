--Регистрация клиента
CREATE OR REPLACE FUNCTION register_client(
    p_full_name TEXT,
    p_phone TEXT,
    p_birthdate DATE
) RETURNS INTEGER AS $$
DECLARE
    v_id INTEGER;
BEGIN
    SELECT client_id INTO v_id
    FROM client
    WHERE phone = p_phone;

    IF v_id IS NULL THEN
        INSERT INTO client(full_name, phone, birthdate)
        VALUES (p_full_name, p_phone, p_birthdate)
        RETURNING client_id INTO v_id;
    ELSE
        UPDATE client
        SET full_name = p_full_name,
            birthdate = p_birthdate
        WHERE client_id = v_id;
    END IF;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;


--Начало сессии
CREATE OR REPLACE FUNCTION start_session(
    p_client_id INTEGER,
    p_gameplace_id INTEGER,
    p_opened_by INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_id INTEGER;
    v_status TEXT;
BEGIN
    SELECT status INTO v_status
    FROM gameplace
    WHERE gameplace_id = p_gameplace_id;

    IF v_status <> 'free' THEN
        RAISE EXCEPTION 'Игровое место занято или недоступно';
    END IF;

    INSERT INTO session(client_id, gameplace_id, actual_start, opened_by)
    VALUES (p_client_id, p_gameplace_id, NOW(), p_opened_by)
    RETURNING session_id INTO v_id;

    UPDATE gameplace
    SET status = 'busy'
    WHERE gameplace_id = p_gameplace_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

--Завершение сессии
CREATE OR REPLACE FUNCTION end_session(
    p_session_id INTEGER,
    p_closed_by INTEGER
) RETURNS VOID AS $$
DECLARE
    v_gameplace_id INTEGER;
    v_start TIMESTAMP;
    v_cost NUMERIC;
	v_type TEXT;
	v_rate NUMERIC;
BEGIN
    SELECT gameplace_id, actual_start
    INTO v_gameplace_id, v_start
    FROM session
    WHERE session_id = p_session_id;

	SELECT type
	INTO v_type
	FROM gameplace
	WHERE gameplace_id = v_gameplace_id;

	IF v_type = 'VIP'
	THEN
		v_rate := 300; -- тариф для VIP
	ELSE
		v_rate := 150; -- тариф для обычного места END IF;

    UPDATE session
    SET actual_end = NOW(),
        closed_by = p_closed_by,
        cost = EXTRACT(EPOCH FROM (NOW() - v_start)) / 3600 * v_rate
    WHERE session_id = p_session_id;

    UPDATE gameplace
    SET status = 'free'
    WHERE gameplace_id = v_gameplace_id;
END;
$$ LANGUAGE plpgsql;


--Создание заявки
CREATE OR REPLACE FUNCTION report_equipment(
    p_equipment_id INTEGER,
    p_technician_id INTEGER,
    p_description TEXT
) RETURNS INTEGER AS $$
DECLARE
    v_id INTEGER;
BEGIN
    INSERT INTO servicelog(equipment_id, technician_id, description, date, status)
    VALUES (p_equipment_id, p_technician_id, p_description, NOW(), 'open')
    RETURNING servicelog_id INTO v_id;

    UPDATE equipment
    SET status = 'broken'
    WHERE equipment_id = p_equipment_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

--Закрытие заявки
CREATE OR REPLACE FUNCTION close_report(
    p_servicelog_id INTEGER,
    p_technician_id INTEGER,
    p_comment TEXT DEFAULT NULL
) RETURNS VOID AS $$
DECLARE
    v_equipment_id INTEGER;
BEGIN
    SELECT equipment_id INTO v_equipment_id
    FROM servicelog
    WHERE servicelog_id = p_servicelog_id
      AND status = 'open';

    IF v_equipment_id IS NULL THEN
        RAISE EXCEPTION 'Заявка % не найдена или уже закрыта', p_servicelog_id;
    END IF;

    UPDATE servicelog
    SET status = 'closed',
        date = NOW(),
        technician_id = p_technician_id,
        description = COALESCE(description || E'\n---\nРемонт: ' || p_comment, description)
    WHERE servicelog_id = p_servicelog_id;

    UPDATE equipment
    SET status = 'ok',
        last_service_date = NOW()
    WHERE equipment_id = v_equipment_id;

END;
$$ LANGUAGE plpgsql;

