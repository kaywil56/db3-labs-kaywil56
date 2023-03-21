
--Using Transact-SQL : Exercises
--------------------------------------------------------------

--Exercises for section 12 : STORED PROCEDURE

--*In all exercises, write the answer statement and then execute it.



--e12.1		Create a SP that returns the people with a family name that 
--			starts with a vowel [A,E,I,O,U]. List the PersonID and the FullName.

create procedure getVowelFamilyName as
select PersonID, FullName from person		
where FamilyName like 'A%' or
FamilyName like 'E%' or
FamilyName like 'I%' or
FamilyName like 'O%' or
FamilyName like 'U%'

execute getVowelFamilyName

--e12.2		Create a SP that accepts a semesterID parameter and returns the papers that
--			have enrolments in that semester. List the PaperID and PaperName.

create proc getPapersForSemester(@SemesterID nvarchar(10))
as
select Paper.PaperID, Papername from Paper
join PaperInstance on Paper.PaperID =  PaperInstance.PaperID
where SemesterID = @SemesterID
go

getPapersForSemester '2017S1'

--e12.3		Modify the SP of 12.2 so that the parameter is optional.
--			If the user	does not supply a parameter value default to the current semester.
--			If there is no current semester default to the most recent semester.

create or alter proc getPapersForSemester(@SemesterID nvarchar(10) = NULL)
as
begin

declare @currentSemester nvarchar(10)
declare @mostRecentSemester nvarchar(10)

set @currentSemester = (select SemesterID from Semester
group by SemesterID, StartDate, EndDate		
having getdate() between StartDate and EndDate)

set @mostRecentSemester = (select top 1 SemesterID from Semester 
order by StartDate desc)

-- Default to most recent sem is no current semester
if @currentSemester IS NULL set @currentSemester = @mostRecentSemester

-- If no param is passed then default to either the current or most recent sem
if @SemesterID IS NULL set @SemesterID = @currentSemester
select Paper.PaperID, Papername from Paper
join PaperInstance on Paper.PaperID =  PaperInstance.PaperID
where SemesterID = @SemesterID

end
go

getPapersForSemester '2017S1'
getPapersForSemester

--e12.4		Create a SP that creates a new semester record. the user must supply all
--			appropriate input parameters.

select * from Semester

create proc addNewSemester(@SemesterID nvarchar(10), @StartDate datetime, @EndDate datetime)
as

insert into Semester(SemesterID, StartDate, EndDate)
values(@SemesterID, @StartDate, @EndDate)

go

addNewSemester '2050S1', '2050-02-02 00:00:00.000', '2050-06-06 00:00:00.000'
