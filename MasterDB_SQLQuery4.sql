select * from sysobjects

--select distinct xtype(metadata about the object types) from sysobjects


select 
	xtype,
	COUNT(xtype) as CountOFObjects
from sysobjects 
group by xtype
having xtype='U'


-- use into to create new table and then apply where
select 
	xtype,
	COUNT(xtype) as CountOFObjects into t1
from sysobjects 
group by xtype
select xtype from t1
where xtype='s'


--creating inmemory another tabe
select * from
(select 
	xtype,
	COUNT(xtype) as CountObjects
from sysobjects
group by xtype) as g1 where g1.xtype='U'


--Join only aggregated tables
SELECT 
    a.xtype,
    a.CountObjects
FROM
(
    SELECT xtype, COUNT(*) AS CountObjects
    FROM sysobjects
    GROUP BY xtype
) a
INNER JOIN
(
    SELECT xtype
    FROM sysobjects
    WHERE xtype = 'U'
) b
ON a.xtype = b.xtype;


--Join sysobjects with aggregated counts
SELECT 
    o.name,
    o.xtype,
    CountObjects c
FROM sysobjects o
INNER JOIN
(
    SELECT 
        xtype,
        COUNT(*) AS CountObjects
    FROM sysobjects
    GROUP BY xtype
) c
ON o.xtype = c.xtype
WHERE o.xtype = 'U';

--UNION: will give only one if its duplicate record 

SELECT top 15 BusinessEntityID, LastName from [Person].[Person]
union 
SELECT top 15 BusinessEntityID, LastName from [Person].[Person] order by BusinessEntityID desc


SELECT * from [Person].[Person] 

--Union ALL 

SELECT top 1 BusinessEntityID, LastName from [Person].[Person]
UNION ALL
SELECT top 1 BusinessEntityID, LastName from [Person].[Person]


--sysobjects

SELECT * from sysobjects 

select * from sysobjects where xtype = 'U'

SELECT * from [dbo].[ddddddddddddddddddddddd]

--GUID usage 
SELECT NEWID();
CREATE TABLE Users (
    UserId UNIQUEIDENTIFIER DEFAULT NEWID(),
    UserName VARCHAR(50)
);
INSERT INTO Users (UserName)
VALUES ('Ayushi');

SELECT * FROM Users