use quanlysinhvien2;
create table Students(
StudentId int primary key,
StudentName varchar(50) not null,
age int not null,
email varchar(100)
);
create table Classes(
ClassId int primary key,
ClassName varchar(50) not null
);
create table Subjects(
SubjectId int primary key,
ClassName varchar(50) not null
);
alter table Subjects
add SubjectName varchar(50) not null;
alter table Subjects
drop ClassName;
create table Marks(
Mark int not null,
SubjectID int not null,
StudentID int not null
);
create table ClassStudent(
StudentID int not null,
ClassID int not null
);
insert into Students(StudentId, StudentName, age, email)
values(1, "Nguyen Quang An", 18, "an@yahoo.com"),
(2, "Nguyen Cong Vinh", 20, "vinh@gmail.com"),
(3, "Nguyen Van Quyen", 19, "quyen"),
(4, "Pham Thanh Binh", 25, "binh@com"),
(5, "Nguyen Van Tai Em", 30, "taiem@sport.vn");
insert into Classes(ClassId, ClassName)
values(1, "C0706L"),
(2, "C0708G");
insert into ClassStudent(StudentId, ClassId)
values(1,1),
(2,1),
(3,2),
(4,2),
(5,2);
insert into Subjects(SubjectID, SubjectName)
values(1, "SQL"),
(2, "Java"),
(3, "C"),
(4, "Visual Basic");
insert into marks(Mark, SubjectId, StudentId)
value(8,1,1),
(4,2,1),
(9,1,1),
(7,1,3),
(3,1,4),
(5,2,5),
(8,3,3),
(1,3,5),
(3,2,4);
alter table Marks
add foreign key(SubjectId) references subjects(SubjectId);
alter table Marks
add foreign key(StudentId) references students(StudentId);
alter table ClassStudent 
add foreign key(StudentId) references students(StudentId);
alter table ClassStudent
add foreign key(ClassId) references Classes(ClassId);
/*1. Hiển thị danh sách tất cả các học viên */
select * from students;
/*2. Hien thi danh sach tat ca cac mon hoc*/
select * from subjects;
/*3. Tính điểm trung bình */
select avg(Mark) 
from marks;
/*4. Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat */
select subjects.SubjectName, marks.Mark
from subjects
join marks on subjects.SubjectId = marks.SubjectID
where marks.Mark = (select max(Marks.Mark) from marks);
/*5 - Danh so thu tu cua diem theo chieu giam*/
select (@row:=@row +1) as Stt, m.mark as Mark
From marks m, (select @row:=0) r
order by m.Mark desc; 
-- Cách 2: 
select row_number() over (order by mark desc) as 'Số Thứ Tự', mark from marks;
/*6- Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)*/
alter table subjects 
modify column SubjectName varchar(255);
/*7. Cap nhat them dong chu « Day la mon hoc «  vao truoc cac ban ghi tren cot SubjectName trong bang Subjects */
update subjects 
set subjectName = concat("Day la mon hoc ", subjectName);
select * from subjects;
/*8- Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50*/
alter table Students 
add constraint age check(age between 15 and 55);
/* 9- Loai bo tat ca quan he giua cac bang*/
set foreign_key_checks=0;
/* 10- Xoa hoc vien co StudentID la 1 */
delete from students 
where StudentID =1;
/*11- Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1*/
alter table students
add status bit default 1;
/*12 - Cap nhap gia tri Status trong bang Student thanh 0 */
update students 
set status =0;


