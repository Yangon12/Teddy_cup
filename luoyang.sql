USE luoyang;

DROP TABLE SC;/*删除表*/
DROP TABLE course;/*删除表*/
DROP TABLE Student;
CREATE TABLE Student/*创建一个“学生”表*/
(
   Sno CHAR(12) PRIMARY KEY,
   Sname CHAR(20) UNIQUE,
   Ssex CHAR(2),
   Sage SMALLINT,
   Sdept CHAR(20)
);

CREATE TABLE Course/*创建一个“课程”表*/
(
   Cno CHAR(4) PRIMARY KEY,
   Cname CHAR(40) NOT NULL,/*列级完整性约束条件，Cname不能取空值*/
   Cpno CHAR(4),/*Cpno 先修课*/
   Ccredit SMALLINT,
   Foreign Key (Cpno) REFERENCES (Cno)
);

CREATE TABLE SC/*创建一个“选课”表*/
(
    Sno CHAR(10),
    Cno CHAR(4),
    Grade SMALLINT,
    PRIMARY key (Sno,Cno),/*主码由两个属性构成，必须作为表级完整性进行定义*/
    foreign key (Sno) references Student(Sno),
    /*表级完整性约束条件，Sno是外码，被参照表是Student*/
    foreign key (Cno) references Course(Cno)
    /*表级完整性约束条件，Cno是外码，被参照表是Course*/
);

INSERT INTO Student/*插入数据*/
(Sno,Sname,Ssex,Sage,Sdept)
VALUES
(201215123,"王敏", "女",18,"MA");
INSERT INTO course
(Cno,Cname,Cpno,Ccredit)
VALUES
(7,"PASCAL语言",6,4);
INSERT INTO SC
(Sno,Cno,Grade)
VALUES
(2020622030,7,99);

DELETE FROM student WHERE Sno=2020622030;/*删除数据*/
DELETE FROM wangguan WHERE 工号='nice_s05';/*删除数据*/

SELECT * 
FROM Student;/*显示完整的“学生”表*/

CREATE Table wangguan
(
   工号 CHAR(20) PRIMARY KEY,
   姓名 CHAR(20)
);
load data local infile 'D:/Database-learning/wangguan.csv'
into TABLE wangguan fields terminated by ',';/*测试结果：仅在Windows命令窗可用*/

/*课堂作业：P90-P99*/
SELECT Sno,Sname FROM Student;/*3.16*/
SELECT Sname,Sno,Sdept FROM Student;/*3.17*/
SELECT * FROM Student;/*3.18*/
SELECT Sname,2022-Sage FROM Student;/*3.19*/
SELECT Sname,'出生年份:',2022-Sage,LOWER(Sdept) FROM Student;/*3.20*/
SELECT Sname NAME,'出生年份:' BIRTH,2022-Sage BIRTHDAY,LOWER(Sdept) DEPARTMENT FROM Student;/*3.20*/
SELECT Sno FROM SC;/*3.21*/
SELECT DISTINCT Sno FROM SC;/*3.21*//*去除重复值*/
SELECT Sname FROM Student WHERE Sdept='CS';/*3.22*/
SELECT Sname,Sage FROM Student WHERE Sage<20;/*3.23*/
SELECT DISTINCT Sno FROM SC WHERE Grade<60;/*3.24*/
SELECT Sname,Sdept,Sage FROM student WHERE Sage BETWEEN 20 AND 23;/*3.25*/
SELECT Sname,Sdept,Sage FROM student WHERE Sage  NOT BETWEEN 20 AND 23;/*3.26*/
SELECT Sname,Ssex FROM student WHERE Sdept IN('CS','MA','IS');/*3.27*/
SELECT Sname,Ssex FROM student WHERE Sdept NOT IN('CS','MA','IS');/*3.28*/
SELECT * FROM student WHERE Sno LIKE '2020622030';/*3.29*/
SELECT Sname,Sno,Ssex FROM student WHERE Sname LIKE '罗%';/*3.30*/
SELECT Sname,Sno,Ssex FROM student WHERE Sname LIKE '王_';/*3.31*/
SELECT Sname,Sno,Ssex FROM student WHERE Sname LIKE '_晨%';/*3.32*/
SELECT Sname,Sno,Ssex FROM student WHERE Sname  NOT LIKE '刘%';/*3.33*/
SELECT Cno,Ccredit FROM course WHERE Cname LIKE 'DB\_Design' ESCAPE'\';/*3.34*/
SELECT * FROM Course WHERE Cname LIKE 'DB\_%i__' ESCAPE'\';/*3.35*/
SELECT Sno,Cno FROM sc WHERE Grade IS NULL;/*3.36*/
SELECT Sno,Cno FROM sc WHERE Grade IS NOT NULL;/*3.37*/
SELECT Sname FROM student WHERE Sdept='CS' AND Sage<20;/*3.38*/
SELECT Sname,Ssex FROM student WHERE Sdept='CS' OR Sdept='MA' OR Sdept='IS';/*3.38*/
SELECT Sno,Grade FROM sc WHERE Cno='3' ORDER BY Grade DESC;/*3.39*/
SELECT * FROM student ORDER BY Sdept,Sage DESC;/*3.40*/
SELECT count(*) FROM student;/*3.41*/
SELECT count(DISTINCT Sno) FROM sc;/*3.42*/
SELECT AVG(grade) FROM sc WHERE Cno='1';/*3.43*/
SELECT MAX(grade) FROM sc WHERE Cno='1';/*3.44*/
SELECT SUM(grade) FROM sc,course WHERE Sno='201215012' AND SC.Cno=Course.Cno;/*3.45*/
SELECT Cno,COUNT(Sno) FROM sc GROUP BY Cno;/*3.46*/
SELECT Sno FROM sc GROUP BY Sno HAVING COUNT(*)>3;/*3.47*/
SELECT Sno,AVG(grade) FROM SC GROUP BY Sno HAVING AVG(grade)>=90;/*3.48*/

/*基于聚集函数查询，查询所有选课学生当中最高平均分的学生的学号和最高的平均分*/
SELECT Sno,Sname,Gavg AVGgrade
FROM sc,student
WHERE EXISTS (SELECT * FROM sc WHERE student.sno=sc.sno) 
GROUP BY Sno HAVING AVG(grade)>=90;

UPDATE sc SET grade=92 WHERE Sno='2020622030';/*数据更新*/

SELECT Student.Sno,Sname
FROM student,SC
WHERE student.Sno=SC.Sno AND SC.Cno='2' AND SC.Grade>90;

SELECT FIRST.Cno,SECOND.Cpno
FROM course FIRST,Course SECOND
WHERE FIRST.Cpno=SECOND.Cno;

SELECT Student.Sno,Sname,Ssex,Sage,Sdept,Cno,Grade
FROM student LEFT OUTER JOIN SC ON (Student.Sno=SC.Sno);

SELECT `Sno`,`Sname`
FROM student
WHERE `Sno` IN
(SELECT `Sno`
   FROM SC 
   WHERE `Cno` IN
      (SELECT `Cno`
         FROM course
         WHERE `Cname`='信息系统'
         )
);

SELECT Sno,Cno
FROM sc x
WHERE `Grade`>=
   (SELECT AVG(Grade)
   FROM SC y
   WHERE y.`Sno`=x.`Sno`
   );

SELECT Sname
FROM student
WHERE NOT EXISTS
   (SELECT *
   FROM course
   WHERE NOT EXISTS
      (SELECT *
      FROM sc
      WHERE `Sno`=student.`Sno`
         AND `Cno`=course.`Cno`));

/*删除视图*/
DROP VIEW s1;

CREATE VIEW IS_Student
AS
SELECT Sno,Sname,Sage
FROM student
WHERE `Sdept`='IS';

SELECT Sno,Sage
FROM is_student
WHERE `Sage`<20;

CREATE VIEW S1(Sno,Sname)
AS
SELECT student.Sno,Sname
FROM student,sc
WHERE student.`Sno`=sc.`Sno` AND sc.`Cno`=1;

SELECT Sname
FROM s1;

CREATE VIEW S_G(Sno,Gavg)
AS
SELECT `Sno`,AVG(Grade)
FROM sc
GROUP BY `Sno`;

SELECT sc.Sno,student.Sname,Cno,grade,Gavg
FROM sc,s_g,student
WHERE `Grade`>=s_g.`Gavg` AND sc.`Sno`=S_G.`Sno` AND sc.`Sno`=student.`Sno`;

DROP TABLE IF EXISTS workers;
CREATE TABLE workers
(
   Wno char(12),
   Wname char(20) UNIQUE,
   Wage NUMERIC(3),
   CONSTRAINT C3 CHECK (Wage <= 60 AND Wage >= 0),
   Wduty char(50),
   Wsalary char(10),
   Wdno NUMERIC(2),
   PRIMARY KEY (Wdno,Wno)
);
DROP TABLE IF EXISTS department;
CREATE TABLE Department
(
   Wdno NUMERIC(2),
   Dname char(30),
   DMname char(20),
   Dpno char(11),
   PRIMARY KEY (Wdno),
   Foreign Key (Wdno) REFERENCES workers(Wdno)
);

INSERT INTO workers/*完整性检查-插入相同数据-职工表*/
(Wno,Wname,Wage,Wduty,Wsalary,Wdno)
VALUES
(10,'凤飞飞',39,'板砖',4000,1);
INSERT INTO workers/*约束性检查-插入超额年龄-职工表*/
(Wno,Wname,Wage,Wduty,Wsalary,Wdno)
VALUES
(11,'呜呜呜',114,'板砖',4000,1);
INSERT INTO workers/*约束性检查-插入重复名字-职工表*/
(Wno,Wname,Wage,Wduty,Wsalary,Wdno)
VALUES
(11,'凤飞飞',49,'板砖',4000,1);
INSERT INTO department/*完整性检查-插入相同数据-部门表*/
(Wdno,Dname,DMname,Dpno)
VALUES
(1,'搬砖部','柳大壮',13526778229);