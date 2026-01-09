--Добавление клиента
CREATE OR REPLACE FUNCTION add_client(
    p_full_name VARCHAR,
    p_phone VARCHAR,
    p_birthdate DATE
) RETURNS INTEGER AS $$
DECLARE
    v_id INTEGER;
BEGIN
    INSERT INTO client(full_name, phone, birthdate)
    VALUES (p_full_name, p_phone, p_birthdate)
    RETURNING client_id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

--Обновление клиента
CREATE OR REPLACE FUNCTION update_client(
    p_client_id INTEGER,
    p_full_name VARCHAR,
    p_phone VARCHAR,
    p_birthdate DATE
) RETURNS VOID AS $$
BEGIN
    UPDATE client
    SET full_name = p_full_name,
        phone = p_phone,
        birthdate = p_birthdate
    WHERE client_id = p_client_id;
END;
$$ LANGUAGE plpgsql;

--Удаление клиента
CREATE OR REPLACE FUNCTION delete_client(
    p_client_id INTEGER
) RETURNS VOID AS $$
BEGIN
    DELETE FROM client
    WHERE client_id = p_client_id;
END;
$$ LANGUAGE plpgsql;

--Добавление сотрудника
CREATE OR REPLACE FUNCTION add_employee(
    p_full_name VARCHAR,
    p_role VARCHAR,
    p_phone VARCHAR
) RETURNS INTEGER AS $$
DECLARE
    v_id INTEGER;
BEGIN
    INSERT INTO employee(full_name, role, phone)
    VALUES (p_full_name, p_role, p_phone)
    RETURNING employee_id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

--Обновление сотрудника
CREATE OR REPLACE FUNCTION update_employee(
    p_employee_id INTEGER,
    p_full_name VARCHAR,
    p_role VARCHAR,
    p_phone VARCHAR
) RETURNS VOID AS $$
BEGIN
    UPDATE employee
    SET full_name = p_full_name,
        role = p_role,
        phone = p_phone
    WHERE employee_id = p_employee_id;
END;
$$ LANGUAGE plpgsql;

--Удаление сотрудника
CREATE OR REPLACE FUNCTION delete_employee(
    p_employee_id INTEGER
) RETURNS VOID AS $$
BEGIN
    DELETE FROM employee
    WHERE employee_id = p_employee_id;
END;
$$ LANGUAGE plpgsql;

--Добавление места
CREATE OR REPLACE FUNCTION add_gameplace(
    p_name VARCHAR,
    p_type VARCHAR,
    p_status VARCHAR
) RETURNS INTEGER AS $$
DECLARE
    v_id INTEGER;
BEGIN
    INSERT INTO gameplace(name, type, status)
    VALUES (p_name, p_type, p_status)
    RETURNING gameplace_id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

--Обновление места
CREATE OR REPLACE FUNCTION update_gameplace(
    p_gameplace_id INTEGER,
    p_name VARCHAR,
    p_type VARCHAR,
    p_status VARCHAR
) RETURNS VOID AS $$
BEGIN
    UPDATE gameplace
    SET name = p_name,
        type = p_type,
        status = p_status
    WHERE gameplace_id = p_gameplace_id;
END;
$$ LANGUAGE plpgsql;

--Удаление места
CREATE OR REPLACE FUNCTION delete_gameplace(
    p_gameplace_id INTEGER
) RETURNS VOID AS $$
BEGIN
    DELETE FROM gameplace
    WHERE gameplace_id = p_gameplace_id;
END;
$$ LANGUAGE plpgsql;

--Добавление оборудования
CREATE OR REPLACE FUNCTION add_equipment(
    p_gameplace_id INTEGER,
    p_type VARCHAR,
    p_model VARCHAR,
    p_serial_number VARCHAR,
    p_status VARCHAR,
    p_last_service_date DATE
) RETURNS INTEGER AS $$
DECLARE
    v_id INTEGER;
BEGIN
    INSERT INTO equipment(gameplace_id, type, model, serial_number, status, last_service_date)
    VALUES (p_gameplace_id, p_type, p_model, p_serial_number, p_status, p_last_service_date)
    RETURNING equipment_id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

--Обновление оборудования
CREATE OR REPLACE FUNCTION update_equipment(
    p_equipment_id INTEGER,
    p_gameplace_id INTEGER,
    p_type VARCHAR,
    p_model VARCHAR,
    p_serial_number VARCHAR,
    p_status VARCHAR,
    p_last_service_date DATE
) RETURNS VOID AS $$
BEGIN
    UPDATE equipment
    SET gameplace_id = p_gameplace_id,
        type = p_type,
        model = p_model,
        serial_number = p_serial_number,
        status = p_status,
        last_service_date = p_last_service_date
    WHERE equipment_id = p_equipment_id;
END;
$$ LANGUAGE plpgsql;

--Удаление оборудования
CREATE OR REPLACE FUNCTION delete_equipment(
    p_equipment_id INTEGER
) RETURNS VOID AS $$
BEGIN
    DELETE FROM equipment
    WHERE equipment_id = p_equipment_id;
END;
$$ LANGUAGE plpgsql;


