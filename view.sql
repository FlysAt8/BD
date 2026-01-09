--Активные игровые сессии
CREATE OR REPLACE VIEW active_sessions AS
SELECT 
    s.session_id,
    c.full_name AS client_name,
    g.name AS gameplace_name,
    s.actual_start,
    s.opened_by
FROM session s
JOIN client c ON s.client_id = c.client_id
JOIN gameplace g ON s.gameplace_id = g.gameplace_id
WHERE s.actual_end IS NULL;

--История сессий с полной информацией
CREATE OR REPLACE VIEW session_history AS
SELECT 
    s.session_id,
    c.full_name AS client_name,
    g.name AS gameplace_name,
    s.actual_start,
    s.actual_end,
    s.cost,
    e1.full_name AS opened_by,
    e2.full_name AS closed_by
FROM session s
JOIN client c ON s.client_id = c.client_id
JOIN gameplace g ON s.gameplace_id = g.gameplace_id
LEFT JOIN employee e1 ON s.opened_by = e1.employee_id
LEFT JOIN employee e2 ON s.closed_by = e2.employee_id;

--Статус всех игровых мест
CREATE OR REPLACE VIEW gameplace_status AS
SELECT 
    g.gameplace_id,
    g.name,
    g.type,
    g.status,
    COUNT(e.equipment_id) AS equipment_count
FROM gameplace g
LEFT JOIN equipment e ON g.gameplace_id = e.gameplace_id
GROUP BY g.gameplace_id, g.name, g.type, g.status;

--Оборудование и его состояние
CREATE OR REPLACE VIEW equipment_overview AS
SELECT 
    e.equipment_id,
    e.type,
    e.model,
    e.serial_number,
    e.status,
    e.last_service_date,
    g.name AS gameplace_name
FROM equipment e
LEFT JOIN gameplace g ON e.gameplace_id = g.gameplace_id;

--Открытые заявки на ремонт
CREATE OR REPLACE VIEW open_servicelog AS
SELECT 
    sl.servicelog_id,
    e.type AS equipment_type,
    e.model AS equipment_model,
    sl.description,
    sl.date,
    emp.full_name AS technician
FROM servicelog sl
JOIN equipment e ON sl.equipment_id = e.equipment_id
LEFT JOIN employee emp ON sl.technician_id = emp.employee_id
WHERE sl.status = 'open';

--История ремонтов
CREATE OR REPLACE VIEW repair_history AS
SELECT 
    sl.servicelog_id,
    e.type AS equipment_type,
    e.model AS equipment_model,
    sl.description,
    sl.date AS repair_date,
    emp.full_name AS technician
FROM servicelog sl
JOIN equipment e ON sl.equipment_id = e.equipment_id
LEFT JOIN employee emp ON sl.technician_id = emp.employee_id
WHERE sl.status = 'closed';

--Клиенты и их количество посещений
CREATE OR REPLACE VIEW client_visit_stats AS
SELECT 
    c.client_id,
    c.full_name,
    c.phone,
    COUNT(s.session_id) AS total_sessions,
    MIN(s.actual_start) AS first_visit,
    MAX(s.actual_start) AS last_visit
FROM client c
LEFT JOIN session s ON c.client_id = s.client_id
GROUP BY c.client_id, c.full_name, c.phone;
