
CREATE SCHEMA ejemplo;
-- ddl-end --

-- ddl-end --

SET search_path TO pg_catalog,public,ejemplo;
-- ddl-end --

-- object: ejemplo.estudiante | type: TABLE --
-- DROP TABLE IF EXISTS ejemplo.estudiante CASCADE;
CREATE TABLE ejemplo.estudiante(
	id serial NOT NULL,
	nombre character varying NOT NULL,
	apellido character varying NOT NULL,
	documento integer NOT NULL,
	CONSTRAINT pk_estudiante PRIMARY KEY (id),
	CONSTRAINT uk_documento UNIQUE (documento)

);


-- object: ejemplo.materia | type: TABLE --
-- DROP TABLE IF EXISTS ejemplo.materia CASCADE;
CREATE TABLE ejemplo.materia(
	id serial NOT NULL,
	nombre character varying NOT NULL,
	tipo integer NOT NULL,
	CONSTRAINT pk_materia PRIMARY KEY (id)

);

-- object: ejemplo.estudiante_materia | type: TABLE --
-- DROP TABLE IF EXISTS ejemplo.estudiante_materia CASCADE;
CREATE TABLE ejemplo.estudiante_materia(
	id serial NOT NULL,
	estudiante integer NOT NULL,
	materia integer NOT NULL,
	CONSTRAINT pk_estudiante_materia PRIMARY KEY (id)

);

-- object: ejemplo.tipo_materia | type: TABLE --
-- DROP TABLE IF EXISTS ejemplo.tipo_materia CASCADE;
CREATE TABLE ejemplo.tipo_materia(
	id serial NOT NULL,
	nombre character varying NOT NULL,
	CONSTRAINT pk_tipo_materia PRIMARY KEY (id)

);
