--+up BEGIN
CREATE OR REPLACE FUNCTION INIT_TIME_ON_CREATED() RETURNS TRIGGER 
AS $$
  DECLARE v bigint;
	BEGIN
		NEW.CREATED = NOW();
		NEW.UPDATED = NOW();
    select((SELECT EXTRACT(EPOCH FROM (SELECT NOW())) * 1000)::bigint) INTO v;
    NEW.CREATED_UNIX = v;
    NEW.UPDATED_UNIX = v;
		RETURN NEW; 
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION UPDATE_TIME_ON_UPDATED() RETURNS TRIGGER 
AS $$
	DECLARE v bigint;
	BEGIN
		NEW.UPDATED = NOW();
		select((SELECT EXTRACT(EPOCH FROM (SELECT NOW())) * 1000)::bigint) INTO v;
    NEW.UPDATED_UNIX = v;
		RETURN NEW; 
	END;
$$ LANGUAGE PLPGSQL;

CREATE TABLE IF NOT EXISTS BASE_TABLE
(
  ID BIGINT NOT NULL UNIQUE,
  UPDATED TIMESTAMP WITH TIME ZONE default NOW(),
  CREATED TIMESTAMP WITH TIME ZONE default NOW(),
  CREATED_UNIX bigint default 0, 
  UPDATED_UNIX bigint default 0,
  PRIMARY KEY (ID)
)
WITH (
  OIDS = FALSE
);

CREATE TABLE IF NOT EXISTS BASE_METADATA_TABLE
(
  METADATA JSONB NOT NULL,
  PRIMARY KEY (ID)
) INHERITS (BASE_TABLE);
--+up END

--+down BEGIN
DROP TABLE IF EXISTS BASE_ATTRIBUTE_VALUE_TABLE;
DROP TABLE IF EXISTS BASE_EVENT_TABLE;
DROP TABLE IF EXISTS BASE_TABLE;

DROP FUNCTION IF EXISTS INIT_TIME_ON_CREATED;
DROP FUNCTION IF EXISTS UPDATE_TIME_ON_UPDATED;
--+down END
