
--Exercises for section 4

delete from PaperInstance where PaperID = 'IN610' -- I populated this table using a cross join so all of the data will match otherwise.
insert into Enrolment values ('IN511', '2019S2', 102);

select * from enrolment
select * from Semester
select * from Paper
select * from Person
select * from PaperInstance

--4.1	List the starting date and ending date of each occasion 
--	IN511 Programming 2 has run.

select StartDate, EndDate from PaperInstance 
join Semester on PaperInstance.SemesterID = Semester.SemesterID
where PaperID = 'IN511'

--4.2	List all the full names of the people who have ever enrolled in
--	IN511 Programming 2 .
--	If a person has enrolled more than once, do not repeat their name.

select FullName, Enrolment.PaperID from Person 
join Enrolment on Person.PersonID = Enrolment.PersonID
where Enrolment.PaperID = 'IN511'
group by FullName, Enrolment.PaperID

--4.3	List all the full names of all the people who have never enrolled in a paper
--	(according to the data on the database).

select FullName from Person 
left join Enrolment on Person.PersonID = Enrolment.PersonID
where Enrolment.PersonID is NULL

--4.4	List all the papers that have never been run (according to the data).There are currently none so insert one in order to test the query.
--Insert into Paper values ('IN728', 'Programming5') 

select PaperName from Paper 
left join PaperInstance on Paper.PaperID = PaperInstance.PaperID
where SemesterID is NULL

--4.5	List all the semesters, showing semester start date and length in days, in which IN511 has run.

select StartDate, DATEDIFF(DAY, StartDate, EndDate) as "Length in days" from Semester
join PaperInstance on Semester.SemesterID = PaperInstance.SemesterID
where PaperID = 'IN511'

--4.6	Develop a statement that returns all people that enrolled in IN511 
--	in a semester that started on or between 12-Apr-2018 and 13-Aug-2019.
--	Display the full name of each person and the year in which they enrolled. 
--	Ensure the people are listed alphabetically according to their family name then given name.

select FullName, Semester.StartDate as 'Start' from Person
join Enrolment on Person.PersonID = Enrolment.PersonID
join PaperInstance on Enrolment.PaperID = PaperInstance.PaperID
join Semester on PaperInstance.SemesterID =  Semester.SemesterID
where StartDate between '2018-04-12' and '2019-08-13' and PaperInstance.PaperID = 'IN511'
group by FullName, Semester.StartDate


--Exercises for section 5

--5.1	List all the papers that have a paper instance. 
--	Display the PaperID and number of instances of the paper.

select Paper.PaperID, count(PaperInstance.PaperID) as [Number of instances] from Paper
join PaperInstance on Paper.PaperID = PaperInstance.PaperID
group by Paper.PaperID

--5.2	How many people, in total over all semesters, have enrolled in each of the papers
--	that have been delivered? Display the paper ID, paper name and enrolment count.

select Paper.PaperID, PaperName , count(PersonID) as [Enrolment count] from Enrolment
join PaperInstance on Enrolment.PaperID = PaperInstance.PaperID
join Paper on PaperInstance.PaperID = Paper.PaperID
group by Paper.PaperID, PaperName

--5.3	How many people, in total over all semesters, have enrolled in each of the papers
--	listed on the Paper table? Display the paper ID, paper name and enrolment count.

select Paper.PaperID, PaperName , count(PersonID) as [Enrolment count] from Enrolment
join PaperInstance on Enrolment.PaperID = PaperInstance.PaperID
right join Paper on PaperInstance.PaperID = Paper.PaperID
group by Paper.PaperID, PaperName

--5.4	List the paper instance with the highest enrolment. 
--	Display the paper instance's start date, end date, paper name and enrolment count.

select top 1 Paper.PaperID, Paper.PaperName, Semester.StartDate, Semester.EndDate, count(Enrolment.PersonID) as [Enrolment count] from PaperInstance
join Semester on PaperInstance.SemesterID = Semester.SemesterID
join Paper on PaperInstance.PaperID = Paper.PaperID
join Enrolment on PaperInstance.PaperID = Enrolment.PaperID
group by Paper.PaperName, Semester.StartDate, Semester.EndDate,  Paper.PaperID
order by count(Enrolment.PaperID) desc

--5.5	List all the people who have 3, 4 or 5 enrolments.

select FullName, count(Enrolment.PersonID) [Number of enrolments] from Person
join Enrolment on Person.PersonID = Enrolment.PersonID
group by FullName
having count(Enrolment.PersonID) between 3 and 5
