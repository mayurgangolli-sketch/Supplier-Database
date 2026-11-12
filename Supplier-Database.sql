create database supplys;
use supplys;
CREATE TABLE Supplier (
    sid INT NOT NULL,
    sname VARCHAR(20) NOT NULL,
    city VARCHAR(20) NOT NULL,
    PRIMARY KEY (sid)
);

CREATE TABLE Parts (
    pid INT NOT NULL,
    pname VARCHAR(20) NOT NULL,
    color VARCHAR(20) NOT NULL,
    PRIMARY KEY (pid)
);

CREATE TABLE Catalog (
    sid INT NOT NULL,
    pid INT NOT NULL,
    cost INT NOT NULL,
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);
INSERT INTO Supplier VALUES (10001, 'Acme Widget', 'Bangalore');
INSERT INTO Supplier VALUES (10002, 'Johns', 'Kolkata');
INSERT INTO Supplier VALUES (10003, 'Vimal', 'Mumbai');
INSERT INTO Supplier VALUES (10004, 'Reliance', 'Delhi');
INSERT INTO Parts VALUES (20001, 'Book', 'Red');
INSERT INTO Parts VALUES (20002, 'Pen', 'Red');
INSERT INTO Parts VALUES (20003, 'Pencil', 'Green');
INSERT INTO Parts VALUES (20004, 'Mobile', 'Green');
INSERT INTO Parts VALUES (20005, 'Charger', 'Black');
INSERT INTO Catalog VALUES (10001, 20001, 10);
INSERT INTO Catalog VALUES (10001, 20002, 10);
INSERT INTO Catalog VALUES (10001, 20003, 30);
INSERT INTO Catalog VALUES (10001, 20004, 10);
INSERT INTO Catalog VALUES (10001, 20005, 10);
INSERT INTO Catalog VALUES (10002, 20001, 10);
INSERT INTO Catalog VALUES (10002, 20002, 20);
INSERT INTO Catalog VALUES (10003, 20003, 30);
INSERT INTO Catalog VALUES (10004, 20003, 40);

SELECT DISTINCT P.pname FROM Parts P JOIN Catalog C ON P.pid = C.pid;

SELECT S.sname FROM Supplier S WHERE NOT EXISTS (SELECT P.pid FROM Parts P WHERE NOT EXISTS (SELECT C.pid FROM Catalog C WHERE C.sid = S.sid AND C.pid = P.pid));

SELECT S.sname FROM Supplier S WHERE NOT EXISTS (SELECT P.pid FROM Parts P WHERE P.color = 'Red' AND NOT EXISTS (SELECT C.pid FROM Catalog C WHERE C.sid = S.sid AND C.pid = P.pid));

SELECT P.pname FROM Parts P JOIN Catalog C ON P.pid = C.pid JOIN Supplier S ON C.sid = S.sid WHERE S.sname = 'Acme Widget' AND NOT EXISTS (SELECT * FROM Catalog C2 WHERE C2.pid = P.pid AND C2.sid <> S.sid);

SELECT DISTINCT C1.sid FROM Catalog C1 WHERE C1.cost > (SELECT AVG(C2.cost) FROM Catalog C2 WHERE C2.pid = C1.pid);

SELECT C.pid, S.sname FROM Catalog C JOIN Supplier S ON C.sid = S.sid WHERE C.cost = (SELECT MAX(C2.cost) FROM Catalog C2 WHERE C2.pid = C.pid);

SELECT P.pid, P.pname, S.sname, C.cost FROM Catalog C JOIN Parts P ON C.pid = P.pid JOIN Supplier S ON C.sid = S.sid WHERE C.cost = (SELECT MAX(cost) FROM Catalog);

SELECT S.sname FROM Supplier S WHERE NOT EXISTS (SELECT * FROM Catalog C JOIN Parts P ON C.pid = P.pid WHERE C.sid = S.sid AND P.color = 'Red');

SELECT S.sname, SUM(C.cost) AS total_value FROM Supplier S JOIN Catalog C ON S.sid = C.sid GROUP BY S.sid, S.sname;

SELECT S.sname, COUNT(C.pid) AS part_count FROM Supplier S JOIN Catalog C ON S.sid = C.sid WHERE C.cost < 20 GROUP BY S.sid, S.sname HAVING COUNT(C.pid) >= 2;

SELECT P.pid, P.pname, S.sname, C.cost FROM Catalog C JOIN Parts P ON C.pid = P.pid JOIN Supplier S ON C.sid = S.sid WHERE C.cost = (SELECT MIN(C2.cost) FROM Catalog C2 WHERE C2.pid = C.pid);


