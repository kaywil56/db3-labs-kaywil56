--Script for SelectTopNRows command from SSMS  

--SELECT TOP (1000) [PaperID]
--      ,[SemesterID]
--      ,[PersonID]
--  FROM [yourDatabaseName].[dbo].[Enrolment]
  
--  Week 3 labs are due on Friday 19 August 

 --13.1 Develop a stored procedure [EnrolmentCount] that accepts a paperID
	--	and a semesterID and calculates the number of enrolments in the 
	--	relevant paper instance. It returns the enrolment count as an
	--	output parameter.

	create proc EnrolmentCount(@paperID nvarchar(10), @semesterID nvarchar(20))
	as
	return (select count(*) as [Enrolment Count] 
	from Enrolment
	where PaperID = @paperID and SemesterID = @semesterID
	group by PaperID, SemesterID)
	go

	declare @return_value int
	exec @return_value = EnrolmentCount 'IN510', '2019S1'
	print 'Enrolment count is: ' + cast(@return_value as nvarchar(5))
	go
	
--13.2	Re-develop stored procedure [EnrolmentCount] so that semesterID
--		is optional and defaults to the current semester. If there is no
--		current semester, it chooses the most recent semester. 

create or alter proc EnrolmentCount(@paperID nvarchar(10), @SemesterID nvarchar(10) = NULL)
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

return (select count(*) as [Enrolment Count] 
	from Enrolment
	where PaperID = @paperID and SemesterID = @semesterID
	group by PaperID, SemesterID)
end
go

--13.3  Write the script you will need to test 13.2 hint: you may have to cast your output.
declare @return_value int
	exec @return_value = EnrolmentCount 'IN705', '2019S1'
	print 'Enrolment count is: ' + cast(@return_value as nvarchar(5))
	go

declare @return_value int
exec @return_value = EnrolmentCount 'IN705'
	print 'Enrolment count is: ' + cast(@return_value as nvarchar(5))
	go	
		*/