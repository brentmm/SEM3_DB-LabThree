-- CPRG307 Lab Three Prelab
-- Brent Martin

Set SERVEROUTPUT ON

-- 1
DECLARE
    v_hiredate  DATE := TO_DATE('Jan 10, 2013', 'Mon dd, yyyy');
    v_surname   VARCHAR2(30);
    v_firstname     VARCHAR2(30);
    k_salary CONSTANT   NUMBER(5,2) := 100.25;

BEGIN
    v_surname := 'Martin';
    v_firstname := 'Brent';
    DBMS_OUTPUT.PUT_LINE(v_hiredate);
    DBMS_OUTPUT.PUT_LINE(v_surname);
    DBMS_OUTPUT.PUT_LINE(v_firstname);
    DBMS_OUTPUT.PUT_LINE(k_salary);

END;
/ 

--2
DECLARE
    v_agent_ID  VARCHAR2(7);
    v_agent_lName   VARCHAR2(25);
    v_agent_fName   VARCHAR2(25);
    v_agent_dateHired   DATE;
    v_agent_hPhone  VARCHAR2(10);
    v_agent_bPhone  VARCHAR2(10);

BEGIN

SELECT *
  INTO v_agent_ID, v_agent_lName, v_agent_fName, v_agent_dateHired, v_agent_hPhone, v_agent_bPhone
  FROM ATA_AGENT
  WHERE AGENT_ID = '0000002';



DBMS_OUTPUT.PUT_LINE(v_agent_ID);
DBMS_OUTPUT.PUT_LINE(v_agent_lName);
DBMS_OUTPUT.PUT_LINE(v_agent_fName);
DBMS_OUTPUT.PUT_LINE(v_agent_dateHired);
DBMS_OUTPUT.PUT_LINE(v_agent_hPhone);
DBMS_OUTPUT.PUT_LINE(v_agent_bPhone);

END;
/

--3
DECLARE
    v_agent_ID ATA_AGENT.AGENT_ID%TYPE;
    v_agent_lName   ATA_AGENT.last_name%TYPE;
    v_agent_fName   ATA_AGENT.first_name%TYPE;
    v_agent_dateHired   ATA_AGENT.date_of_hire%TYPE;
    v_agent_hPhone  ATA_AGENT.home_phone%TYPE;
    v_agent_bPhone ATA_AGENT.business_phone%TYPE;

BEGIN

SELECT *
  INTO v_agent_ID, v_agent_lName, v_agent_fName, v_agent_dateHired, v_agent_hPhone, v_agent_bPhone
  FROM ATA_AGENT
  WHERE AGENT_ID = '0000002';



DBMS_OUTPUT.PUT_LINE(v_agent_ID);
DBMS_OUTPUT.PUT_LINE(v_agent_lName);
DBMS_OUTPUT.PUT_LINE(v_agent_fName);
DBMS_OUTPUT.PUT_LINE(v_agent_dateHired);
DBMS_OUTPUT.PUT_LINE(v_agent_hPhone);
DBMS_OUTPUT.PUT_LINE(v_agent_bPhone);

END;
/

--4
DECLARE
  TYPE t_emp IS RECORD (
    v_agent_ID ATA_AGENT.AGENT_ID%TYPE,
    v_agent_lName   ATA_AGENT.last_name%TYPE,
    v_agent_fName   ATA_AGENT.first_name%TYPE,
    v_agent_dateHired   ATA_AGENT.date_of_hire%TYPE,
    v_agent_hPhone  ATA_AGENT.home_phone%TYPE,
    v_agent_bPhone ATA_AGENT.business_phone%TYPE);

    r_emp t_emp;

    BEGIN

  SELECT *
    into r_emp
    FROM ATA_AGENT
    WHERE AGENT_ID = '0000002';

DBMS_OUTPUT.PUT_LINE(r_emp.v_agent_ID);
DBMS_OUTPUT.PUT_LINE(r_emp.v_agent_lName);
DBMS_OUTPUT.PUT_LINE(r_emp.v_agent_fName);
DBMS_OUTPUT.PUT_LINE(r_emp.v_agent_dateHired);
DBMS_OUTPUT.PUT_LINE(r_emp.v_agent_hPhone);
DBMS_OUTPUT.PUT_LINE(r_emp.v_agent_bPhone);

END;
/

--5

DECLARE
r_emp ATA_AGENT%ROWTYPE;

BEGIN

  SELECT *
    into r_emp
    FROM ATA_AGENT
    WHERE AGENT_ID = '0000002';

DBMS_OUTPUT.PUT_LINE(r_emp.AGENT_ID);
DBMS_OUTPUT.PUT_LINE(r_emp.last_name);
DBMS_OUTPUT.PUT_LINE(r_emp.first_name);
DBMS_OUTPUT.PUT_LINE(r_emp.date_of_hire);
DBMS_OUTPUT.PUT_LINE(r_emp.home_phone);
DBMS_OUTPUT.PUT_LINE(r_emp.business_phone);
    

END;
/


-- CPRG307 Lab Three
-- Brent Martin

--1
SET SERVEROUTPUT ON

DECLARE

--Constant Vars
v_emp_presidentTitle CONSTANT VARCHAR2(9) := 'PRESIDENT';
v_emp_salCut CONSTANT NUMBER := 0.25;
v_emp_salMin CONSTANT NUMBER := 100.00;
v_emp_salIncrease CONSTANT NUMBER :=   0.10;

--gereral vars
v_emp_presidentSal emp.sal%TYPE;
v_emp_salSum NUMBER;
v_emp_salAverage NUMBER;
v_emp_numOfEmployees NUMBER;
v_emp_employeeSal emp.sal%TYPE;
v_emp_employeeNum emp.empno%TYPE;

--reduction vars
v_emp_reducePay emp.empno%TYPE;
v_emp_reducedSal NUMBER;

--increase vars
v_emp_increasePay NUMBER;
v_emp_increasedSal NUMBER;


BEGIN

--General Queries

    SELECT sal --query to grab presidents salary amount
    INTO v_emp_presidentSal
    FROM emp 
    WHERE job = v_emp_presidentTitle;

    SELECT count(empno) --counts number of employees in table
    INTO v_emp_numOfEmployees
    FROM emp;
    -- DBMS_OUTPUT.PUT_LINE(v_emp_numOfEmployees);
    
    SELECT sum(sal) --gets sum of all employees salaries
    INTO v_emp_salSum
    FROM emp;
    -- DBMS_OUTPUT.PUT_LINE(v_emp_salSum);

    v_emp_salAverage := v_emp_salSum / v_emp_numOfEmployees;
    --DBMS_OUTPUT.PUT_LINE(v_emp_salAverage);  




--Pay Reduction Queries

    SELECT empno --query to grab overpaid employees ID number
    INTO v_emp_reducePay
    FROM emp
    WHERE sal > v_emp_presidentSal AND job != v_emp_presidentTitle;

    v_emp_reducedSal := v_emp_presidentSal - (v_emp_presidentSal * v_emp_salCut); --reduction calculation

    UPDATE emp --sets overpaid employees salary to $3750
    SET sal = v_emp_reducedSal
    WHERE empno = v_emp_reducePay;


--Pay Increase Queries

    SELECT empno, sal --query to grab underpaid employees ID number and salary amount
    INTO v_emp_increasePay, v_emp_employeeSal
    FROM emp
    WHERE sal < v_emp_salMin;

    v_emp_increasedSal := v_emp_employeeSal + (v_emp_employeeSal * v_emp_salIncrease); --calculation to add %10 to employees salary 

    UPDATE emp -- sets salaray amount with a %10 increase if salary is still below comapany average
    SET sal = v_emp_increasedSal
    WHERE empno = v_emp_increasePay AND v_emp_salAverage > v_emp_increasedSal;

END;
/

--test statements
UPDATE emp
    SET sal = 6000
    WHERE empno = 7934;

UPDATE emp
    SET sal = 90
    WHERE empno = 7900;