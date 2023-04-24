
--Using Transact-SQL : Exercises
--------------------------------------------------------------
---- Careful of any triggers you may have running from the previous lab.
---- You can list all triggers by querying the sys.triggers view
--select * from sys.triggers

--Exercises for Section 15

--15.1    Develop a view [BigPaperInstance] that finds the 10 paper instances
--		with the most enrolments. Show the paperID, paper name,
--		semesterID, start date and end date of the paper instance.

--create view BigPaperInstance
--as
go
create view BigPaperInstance as
select top 10 PaperName, StartDate, EndDate, PaperInstance.PaperID, s.SemesterID, [Enrolment Count] from Paper p
join PaperInstance on p.PaperID = PaperInstance.PaperID
	join(	
		select PaperID, SemesterID, count(*) as [Enrolment Count] 
		from Enrolment
		group by PaperID, SemesterID
		) as e on e.PaperID = p.PaperID
	join Semester s on e.SemesterID = s.SemesterID
	group by  PaperName, StartDate, EndDate, PaperInstance.PaperID, s.SemesterID, [Enrolment Count]
	order by [Enrolment Count] desc
go

select * from BigPaperInstance

--15.2    Develop a view [SmallPaper] that finds the 10 paper instances
--		with the least (lowest number of) enrolments. Show the paperID, paper name,
--		semesterID, start date and end date of the paper instance.

go
create view SmallPaper as
select top 10 PaperName, StartDate, EndDate, PaperInstance.PaperID, s.SemesterID, [Enrolment Count] from Paper p
join PaperInstance on p.PaperID = PaperInstance.PaperID
	join(	
		select PaperID, SemesterID, count(*) as [Enrolment Count] 
		from Enrolment
		group by PaperID, SemesterID
		) as e on e.PaperID = p.PaperID
	join Semester s on e.SemesterID = s.SemesterID
	group by  PaperName, StartDate, EndDate, PaperInstance.PaperID, s.SemesterID, [Enrolment Count]
	order by [Enrolment Count] asc
go

select * from SmallPaper 

--15.3	Write a view that lists all the current first year students
---- you will need to have a current semester and some students enrolled
go
create view CurrentFirstYears
as
select FullName from Person join Enrolment on
Person.PersonID = Enrolment.PersonID
where SemesterID = '2023S1'
go

select * from CurrentFirstYears
--***************************************************************************************

--		You can reference a Database table even if you are not 
--		currently connected to it as long as you use its fully qualified domain name.
--		The following two questions are using the countries table in the World Database.
--		You can use this to find the FQDN for World using a new query pointed at that Database:

--			select
--				 @@SERVERNAME [server name],
--				 DB_NAME() [database name],
--				 SCHEMA_NAME(schema_id) [schema name], 
--				 name [table name],
--				 object_id,
--				 "fully qualified name (FQN)" =
--				 concat(QUOTENAME(DB_NAME()), '.', QUOTENAME(SCHEMA_NAME(schema_id)),'.', QUOTENAME(name))
--			from sys.tables
--			where type = 'U' -- USER_TABLE
--Using World:

--15.4    Develop a view [ConsonantCountry] that lists the countries that have a name
--		starting with a consonant (b c d f g h j k l m n p q r s t v w x y z).
--		Show the code and name of each country.
go 
create view ConsonantCountry
as
select Name from Country
where not (
Name like 'A%'
or Name like 'E%' 
or Name like'I%' 
or Name like 'O%'
or Name like 'U%')
go

--15.5   Develop a view [RecentlyIndependentCountry] that lists countries that 
--		gained their independence within the last 100 years. 
--		Make sure the view adjusts the resultset to take account of the date when it is run.

go
create view RecentlyIndependentCountry
as
select * from Country
where IndepYear >= year(getdate()) - 100
go