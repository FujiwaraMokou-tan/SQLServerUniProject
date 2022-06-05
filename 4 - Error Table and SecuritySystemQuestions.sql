use PROJETO
----------------------------  Store Procedure para Questions--------------------------------
go

--create or alter procedure sp_CreateQuestions2
--as
insert into PROJETO.dbo.Questions(Ques_Question) values('What city were you born in?');
insert into PROJETO.dbo.Questions(Ques_Question) values('Where is your favorite place to vacation?');
insert into PROJETO.dbo.Questions(Ques_Question) values('What is your favorite food?');
insert into PROJETO.dbo.Questions(Ques_Question) values('Where did you go to high school/college?');
insert into PROJETO.dbo.Questions(Ques_Question) values('Where did you meet your spouse?');
insert into PROJETO.dbo.Questions(Ques_Question) values('What was the first company that you worked for?');
insert into PROJETO.dbo.Questions(Ques_Question) values('What was the name of your first/current/favorite pet?');
insert into PROJETO.dbo.Questions(Ques_Question) values('What is your motherÅfs maiden name?');
insert into PROJETO.dbo.Questions(Ques_Question) values('What is the name of the road you grew up on?');	
insert into PROJETO.dbo.Questions(Ques_Question) values('What is your favorite book?');	

--exec sp_CreateQuestions2


----------------------------  Store Procedure para ERROR--------------------------------

go

--create or alter procedure sp_CreateERROR
--as

insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(1 , 'Important Column Value doesnt Exist.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(2 , 'Column not nullable.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(3 , 'Dates do not make sense.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(4 , 'Product does not exists!');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(5 , 'Cannot use duplicate Value on Unique Field.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(6 , 'Wrong Password.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(7, 'User has less than 3 security questions answered.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(8, 'Category to SubCategory does not exist.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(9, 'Cannot apply promotion, Price higher than Base Price.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(10, 'Status Can only be Current or Null.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(11, 'The ID of this company doesnt Exist.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(12, 'This product status is not Current therefore cannot be sold.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(13, 'User doesnt exist or is already offline.');
insert into PROJETO.dbo.ERROR(ER_ErrorID, ER_Message) values(14, 'Foreign key does not exists.');
--exec sp_CreateERROR
