
-- object: fk_tipo_materia | type: CONSTRAINT --
-- ALTER TABLE ejemplo.materia DROP CONSTRAINT IF EXISTS fk_tipo_materia CASCADE;
ALTER TABLE ejemplo.materia ADD CONSTRAINT fk_tipo_materia FOREIGN KEY (tipo)
REFERENCES ejemplo.tipo_materia (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_estudiante | type: CONSTRAINT --
-- ALTER TABLE ejemplo.estudiante_materia DROP CONSTRAINT IF EXISTS fk_estudiante CASCADE;
ALTER TABLE ejemplo.estudiante_materia ADD CONSTRAINT fk_estudiante FOREIGN KEY (estudiante)
REFERENCES ejemplo.estudiante (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_materia | type: CONSTRAINT --
-- ALTER TABLE ejemplo.estudiante_materia DROP CONSTRAINT IF EXISTS fk_materia CASCADE;
ALTER TABLE ejemplo.estudiante_materia ADD CONSTRAINT fk_materia FOREIGN KEY (materia)
REFERENCES ejemplo.materia (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
