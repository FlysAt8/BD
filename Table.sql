-- 1. Таблица клиентов
CREATE TABLE client (
    client_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    birthdate DATE CHECK (birthdate <= CURRENT_DATE - INTERVAL '14 years')
);

-- 2. Таблица сотрудников
CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'operator', 'technician')),
    phone VARCHAR(20) UNIQUE NOT NULL
);

-- 3. Таблица игровых мест
CREATE TABLE gameplace (
    gameplace_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    type VARCHAR(10) NOT NULL CHECK (type IN ('general', 'VIP')),
    status VARCHAR(10) NOT NULL CHECK (status IN ('free', 'busy', 'service'))
);

-- 4. Таблица оборудования
CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    gameplace_id INTEGER NOT NULL 
        REFERENCES gameplace(gameplace_id) ON DELETE RESTRICT,
    type VARCHAR(30) NOT NULL,
    model VARCHAR(50) NOT NULL,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('ok', 'broken',)),
    last_service_date DATE
);

-- 5. Таблица игровых сессий
CREATE TABLE session (
    session_id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES client(client_id) ON DELETE RESTRICT,
    gameplace_id INTEGER NOT NULL REFERENCES gameplace(gameplace_id) ON DELETE RESTRICT,
    actual_start TIMESTAMP NOT NULL,
    actual_end TIMESTAMP CHECK (actual_end > actual_start),
    cost NUMERIC(8,2) CHECK (cost >= 0),
    opened_by INTEGER NOT NULL REFERENCES employee(employee_id),
    closed_by INTEGER REFERENCES employee(employee_id)
);

-- 6. Таблица журнала обслуживания оборудования
CREATE TABLE servicelog (
    servicelog_id SERIAL PRIMARY KEY,
    equipment_id INTEGER NOT NULL REFERENCES equipment(equipment_id) ON DELETE RESTRICT,
    technician_id INTEGER NOT NULL REFERENCES employee(employee_id),
    description TEXT,
    date DATE NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('open', 'closed'))
);
