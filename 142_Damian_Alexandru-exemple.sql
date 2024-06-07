--1. Selectați nume, prenumele, casinoul unde lucreaza și
-- jocul de care se ocupă al angajaților cu un salariu
-- mai mare decat salariul mediu al angajaților care se
-- ocupă de jocurile de tip Masă.
SELECT
    s.STAFF_NUME, s.STAFF_PRENUME, c.CASINO_NUME, j.JOC_NUME
FROM
    STAFF s
JOIN
    RESPONSABIL_JOC rjoc ON s.STAFF_ID = rjoc.STAFF_ID
JOIN
    JOC j ON rjoc.JOC_ID = j.JOC_ID
JOIN
    CASINO c ON s.CASINO_ID = c.CASINO_ID
WHERE
    s.STAFF_SALARIU > (SELECT AVG(STAFF_SALARIU) FROM STAFF)
AND
    upper(j.JOC_TIP) = 'MASA';



--2. Selectați numele, prenumele și numarul de tranzacții
-- ale jucatorilor cu un numar total de tranzacții mai
-- mare decat 250.
SELECT
    jucatori.JUCATOR_NUME, jucatori.JUCATOR_PRENUME, tranzactii.total_tranzactii
FROM
    (SELECT
        JUCATOR_ID,
        JUCATOR_NUME,
        JUCATOR_PRENUME
    FROM
        JUCATOR) jucatori
JOIN
    (SELECT
        JUCATOR_ID,
        SUM(TRANZACTIE_SUMA) AS total_tranzactii
    FROM
        TRANZACTIE
    GROUP BY
        JUCATOR_ID) tranzactii
ON
    jucatori.JUCATOR_ID = tranzactii.JUCATOR_ID
WHERE
    tranzactii.total_tranzactii > 250;



--3. Selectați numele casinoului, numărul de angajați
-- și salariul mediu pentru casinoul al căror angajați
-- au un salariu mediu mai mare decât salariul mediu
-- al tuturor casinourilor și au cel putin 2 angajați.
SELECT
    c.CASINO_NUME,
    COUNT(s.STAFF_ID) AS numar_angajati,
    AVG(s.STAFF_SALARIU) AS salariu_mediu
FROM
    CASINO c
JOIN
    STAFF s ON c.CASINO_ID = s.CASINO_ID
GROUP BY
    c.CASINO_NUME
HAVING
    AVG(s.STAFF_SALARIU) > (SELECT AVG(STAFF_SALARIU) FROM STAFF)
AND
    COUNT(s.STAFF_ID) > 1;
select * from zona



--4. Selectați numele jocurilor și prețul acestora,
-- dacă au un preț nenul, altfel, să se afișeze
-- Prețul nu este disponibil.
SELECT
    JOC_NUME,
    DECODE(NVL(JOC_PRET, 0), 0, 'Pretul nu este disponibil', 'Pretul: ' || TO_CHAR(JOC_PRET)) AS INFO_PRET
FROM
    JOC
ORDER BY
    JOC_NUME;
SELECT * FROM STAFF;



--5. Selectați numele, prenumele,
-- casinoul unde este angajat,
-- data angajarii și tipul de
-- vechime al tuturor angajaților.
SELECT
    s.STAFF_NUME,
    s.STAFF_PRENUME,
    c.CASINO_NUME,
    TO_CHAR(s.STAFF_DATA_ANGAJARE, 'DD/MM/YYYY') AS DATA_ANGAJARE,
    CASE
        WHEN MONTHS_BETWEEN(TO_DATE('01-jan-2023','dd-mon-yyyy'), s.STAFF_DATA_ANGAJARE) < 12 THEN 'Junior'
        WHEN MONTHS_BETWEEN(TO_DATE('01-jan-2023','dd-mon-yyyy'), s.STAFF_DATA_ANGAJARE) >= 12 AND
             MONTHS_BETWEEN(TO_DATE('01-jan-2023','dd-mon-yyyy'), s.STAFF_DATA_ANGAJARE) < 24 THEN 'Intermediar'
        ELSE 'Senior'
    END AS vechime
FROM
    STAFF s
JOIN
    CASINO c ON s.CASINO_ID = c.CASINO_ID
ORDER BY
    s.STAFF_NUME, s.STAFF_PRENUME;



--1. Actualizarea salariului la salariul
-- mediu al tuturor angajatelor care
-- au prenumele Ana.
UPDATE STAFF
SET STAFF_SALARIU = (
    SELECT AVG(STAFF_SALARIU)
    FROM STAFF
)
WHERE UPPER(STAFF_PRENUME) ='ANA';



--2. Ștergem tranzacțiile a căror sumă este
-- mai mică decât medie sumelor tranzacționate.
DELETE FROM TRANZACTIE
WHERE TRANZACTIE_SUMA < (
    SELECT AVG(TRANZACTIE_SUMA)
    FROM TRANZACTIE
);
SELECT * FROM JOC;



--3. Creștem prețul cu 10 jocurilor al
-- caror preț este mai mic decat 20,
-- altfel îl păstrăm pe cel inițial.
UPDATE JOC
SET JOC_PRET = (
    SELECT CASE
               WHEN JOC_PRET < 20 THEN JOC_PRET + 10
               ELSE JOC_PRET
           END
    FROM JOC j
    WHERE j.JOC_ID = JOC.JOC_ID
)
WHERE JOC_PRET < 20;


