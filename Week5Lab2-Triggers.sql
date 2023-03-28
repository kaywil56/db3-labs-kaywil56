
--Using Transact-SQL : Exercises
--------------------------------------------------------------

--Exercises for section 11 : TRIGGER

--*In all exercises, write the answer statement and then execute it.

--*Before you start, run these statements against your database:

--		create table [Password](
--			PersonID nvarchar(16) not null primary key,
--			pwd char(4) not null default left(newID(), 4)  --automatically create a new password
--			constraint [fk_password_person] foreign key (PersonID) references Person (PersonID) 	
--			on delete cascade on update cascade 			
--			)

--		insert Person (PersonID, GivenName, FamilyName, FullName)
--		values ('122', 'Krissi', 'Wood', 'Krissi Wood')

--		drop table Withdrawn

--	 	create table Withdrawn(
--			PaperID nvarchar(10) not null,
--			SemesterID char(6) not null,
--			PersonID nvarchar(16) not null,
--			WithdrawnDateTime datetime not null default getdate()
--			constraint [pk_withdrawn] primary key (PaperID, SemesterID, PersonID)
--			)


--e11.1		Create a trigger that reacts to new records on the Person table. 
--			The trigger creates new related records on the Password table, automatically creating passwords.

		create trigger trigNewPerson on person
		after insert
		as
		begin
			insert into [Password](PersonID)
			select inserted.PersonID from inserted
		end
		go

		insert into Person(PersonID, GivenName, FamilyName, FullName)
		values(132, 'Kaylem', 'Williams', 'Kaylem Williams')
		select * from [Password]

--e11.2		Create a trigger that reacts to new paper instances
--			by automatically making an enrolment for Krissi Wood in those paper instances
--			drop trigger trigPaperInstanceInsert

		create trigger trigPaperInstanceInsert on PaperInstance
		after insert 
		as
		begin
			insert into Enrolment(PaperID, SemesterID, PersonID)
			select inserted.PaperID, inserted.SemesterID, 122 from inserted
		end
		go

		insert into PaperInstance(PaperID, SemesterID)
		values('IN510', '2077S1')

		select * from Enrolment where PersonID = 122
--e11.3		Create two triggers that record the people who withdraw or dropout of a paper 
--			when it is running [compare the system date to the semester dates].
--			The details of the withdrawl should be posted to the Withdrawn table.

--1.	If a student can withdraw from a paper, then re-enrol, then withdraw again in one single semester.
--	BTW: this is NOT how things run at Otago Polytechnic.

				--if person already has a withdrawn record for this paper instance
				--insert will cause a PK violation, so
				--delete the existing record before inserting new record

create trigger trigPersonReEnrollWithdrawn on Enrolment
after delete
as
begin
	if exists (select * from Withdrawn where PaperID = deleted.PaperID 
	and SemesterID = deleted.SemesterID and PersonID = deleted.PersonID)
	begin
		delete from WithDrawn where PaperID = deleted.PaperID 
		and SemesterID = deleted.SemesterID and PersonID = deleted.PersonID
	end
	insert into Withdrawn(PaperID, SemesterID, PersonID)
	select PaperID, SemesterID, PersonID from Enrolment
end
go

--2.	If a student can withdraw from the paper only one time in a single semester
--	BTW: this is what happens at OP. Drop or disable the previous trigger.

	select * from Enrolment

	create trigger trigPersonWithdrawn on Enrolment
	after delete
	as
	begin
		if not exists (select * from Withdrawn where PaperID = deleted.PaperID 
		and SemesterID = deleted.SemesterID and PersonID = deleted.PersonID)
		begin
			insert into Withdrawn(PaperID, SemesterID, PersonID)
			select PaperID, SemesterID, PersonID from Enrolment
		end
		drop trigger trigPersonReEnrollWithdrawn
	end
	go

--e11.4		Enhance the mechanism from e11.1 so that it also reacts when 
--			a person's PersonID is modified. 
--			In this case, the system must generate a new password for the modified PersonID.

alter trigger trigNewPerson on person
		after insert, update
		as
		begin
		if update(PersonID)
			begin
				update [Password] set [Password].PersonID = inserted.PersonID, [Password].pwd = left(newid(), 4)
				from [Password] join inserted on [Password].PersonID = inserted.PersonID
			end
		else
			begin
				insert into [Password](PersonID)
				select inserted.PersonID from inserted
			end
		end
		go