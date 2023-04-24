create database quanlyhocvien;
use quanlyhocvien;
create table Test(
    testID int primary key,
    Name varchar(20)
);
create table Student(
    RN int primary key,
    Name varchar(20),
    Age tinyint
);
create table StudentTest(
    RN int,
    testID int,
    Date datetime,
    Mark float,
    foreign key (RN) references Student(RN),
    foreign key (testID) references Test(testID)
);
insert into student(RN, Name, Age)
values (1, 'Nguyen Hong Ha', 20),
       (2, 'Truong Ngoc Anh', 30),
       (3, 'Tuan Minh', 25),
       (4, 'Dan Truong', 22);
insert into Test(testID, Name)
values (1, 'EPC'),
       (2, 'DWMX'),
       (3,'SQL1'),
       (4,'SQL2');
-- a Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55
alter table student
add constraint age check ( age between 15 and 55);
-- b: Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
alter table studenttest
modify column Mark float default 0;
-- c: Thêm khóa chính cho bảng studenttest là (RN,TestID)
alter table studenttest
add primary key(RN, testID);
-- d: Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
alter table Test
add unique (Name);
-- e: Xóa ràng buộc duy nhất (unique) trên bảng Test
alter table Test
modify column Name varchar(20);
-- Bài 3: Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi giống như hình sau:
select student.name, studenttest.mark, T.Name, StudentTest.Date
from studenttest
left join Student on StudentTest.RN = Student.RN
left join Test T on StudentTest.testID = T.testID;

-- Bài 4: Hiển thị danh sách hv chưa thi môn nào
select Student.RN,Student.Name, Student.Age
from student
left join StudentTest on Student.RN = StudentTest.RN
where StudentTest.RN is null;

-- Bài 5: Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5) như sau:
select s.Name, t.name, studenttest.mark
from studenttest
join Student S on S.RN = StudentTest.RN
join test t on StudentTest.testID = t.testID
where studenttest.mark <5;

-- Bài 6: Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần(
select student.name, format(avg(st.mark),2)  as 'Avg Mark'
from student
join StudentTest ST on Student.RN = ST.RN
group by student.name
order by avg(st.mark) desc;
-- Bài 7: Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau:
select student.name, format(avg(st.mark),2)  as 'Avg Mark'
from student
join StudentTest ST on Student.RN = ST.RN
group by student.name
order by avg(st.mark) desc limit 1;
-- Bài 8: Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học như sau:
select t.name, max(studenttest.mark) as "Max mark "
from studenttest
join test t on StudentTest.testID = t.testID
group by t.Name
-- Bài 9: Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null như sau:
select student.name, test.name
from student
left join StudentTest ST on Student.RN = ST.RN
left join test on st.testId = test.testId;
-- Bài 10: Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update student
set age = age+1;
-- Bài 11: Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
alter table student
add status varchar(10);
-- Bài 12:  Cập nhật (Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student lên như sau:
update student
set status = 'Young'
where age<30;
update student
set status = 'Old'
where age>=30;
-- Bài 13: Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi như sau:
select student.name, st.mark, st.date
from student
join StudentTest ST on Student.RN = ST.RN
order by st.Date;
-- Bài 14: Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5.
-- Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình
select student.name, student.age, avg(ST.mark)as 'TB'
from student
join StudentTest ST on Student.RN = ST.RN
where Student.name like 't%'
group by student.name
having TB>4.5
-- Bài 15: Hiển thị các thông tin sinh viên (Mã, tên, tuổi, điểm trung bình, xếp hạng).
-- Trong đó, xếp hạng dựa vào điểm trung bình của học viên, điểm trung bình cao nhất thì xếp hạng 1.
select student.RN, student.Name, format(avg(ST.mark),2) as 'TB',
row_number() over (order by avg(ST.mark) desc ) as 'Xếp hạng '
from student
join StudentTest ST on Student.RN = ST.RN
group by student.Name
-- Bài 16: Sửa đổi kiểu dữ liệu cột name trong bảng student thành nvarchar(max)
alter table student
modify column Name varchar(255);
-- Bài 17: Cập nhật (sử dụng phương thức write) cột name trong bảng student với yêu cầu sau:
update student
set Name = if(Age<=20, concat('Young ', Name), concat('Old ', Name))
-- Bài 18:  Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi
delete  FROM test t1
WHERE NOT EXISTS (SELECT 1 FROM studenttest t2 WHERE t1.TestID = t2.TestID);
SET SQL_SAFE_UPDATES = 0;
-- Bài 19: Xóa thông tin điểm thi của sinh viên có điểm <5.
select s.name, st.mark
from studenttest st
join Student S on st.RN = S.RN;
delete from studenttest
where studenttest.mark <5;






