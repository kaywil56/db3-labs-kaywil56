
--Using Transact-SQL : Exercises
--------------------------------------------------------------
--Note: I will be marking off the labs two from the first week on Friday, make sure you have committed your work to GitHub.
		


--Exercises for section 9 : UPDATE

--*In all exercises, write the answer statement and then execute it.


--e9.1	Change the name of IN628 to 'Object-Oriented Software Development (discontinued after 2020)'  

update Paper set PaperName = 'Object-Oriented Software Development (discontinued after 2020)'
where PaperID = 'IN628'

select * from Paper
where PaperID = 'IN628'

--e9.2	For all the semesters that start after 01-June-2018, alter the end date
--		to be 14 days later than currently recorded.

update Semester set EndDate = DATEADD(DAY, 14, EndDate) 
where StartDate > '2018-06-01'

select * from Semester
where StartDate > '2018-06-01'

--e9.3	Imagine a strange enrolment requirement regarding the students
--		enrolled in IN238 for 2020S1 [Ensure your database has all the records
--		created by exercise e8.4]: all students with short names [length of FullName
--		is less than 12 characters] must have their enrolment moved 
--		from 2020S1 to 2019S2. Write a statement that will perform this enrolment change.
		
--		--Ensure you create the related paperInstance

select * from PaperInstance

insert into PaperInstance(PaperID, SemesterID)
values('IN238', '2019S2')

update Enrolment set SemesterID = '2019S2'
where PersonID in (select PersonID from Person
where len(FullName) < 12) and  Enrolment.PaperID = 'IN238' and SemesterID  = '2020S1'

select * from Enrolment
where SemesterID = '2019S2' and PaperID = 'IN238'

--Exercises for section 10 : DELETE

--*In all exercises, write the answer statement and then execute it.

--e10.1	Write a statement to delete all enrolments for IN238 Extraspecial Topic in semester 2020S1.

delete Enrolment
where SemesterID = '2020S1' AND PaperID = 'IN238'

select * from Enrolment
where SemesterID = '2020S1' AND PaperID = 'IN238'
		

--e10.2	Delete all PaperInstances that have no enrolments.
delete PaperInstance
from PaperInstance left join
Enrolment on PaperInstance.PaperID = Enrolment.PaperID
where Enrolment.PaperID is null

select * from Semester
		