
--6.0	Subqueries can replace tables and views

--6.1	Simple subquery in the FROM clause. The subquery must be in brackets and have an alias

	select SemesterID, PersonID 
	from (select SemesterID, PersonID  from Enrolment where SemesterID = '2019S1') as e
	
	--same as this
	select SemesterID, PersonID 
	from Enrolment
	where SemesterID = '2019S1'

--6.2	Subqueries are most useful when they use aggregated results
--	Note the use of column aliases

	select PaperName, StartDate, [Enrolment Count] from Paper p
	join 	(	

		select PaperID, SemesterID, count(*) as [Enrolment Count] 
		from Enrolment
		group by PaperID, SemesterID

		) as e on e.PaperID = p.PaperID
	join Semester s on e.SemesterID = s.SemesterID

--6.3	Statements with subqueries usually have a simpler semantic equivalent
--	[Sometimes it is easier to understand the statement if you use a subquery. 
--	The Query Optimiser will find the semantic equivalent at compile time]
--	Compare these statements and their resultsets with the above statements

	select SemesterID, PersonID from Enrolment where SemesterID = '2019S1'

	select 
		PaperName, 
		StartDate, 
		count(*) as [Enrolment Count] 
	from Paper p
	join Enrolment e 
		on e.PaperID = p.PaperID
	join Semester s 
		on e.SemesterID = s.SemesterID
	group by PaperName, StartDate

--6.4	Subqueries can be used in other places

--	**For example: find people enrolled in an above average number of papers
--	Firstly, calculate the average papers per student
	select avg(PaperCount) as [Average Papers per Person] from
		(select personID, cast(count(*) as decimal(9,4)) as PaperCount 
			from enrolment
			group by personID) as e

--	Secondly, use the previous query in a filtering clause
	select personID, count(*) as PaperCount 
	from enrolment
	group by personID
	having count(*) > (
		--here's the statement from above
		select avg(PaperCount) as [Average Papers per Person] from
		(select personID, cast(count(*) as decimal(9,4)) as PaperCount 
			from enrolment
			group by personID) as e)


--	**For example: Find all people whose FamilyName starts with the least frequent starting character
--	Firstly, find the count of FamilyNames for each starting letter
	select left(FamilyName, 1) as [Starting Letter], count(*) as [Name Count] 
	from Person
	group by left(FamilyName, 1)

--	Secondly, find the least frequent starting letter for FamilyName
	select top 1 with ties [Starting Letter], [Name Count] from 
		(select left(FamilyName, 1) as [Starting Letter], count(*) as [Name Count] 
		from Person
		group by left(FamilyName, 1) )as n
	order by [Name Count] asc

--	Thirdly, find matching FamilyNames

--!!!!!!! this does not handle  NULL FamilyName
	select * from Person
	where left(FamilyName, 1) in 
		( select top 1 with ties [Starting Letter] from 
				(select left(FamilyName, 1) as [Starting Letter], count(*) as [Name Count] 
				from Person
				group by left(FamilyName, 1) ) as n
			order by [Name Count] asc)
		


--7.0	 UNION collects rows from individual SELECT statements
-- This section requires you to load the additional Customer and Supplier tables

select * from Customer
select * from Supplier


--7.1	Simple UNION statement.
--	Note that column alias must be in first SELECT statement
--	!!!! Add the Supplier and Customer tables
	select SupplierID as OrganisationID, SupplierName, 'S' as [Type]
	from Supplier
	union
	select CustomerID, CustomerName, 'C'
	from Customer

--7.2	UNION returns distinct rows. UNION ALL returns duplicates
--	Compare the statements and resultsets

	select SupplierName as [Name] from Supplier
	union 
	select CustomerName from Customer

	select SupplierName as [Name] from Supplier
	union all
	select CustomerName from Customer
	union  
	select 'X'
	




