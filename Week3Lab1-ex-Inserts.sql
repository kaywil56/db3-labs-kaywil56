
--Using Transact-SQL : Exercises
--------------------------------------------------------------


--Exercises for section 8 : INSERT

--*In all exercises, write the answer statement and then execute it.
--These initial steps are to setup the database to ensure the necessary data is present


--e8.1	Write an insert statement to create 2 new papers: IN338 and IN238 both called 'Extraspecial Topic' 

insert into Paper(PaperID, PaperName)
values
('IN338', 'Extraspecial Topic'),
('IN238', 'Extraspecial Topic')

select * from Paper

--e8.2	Create a new user (yourself)
--		Write the insert statements that will add three enrolments for you
--		in papers you have completed (Add extra papers if required).

insert into Person(PersonID, GivenName, FamilyName, FullName)
values
(112, 'Kaylem', 'Williams', 'Kaylem Williams')

insert into Enrolment(PaperID, SemesterID, PersonID)
values
('IN510', '2023S1', 112),
('IN511', '2023S1', 112),
('IN605', '2023S1', 112)

select Person.FullName, Paper.PaperName from Person join
Enrolment on Person.PersonID = Enrolment.PersonID join
Paper on Enrolment.PaperID = Paper.PaperID
where Person.PersonID = 112

--e8.3	Imagine that every paper on the database will run in the first semester of next year.
--		Write the statements that will create all the necessary paper instances. You may need to add the Semester
--		This can be done using a subselect or a left outer join.

insert into Semester(SemesterID, StartDate, EndDate)
values('2024S1','2024-02-22 00:00:00.000', '2024-06-25 00:00:00.000')

insert into PaperInstance(PaperID, SemesterID)
select PaperID, '2024S1' from Paper
group by PaperID

select * from PaperInstance where SemesterID = '2024S1'

--e8.4	Imagine a strange path-of-study requirement: in semester 2020S1
--		Find all people who were enrolled in IN605 and not enrolled in IN612 in 2019S2 and enrol them in IN238.
--		Write a statement to create the correct paper instance for IN238.
--		Write a statement that will find all people enrolled in IN605 (semester 2019S2)
--		but	not enrolled in IN612 (semester 2019S2) and 
--		will create IN238 (semester 2020S1) enrolments for them. Build it up one step at a time.
		
--		1. create paper, semester and paper instance data
--		2. Find IN605/2019S2 enrolments that are not in IN612
--		3. insert new enrolments

insert into PaperInstance(PaperID, SemesterID)
values ('IN238', '2020S1')

insert into Enrolment(PaperID, SemesterID, PersonID)
select 'IN238', '2020S1', PersonID from Enrolment
where PaperID = 'IN605' and SemesterID = '2019S2'
and not exists (select * from Enrolment
where PaperID = 'IN612' and SemesterID = '2021S2')


select * from Enrolment
where PaperID = 'IN238' and SemesterID = '2020S1'

