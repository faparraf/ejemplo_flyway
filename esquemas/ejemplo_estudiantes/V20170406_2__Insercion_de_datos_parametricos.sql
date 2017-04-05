INSERT INTO ejemplo.estudiante(
             nombre, apellido, documento)
    VALUES ( 'Estudiante 1', 'Apellido 1', 1234);
INSERT INTO ejemplo.estudiante(
             nombre, apellido, documento)
    VALUES ( 'Estudiante 2', 'Apellido 2', 1235);
INSERT INTO ejemplo.tipo_materia(
             nombre)
    VALUES ( 'Diurna');
INSERT INTO ejemplo.materia(
             nombre,tipo)
    VALUES ('Materia 1',1);
INSERT INTO ejemplo.materia(
             nombre,tipo)
    VALUES ('Materia 2',1);
INSERT INTO ejemplo.materia(
             nombre,tipo)
    VALUES ('Materia 3',1);
INSERT INTO ejemplo.estudiante_materia(
            estudiante, materia)
    VALUES ( 1, 1);
INSERT INTO ejemplo.estudiante_materia(
            estudiante, materia)
    VALUES ( 2, 1);
INSERT INTO ejemplo.estudiante_materia(
            estudiante, materia)
    VALUES ( 2, 2);
INSERT INTO ejemplo.estudiante_materia(
            estudiante, materia)
    VALUES ( 1, 3);
