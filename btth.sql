create schema btth;
use btth;
create table department
(
    id   int primary key auto_increment,
    name varchar(100) not null unique
);
create trigger tg_before_insert_department_name
    before insert
    on department
    for each row
begin
    if length(NEW.name) < 6 then
        SIGNAL sqlstate '45000'
            set message_text = 'Ten phai dai hon 6 ky tu';
    end if;
end;
create table levels
(
    id              int primary key auto_increment,
    name            varchar(100) not null unique,
    BasicSalary     float        not null,
    AllowanceSalary float default 500000
);
create trigger tg_before_insert_levels_basic_salary
    before insert
    on levels
    for each row
begin
    if NEW.BasicSalary < 3500000 then
        signal sqlstate '45000'
            set message_text = 'It nhat la 3500000';
    end if;
end;
create table employee
(
    id           int primary key auto_increment,
    name         varchar(150) not null,
    email        varchar(150) not null unique check ( email like '%@%.%'),
    phone        varchar(50)  not null unique,
    address      varchar(255),
    gender       tinyint      not null,
    birthday     date         not null,
    levelId      int          not null,
    constraint fk_levelid foreign key (levelId) references levels (id),
    departmentid int          not null,
    constraint fk_departmentid foreign key (departmentid) references department (id)
);
create trigger tg_before_insert_employee_gender
    before insert
    on employee
    for each row
begin
    if NEW.gender <> 0 and NEW.gender <> 1 and new.gender <> 2 then
        signal sqlstate '45000'
            set message_text = 'Chi nhan gia tri 0, 1, 2';
    end if;
end;
create table timesheets
(
    id             int primary key auto_increment,
    attendancedate date  not null default (current_date),
    employeeid     int   not null,
    constraint fk_timesheets_employeeid foreign key (employeeid) references employee (id),
    value          float not null default 1
);
create trigger tg_before_insert_timesheets_value
    before insert
    on timesheets
    for each row
begin
    if NEW.value <> 0 and new.value <> 1 and new.value <> 0.5 then
        signal sqlstate '45000'
            set message_text = 'Chi nhan gia tri 0, 0.5, 1';
    end if;
end;
create table salary
(
    id          int primary key auto_increment,
    employeeid  int   not null,
    constraint fk_salary_employeeid foreign key (employeeid) references employee (id),
    bonussalary float default 0,
    insurrance  float not null
);
create trigger tg_before_insert_salary_insurrance
    before insert
    on salary
    for each row
begin
declare basicsalary float;
select BasicSalary into basicsalary from levels join employee e on levels.id = e.levelId where e.id = NEW.employeeid;
    if NEW.insurrance <> basicsalary*0.1 then
        signal sqlstate '45000'
            set message_text = 'insurrance phai bang 10% basesalary';
    end if;
end;
INSERT INTO department (name)
VALUES ('Marketing'),
       ('Human Resources'),
       ('Finance');
INSERT INTO levels (name, BasicSalary, AllowanceSalary)
VALUES ('Entry Level', 4000000, 500000),
       ('Mid Level', 6000000, 500000),
       ('Senior Level', 8000000, 500000);
INSERT INTO employee (name, email, phone, address, gender, birthday, levelId, departmentid)
VALUES ('John Doe', 'john.doe@example.com', '123456789', '123 Main St, City', 1, '1990-01-15', 1, 1),
       ('Jane Smith', 'jane.smith@example.com', '987654321', '456 Oak St, Town', 0, '1992-05-20', 2, 2),
       ('Michael Johnson', 'michael.johnson@example.com', '456123789', '789 Elm St, Village', 1, '1985-09-10', 3, 3),
       ('Emily Brown', 'emily.brown@example.com', '789456123', '101 Pine St, County', 0, '1988-07-08', 1, 1),
       ('David Wilson', 'david.wilson@example.com', '321654987', '321 Cedar St, State', 1, '1995-03-25', 2, 2),
       ('Sarah Lee', 'sarah.lee@example.com', '654987321', '654 Birch St, Country', 0, '1991-11-30', 3, 3),
       ('Daniel Kim', 'daniel.kim@example.com', '987321654', '987 Maple St, Province', 1, '1987-02-18', 1, 1),
       ('Jessica Garcia', 'jessica.garcia@example.com', '741852963', '741 Pineapple St, Territory', 0, '1993-04-12', 2,
        2),
       ('Christopher Martinez', 'christopher.martinez@example.com', '852963741', '852 Banana St, Republic', 1,
        '1989-08-05', 3, 3),
       ('Lisa Nguyen', 'lisa.nguyen@example.com', '369258147', '369 Orange St, Kingdom', 0, '1994-06-22', 1, 1),
       ('Matthew Hernandez', 'matthew.hernandez@example.com', '258147369', '258 Apple St, Empire', 1, '1997-12-03', 2,
        2),
       ('Ashley Smith', 'ashley.smith@example.com', '147258369', '147 Lemon St, Dominion', 0, '1996-10-17', 3, 3),
       ('James Brown', 'james.brown@example.com', '369147258', '369 Peach St, Union', 1, '1998-02-28', 1, 1),
       ('Amanda Wilson', 'amanda.wilson@example.com', '258369147', '258 Strawberry St, Federation', 0, '1990-04-05', 2,
        2),
       ('Ryan Taylor', 'ryan.taylor@example.com', '147369258', '147 Grape St, Confederation', 1, '1986-06-15', 3, 3);
-- Ví dụ với 30 bản ghi
INSERT INTO timesheets (attendancedate, employeeid, value)
VALUES ('2024-04-01', 1, 1),
       ('2024-04-02', 2, 1),
       ('2024-04-03', 3, 1),
       ('2024-04-04', 1, 1),
       ('2024-04-05', 2, 1),
       ('2024-04-06', 3, 1),
       ('2024-04-07', 1, 1),
       ('2024-04-08', 2, 1),
       ('2024-04-09', 3, 1),
       ('2024-04-10', 1, 1),
       ('2024-04-11', 2, 1),
       ('2024-04-12', 3, 1),
       ('2024-04-13', 1, 1),
       ('2024-04-14', 2, 1),
       ('2024-04-15', 3, 1),
       ('2024-04-16', 1, 1),
       ('2024-04-17', 2, 1),
       ('2024-04-18', 3, 1),
       ('2024-04-19', 1, 1),
       ('2024-04-20', 2, 1),
       ('2024-04-21', 3, 1),
       ('2024-04-22', 1, 1),
       ('2024-04-23', 2, 1),
       ('2024-04-24', 3, 1),
       ('2024-04-25', 1, 1),
       ('2024-04-26', 2, 1),
       ('2024-04-27', 3, 1),
       ('2024-04-28', 1, 1),
       ('2024-04-29', 2, 1),
       ('2024-04-30', 3, 1);
INSERT INTO salary (employeeid, bonussalary, insurrance)
VALUES (1, 0, 400000),
       (2, 0, 600000),
       (3, 0, 800000);
select e.id,e.name, email, phone, address, gender, birthday, l.name, d.name from employee e join department d on d.id = e.departmentid join levels l on l.id = e.levelId order by e.name;
select s.id,e.name,e.phone,e.email,l.BasicSalary,l.AllowanceSalary,s.bonussalary,s.insurrance from salary s join employee e on e.id = s.employeeid join levels l on l.id = e.levelId;
select d.id, d.name, count(e.departmentid) from department d join employee e on d.id = e.departmentid group by d.id, d.name;
select employeeid, sum(value) from timesheets group by employeeid;
update salary
set bonussalary = 10 where
employeeid in (select timesheets.employeeid from timesheets where month(attendancedate)=3 group by timesheets.employeeid having sum(value)>=20 );
delete from department
where
    department.id not in (select employee.departmentid from employee group by departmentid );
create view v_getEmployeeInfo
as
select e.id,e.name as employeename,e.email,e.phone,e.address, CASE
                                                                  WHEN gender = 0 THEN 'Nữ'
                                                                  WHEN gender = 1 THEN 'Nam'
                                                                  ELSE 'Không xác định'
    END AS gender,e.birthday,d.name as departmentanem,l.name as levelname from employee e join department d on d.id = e.departmentid join levels l on l.id = e.levelId ;
select * from v_getEmployeeInfo;
create view v_getEmployeeSalaryMax as
    select e.id,e.name,e.email,e.phone,e.birthday, totalday.totalday from employee e join (select employeeid,sum(value) as totalday from timesheets group by employeeid having sum(value)>18) as totalday on e.id = totalday.employeeid;
select * from v_getEmployeeSalaryMax;
DELIMITER //
create procedure
    addEmployeeInfor(newname varchar(150), newemail varchar(150), newphone varchar(50), newaddress varchar(255), newgender tinyint,newbirthday date,newleveid int, newdepartmentid int)
begin
    insert into employee( name, email, phone, address, gender, birthday, levelId, departmentid)
        values (newname,newemail,newphone,newaddress,newgender,newbirthday,newleveid,newdepartmentid);
end //

//DELIMITER ;
call addEmployeeInfor('abcdasd','asdsda@gmail.com','012548451','sdadawdsdad',0,'2002-09-06',1,1);
DELIMITER //
create procedure
    getSalaryByEmployeeId(emplid int)
begin
    declare basicsalary float;
    declare allowancesalary float;
    declare totalday float;
    select levels.BasicSalary into basicsalary from levels join employee e on levels.id = e.levelId where e.id = emplid;
    select levels.AllowanceSalary into allowancesalary from levels join employee e on levels.id = e.levelId where e.id = emplid;
    select sum(value) into totalday from timesheets s where s.employeeid = emplid group by s.employeeid;
    select e.id,e.name,e.phone,e.email,basicsalary,allowancesalary,s.bonussalary,s.insurrance,totalday from employee e join salary s on e.id = s.employeeid where e.id = emplid;
end //
// DELIMITER ;
call getSalaryByEmployeeId(2);
DELIMITER //
create procedure
    getEmployeePaginate (limitnum int, pagenum int)
begin
    declare offset_val int;
   set offset_val = (pagenum-1)*limitnum;
    select id,name,email,phone,address,gender,birthday from employee limit limitnum offset offset_val;
end //;
// DELIMITER ;
call getEmployeePaginate(5,2);
create trigger tr_check_basic_salary
    before insert on levels
    for each row
    if new.BasicSalary>10000000 then
        set new .BasicSalary=10000000;
    end if;

