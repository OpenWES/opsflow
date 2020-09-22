--+up BEGIN
CREATE TABLE IF NOT EXISTS CONTAINERS
(
  STATE VARCHAR(100) NO NULL,
  PRIMARY KEY (ID)
) INHERITS (BASE_TABLE);

CREATE TABLE IF NOT EXISTS CONTAINER_SESSIONS
(
	STATE VARCHAR(100) NO NULL,
  PRIMARY KEY (ID)
) INHERITS (BASE_TABLE);

CREATE TRIGGER C_CREATED BEFORE INSERT ON CONTAINERS FOR EACH ROW EXECUTE PROCEDURE INIT_TIME_ON_CREATED();
CREATE TRIGGER C_UPDATED BEFORE UPDATE ON CONTAINERS FOR EACH ROW EXECUTE PROCEDURE UPDATE_TIME_ON_UPDATED();

CREATE TRIGGER CS_CREATED BEFORE INSERT ON CONTAINER_SESSIONS FOR EACH ROW EXECUTE PROCEDURE INIT_TIME_ON_CREATED();
CREATE TRIGGER CS_UPDATED BEFORE UPDATE ON CONTAINER_SESSIONS FOR EACH ROW EXECUTE PROCEDURE UPDATE_TIME_ON_UPDATED();
--+up END

--+down BEGIN
DROP TRIGGER IF EXISTS CS_CREATED ON CONTAINER_SESSIONS;
DROP TRIGGER IF EXISTS CS_UPDATED ON CONTAINER_SESSIONS;

DROP TRIGGER IF EXISTS C_CREATED ON CONTAINERS;
DROP TRIGGER IF EXISTS C_UPDATED ON CONTAINERS;

DROP TABLE IF EXISTS CONTAINER_SESSIONS;
DROP TABLE IF EXISTS CONTAINERS;
--+down END
