-- TABLAS CON LLAVE PRIMARIA Y FORANEA

CREATE TABLE PERSONA
(   DOCUMENTO NUMBER NOT NULL PRIMARY KEY,
    PRIMER_NOMBRE VARCHAR2(20) NOT NULL,
    SEGUNDO_NOMBRE VARCHAR2(20),
    PRIMER_APELLIDO VARCHAR2(20) NOT NULL, 
    SEGUNDO_APELLIDO VARCHAR2(20),
    TIPO_DE_DOCUMENTO VARCHAR2(20) NOT NULL,
    CELULAR NUMBER,
    DIRECCION VARCHAR2(20),
    CORREO_ELECTRÓNICO VARCHAR2(20),
    ESTADO char(1),
    TIPO VARCHAR2(20)

  );

CREATE TABLE REPUESTO
(
ID_REPUESTO NUMBER PRIMARY KEY,
PRECIO_POR_UNIDAD NUMBER,
NUMERO_DE_UNIDADES NUMBER,
DESCUENTO NUMBER,
SUBTOTAL NUMBER,
REPUESTO VARCHAR2(20)
);


CREATE TABLE FACTURA
(
ID_FACTURA NUMBER PRIMARY KEY,
IVA NUMBER,
SUBTOTAL NUMBER,
TOTALFACTURA NUMBER,
FECHA_CREACION DATE,
PERSONA NUMBER,
CONSTRAINT FK_PERSONA FOREIGN KEY (PERSONA) REFERENCES PERSONA(DOCUMENTO)
);

create table REPUESTO_FACTURA (
    CANTIDAD number not null,
    SUBTOTAL NUMBER,
    FECHA_MODIFICACION DATE,    
    FACTURA_R_FK number not null,
    REPUESTO_FK number not null,
    CONSTRAINT FK_REPUESTO FOREIGN KEY (FACTURA_R_FK) REFERENCES FACTURA(ID_FACTURA),
    CONSTRAINT FK_FACTURA_R FOREIGN KEY (REPUESTO_FK) REFERENCES REPUESTO(ID_REPUESTO)
);

insert into  REPUESTO_FACTURA (cantidad, FACTURA_R_FK,REPUESTO_FK) values(10,1,1)

alter table REPUESTO_FACTURA add constraint repuesto_factura_pk primary key (FACTURA_R_FK, REPUESTO_FK);


CREATE TABLE SERVICIO
(
ID_SERVICIO NUMBER PRIMARY KEY,
PRECIO_DE_LA_MANO_DE_OBRA NUMBER,
DESCUENTO NUMBER,
ESTADO CHAR(1),
SERVICIO VARCHAR2(20), 
VALOR_MIN NUMBER, 
VALOR_MAX NUMBER,
FK_PERSONA_S number not null,
CONSTRAINT FK_PERSONA FOREIGN KEY (FK_PERSONA_S) REFERENCES PERSONA(DOCUMENTO)
    
);

create table SERVICIO_FACTURA (
    CANTIDAD number not null,
    SUBTOTAL NUMBER,
    FECHA_MODIFICACION DATE,    
    FACTURA_S_FK number not null,
    SERVICIO_FK number not null,
    ESTADO CHAR(1),
    CONSTRAINT FK_SERVICIO FOREIGN KEY (SERVICIO_FK) REFERENCES SERVICIO(ID_SERVICIO),
    CONSTRAINT FK_FACTURA_S FOREIGN KEY (FACTURA_S_FK) REFERENCES FACTURA(ID_FACTURA)
);

--INSERT
insert into persona (documento, PRIMER_NOMBRE, PRIMER_APELLIDO, TIPO_DE_DOCUMENTO,celular, DIRECCION, CORREO_ELECTRÓNICO, estado, tipo)
values (1117546315,'camila','castro','CC',3216402656,'calle 81 #74-25','camila@gmail.com','A','cliente');

insert into persona (documento, PRIMER_NOMBRE, PRIMER_APELLIDO, TIPO_DE_DOCUMENTO,celular, DIRECCION, CORREO_ELECTRÓNICO, estado, tipo)
values (1117546318,'camilo','ortiz','CC',3216402655,'calle 81 #74-21','camilo@gmail.com','A','empleado');

insert into repuesto values(1,5000,500,10,0,'REPUESTO 1');
insert into repuesto values(2,5000,500,10,0,'REPUESTO 2');
insert into repuesto values(3,2000,300,10,0,'REPUESTO 3');

INSERT INTO SERVICIO_FACTURA (CANTIDAD,FACTURA_S_FK,SERVICIO_FK) VALUES (30,1,1);

insert into FACTURA (ID_FACTURA, TOTALFACTURA,FECHA_CREACION,PERSONA) values ( 1,0, SYSDATE,1117546315);

insert into  REPUESTO_FACTURA (cantidad, FACTURA_R_FK,REPUESTO_FK) values(10,1,1);
INSERT INTO SERVICIO_FACTURA (CANTIDAD,FACTURA_S_FK,SERVICIO_FK) VALUES (30,1,1);

insert into servicio values (1,2000,15,'A',1117546315,'MANTENIMINETO',1000,'3000');
insert into servicio values (2,2000,15,'A',1117546315,'LAVADO',1000,'3000');
insert into servicio values (3,7000,15,'A',1117546315,'SERVICIO 3',5000,'10000');



--PROCEDIMIENTOS
--ACTUALIZAR FACTURA 
CREATE OR REPLACE
PROCEDURE Actualiza_Factura(ID_MOD_FACTURA NUMBER, NEW_REPUESTO NUMBER, NEW_SERVICIO NUMBER)
IS

BEGIN 
  UPDATE SERVICIO_FACTURA 
    SET SERVICIO_FK=NEW_SERVICIO, 
        FECHA_MODIFICACION = SYSDATE 
    WHERE FACTURA_S_FK = ID_MOD_FACTURA; 
     
      UPDATE REPUESTO_FACTURA  
    SET REPUESTO_FK= NEW_REPUESTO, 
        FECHA_MODIFICACION = SYSDATE 
    WHERE FACTURA_R_FK = ID_MOD_FACTURA; 
     
    END Actualiza_Factura;

--EJECUTAR - PROCEDIMIENTO ACTUALIZAR FACTURA 

DECLARE
ID_MOD_FACTURA NUMBER := 1;
NEW_REPUESTO NUMBER :=3;
NEW_SERVICIO NUMBER :=3;

BEGIN
Actualiza_Factura(ID_MOD_FACTURA,NEW_REPUESTO,NEW_SERVICIO);
END;

--INSERTAR FACTURA
CREATE OR REPLACE
PROCEDURE Insertar_Factura 
(NEW_PERSONA NUMBER, 
NEW_primer_nombre varchar2, 
NEW_segundo_nombre varchar2, 
NEW_primer_apellido varchar2, 
NEW_segundo_apellido varchar2,
NEW_TIPO_DE_DOCUMENTO varchar2,
NEW_celular number, 
NEW_DIRECCION varchar2, 
NEW_CORREO_ELECTRÓNICO varchar2, 
NEW_estado char, 
NEW_tipo varchar2,
new_iva number)
IS

BEGIN



          insert into persona (documento, PRIMER_NOMBRE,segundo_nombre, PRIMER_APELLIDO, segundo_apellido,  TIPO_DE_DOCUMENTO,celular, DIRECCION, 
          CORREO_ELECTRÓNICO, estado, tipo) values (NEW_PERSONA,NEW_primer_nombre,NEW_segundo_nombre,NEW_primer_apellido,NEW_segundo_nombre,
          NEW_TIPO_DE_DOCUMENTO,NEW_celular,NEW_DIRECCION,NEW_CORREO_ELECTRÓNICO,NEW_estado,NEW_tipo);

          insert into FACTURA (ID_FACTURA, TOTALFACTURA,FECHA_CREACION,PERSONA,iva) 
         values ((select max(ID_FACTURA) from FACTURA) + 1,0, SYSDATE,NEW_PERSONA,new_iva);

       
          
          END Insertar_Factura;


--ejecutar - insertar factura
DECLARE
NEW_PERSONA NUMBER := 1010030686;
NEW_primer_nombre varchar2 := 'Juan' ;
NEW_segundo_nombre varchar2 := '';
NEW_primer_apellido varchar2 := 'Perez';
NEW_segundo_apellido varchar2 := 'Murillo';
NEW_TIPO_DE_DOCUMENTO varchar2 := 'CC';
NEW_celular number := 3216899888;
NEW_DIRECCION varchar2 := 'calle 21';
NEW_CORREO_ELECTRÓNICO varchar2 := 'juan@gmail.com';
NEW_estado char := 'A';
NEW_tipo varchar2 := 'cliente';
new_iva number := 19;
BEGIN
Insertar_Factura(NEW_PERSONA,NEW_primer_nombre,NEW_segundo_nombre,NEW_primer_apellido,NEW_segundo_apellido,NEW_TIPO_DE_DOCUMENTO,NEW_celular,NEW_DIRECCION,
NEW_CORREO_ELECTRÓNICO,NEW_estado,NEW_tipo,new_iva);
END;      


--INSERTAR REPUESTO A FACTURA
CREATE OR REPLACE
PROCEDURE Insertar_Repuesto_Factura (NEW_cantidad number, factura number, repuesto NUMBER)
IS

NEW_CANT_REPUESTO NUMBER;

BEGIN
select PRECIO_POR_UNIDAD * NEW_cantidad INTO NEW_CANT_REPUESTO from repuesto WHERE ID_REPUESTO=repuesto;

         insert into  REPUESTO_FACTURA (cantidad, FACTURA_R_FK,REPUESTO_FK,subtotal) 
         values(NEW_cantidad,factura,repuesto,NEW_CANT_REPUESTO);

          UPDATE REPUESTO
             SET NUMERO_DE_UNIDADES = (SELECT NUMERO_DE_UNIDADES FROM REPUESTO WHERE ID_REPUESTO=repuesto ) -1
             WHERE ID_REPUESTO = repuesto; 
     
          END Insertar_Repuesto_Factura;

--EJECUTAR -INSERTAR REPUESTO

DECLARE
NEW_cantidad number := 10;
factura number := 1;
repuesto NUMBER:= 2;
BEGIN
Insertar_Repuesto_Factura(NEW_cantidad,factura,repuesto);
END;



--INSERTAR SERVICIO
CREATE OR REPLACE
PROCEDURE Insertar_Servicio_Factura (NEW_cantidad number, factura number, SERVICIO NUMBER, NEW_ESTADO CHAR)
IS
NEW_CANT_SERVICIO NUMBER;

BEGIN
select PRECIO_DE_LA_MANO_DE_OBRA * NEW_cantidad INTO NEW_CANT_SERVICIO from servicio WHERE ID_SERVICIO=SERVICIO;

         INSERT INTO SERVICIO_FACTURA (CANTIDAD,FACTURA_S_FK,SERVICIO_FK, SUBTOTAL, ESTADO)
         VALUES (NEW_cantidad,FACTURA,SERVICIO, NEW_CANT_SERVICIO,NEW_ESTADO);
         
               
          END Insertar_Servicio_Factura;

--EJECUTAR -INSERTAR SERVICIO
DECLARE
NEW_cantidad number := 15;
factura number := 1;
SERVICIO NUMBER:= 2;
NEW_ESTADO CHAR :='T';
BEGIN
Insertar_Servicio_Factura(NEW_cantidad,factura,SERVICIO,NEW_ESTADO);
END;



-- procedimeinto consultar

CREATE OR REPLACE
PROCEDURE Consultar_SubTotalFactura (cursor_ OUT SYS_REFCURSOR, new_factura number)
IS

BEGIN
OPEN cursor_ FOR
select f.id_factura, s.id_servicio, sf.cantidad, s.servicio, s.PRECIO_DE_LA_MANO_DE_OBRA as "valor_unitario_de_servicio" , 
r.id_repuesto, rf.cantidad, r.repuesto, r.PRECIO_POR_UNIDAD as "valor_unitario_de_repuesto", 
(r.PRECIO_POR_UNIDAD * rf.cantidad + s.PRECIO_DE_LA_MANO_DE_OBRA * sf.cantidad) as "subtotalFactura"
from factura f
inner join repuesto_factura rf on f.id_factura=rf.FACTURA_R_FK
inner join servicio_factura sf on f.id_factura=sf.FACTURA_S_FK
inner join repuesto r on r.id_repuesto=rf.REPUESTO_FK
inner join servicio s on s.id_servicio=sf.SERVICIO_FK
where f.id_factura=new_factura;

END Consultar_SubTotalFactura;



--EJECUTAR-CONSULTAR
DECLARE
  l_cursor  SYS_REFCURSOR;
  new_factura number :=1;

BEGIN
 Consultar_SubTotalFactura(L_CURSOR,new_factura);
   
END;



--FINALIZAR FACT
CREATE OR REPLACE
PROCEDURE Finalizar_Factura(ID_FACTURA_FIN NUMBER)
IS
estado_servicio char;
IVA_F NUMBER;
TOTALFACTURA_VENTA NUMBER;
SUBTOTAL_FACT_REP NUMBER;
SUBTOTAL_FACT_SER NUMBER;

BEGIN 

SELECT COUNT(ESTADO) INTO estado_servicio  FROM SERVICIO_FACTURA  WHERE ESTADO='A' AND FACTURA_S_FK=ID_FACTURA_FIN;

IF estado_servicio = 0 THEN 

select SUM(SUBTOTAL) INTO SUBTOTAL_FACT_REP from REPUESTO_FACTURA WHERE FACTURA_R_FK=ID_FACTURA_FIN;
select SUM(SUBTOTAL) INTO SUBTOTAL_FACT_SER from SERVICIO_FACTURA WHERE FACTURA_S_FK=ID_FACTURA_FIN;



UPDATE FACTURA 
    SET SUBTOTAL=SUBTOTAL_FACT_REP + SUBTOTAL_FACT_SER
    WHERE ID_FACTURA = ID_FACTURA_FIN; 

select IVA / 100 * SUBTOTAL INTO IVA_F from FACTURA WHERE ID_FACTURA=ID_FACTURA_FIN;

UPDATE FACTURA 
    SET TOTALFACTURA= SUBTOTAL + IVA_F 
    WHERE ID_FACTURA = ID_FACTURA_FIN;
    


ELSE 

 DBMS_OUTPUT.PUT_LINE('No se ha terminado el servicio');

         end if;
          END Finalizar_Factura;
          
          
--EJECUTAR -FINALIZAR FACTURA
DECLARE
factura number := 1;

BEGIN
Finalizar_Factura(factura);
END;

--CONSULTAS SOLICITADAS

--5
SELECT * FROM PERSONA P
INNER JOIN FACTURA F ON P.DOCUMENTO=F.PERSONA
WHERE F.TOTALFACTURA >=90000
AND F.FECHA_CREACION >= TRUNC(SYSDATE - 60);