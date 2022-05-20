create table age_group(
age_group_id number(5) primary key,
age_min number(3),
age_max number(3),
age_range number(3));

insert all
into age_group values(10001,10,20,10)
into age_group values(10002,20,30,10)
into age_group values(10003,30,50,20)
into age_group values(10004,50,70,20)
into age_group values(10005,70,100,30)
into age_group values(10006,100,130,30)
into age_group values(10007,130,170,40)
into age_group values(10008,170,210,40)
select * from dual;

create table country1(
country_id number(5) primary key,
country varchar(20));

insert all
into country1 values(20001,'india')
into country1 values(20002,'australia')
into country1 values(20003,'england')
into country1 values(20004,'america')
select * from dual;

create table region(
region_id number(5) primary key,
region varchar(20),
country_id number(5),
foreign key(country_id) references country1(country_id));

insert all
into region values(30001,'south india',20001)
into region values(30002,'victoria',20002)
into region values(30003,'north india',20001)
into region values(30004,'queensland',20002)
into region values(30005,'london',20003)
into region values(30006,'the plains',20004)
into region values(30007,'midlands',20003)
into region values(30008,'the mideast',20004)
select * from dual;


create table resort1(
resort_id number(5) primary key,
resort varchar(20),
country_id number(5),
foreign key(country_id) references country1(country_id));

insert all
into resort1 values(40001,'taj Club',20001)
into resort1 values(40002,'haven',20003)
into resort1 values(40003,'mahindra',20001)
into resort1 values(40004,'blue harbor',20004)
into resort1 values(40005,'rubens',20003)
into resort1 values(40006,'taj Metro',20001)
select * from dual;

create table city2(
city_id number(5) primary key,
city varchar(20),
region_id number(5),
foreign key(region_id) references region(region_id));

insert all
into city2 values(50001,'bangalore',30001)
into city2 values(50002,'hyderabad',30001)
into city2 values(50003,'kochi',30001)
into city2 values(50004,'delhi',30003)
into city2 values(50005,'madurai',30001)
into city2 values(50006,'jaipur',30003)
into city2 values(50007,'mysore',30001)
into city2 values(50008,'agra',30003)
into city2 values(50009,'chennai',30001)
select * from dual;

create table service_line(
sl_id number(5) primary key,
service_line number(3),
resort_id number(5),
foreign key(resort_id) references resort1(resort_id));

insert all
into service_line values(60001,102,40001)
into service_line values(60002,999,40002)
into service_line values(60003,103,40003)
into service_line values(60004,789,40004)
into service_line values(60005,107,40006)
select * from dual;

create table service(
service_id number(5) primary key,
service_name varchar(20),
price number(5),
sl_id number(5),
foreign key(sl_id) references service_line(sl_id));

insert all
into service values(70001,'buffet service',45000,60001)
into service values(70002,'self service',95000,60003)
into service values(70003,'buffet service',14520,60003)
into service values(70004,'waiter service',98752,60001)
into service values(70005,'self service',78542,60002)
into service values(70006,'chinese service',22245,60001)
into service values(70007,'waiter service',34569,60005)
into service values(70008,'no service',74585,60003)
select * from dual;

create table customer3(
cust_id number(5) primary key,
first_name varchar(10),
last_name varchar(10),
phone_no number(10),
address varchar(20),
age_group_id number(5),
city_id number(5),
foreign key(age_group_id) references age_group(age_group_id),
foreign key(city_id) references city2(city_id));

insert all
into customer3 values(80001,'tim','stan',9887410256,'jayanagar',10001,50001)
into customer3 values(80002,'clark','kent',9887410356,'mysore zoo',10002,50007)
into customer3 values(80003,'bill','bucky',9887410456,'jp nagar',10003,50001)
into customer3 values(80004,'peter','parker',9887400256,'charminar',10004,50002)
into customer3 values(80005,'bruce','wayne',9887490256,'dilli haat',10005,50004)
into customer3 values(80006,'barry','allen',9887260256,'jew town',10006,50003)
into customer3 values(80007,'hal','jordon',9887470256,'marina beach',10007,50009)
into customer3 values(80008,'diana','prince',9888810256,'meenakshi temple',10008,50005)
into customer3 values(80009,'tony','stark',9887987256,'hawa mahal',10003,50006)
select * from dual;

create table reservation(
res_id number(5) primary key,
res_date date,
cust_id number(5),
foreign key(cust_id) references customer3(cust_id));

insert all
into reservation values(90001,'19-may-2022',80005)
into reservation values(90002,'25-jun-2022',80006)
into reservation values(90003,'16-apr-2021',80007)
into reservation values(90004,'8-jan-2016',80001)
into reservation values(90005,'7-feb-2018',80002)
into reservation values(90006,'30-aug-2019',80009)
select * from dual;

create table reservation_line(
future_guests number(3),
res_days number(3),
res_id number(5),
service_id number(5),
foreign key(res_id) references reservation(res_id),
foreign key(service_id) references service(service_id));

insert all
into reservation_line values(110,20,90002,70001)
into reservation_line values(200,15,90005,70006)
into reservation_line values(20,17,90006,70002)
into reservation_line values(300,18,90001,70008)
into reservation_line values(250,30,90004,70004)
select * from dual;



commit;
select*from customer3;
---------------------------------------------------------------------------------------------------


--1) Find out the resorts where both customer ‘Tim’and customer ‘Bill’ stayed.
select rt.resort
from customer3 cu,reservation r,reservation_line rl,service s,service_line sl,resort1 rt
where cu.cust_id=r.cust_id
and r.res_id=rl.res_id
and rl.service_id=s.service_id
and s.sl_id=sl.sl_id
and sl.resort_id=rt.resort_id
and cu.cust_id in (select cust_id 
                from customer3
                where first_name = 'tim')
and cu.cust_id in (select cust_id 
                from customer3
                where first_name = 'bill');

                
--2) Find out the services which are available in the resort ‘Taj Club’ but not in ‘Taj Metro’
select service_name
from service s,service_line sl,resort1 rt
where sl.sl_id=s.sl_id
and rt.resort_id=sl.resort_id
and rt.resort_id in (select resort_id
                 from resort1
                 where resort='taj Club')
and rt.resort_id not in (select resort_id
                 from resort1
                 where resort='taj Metro');


--3) Display customer name, age group, city, regionand country who has reserved ‘Boat services’
select cu.first_name||cu.last_name,a.age_group_id,c.city,rg.region,ct.country
from customer3 cu,reservation r,reservation_line rl,service s,age_group a,city2 c,region rg,country1 ct
where cu.cust_id=r.cust_id
and r.res_id=rl.res_id
and rl.service_id=s.service_id
and cu.age_group_id=a.age_group_id
and cu.city_id=c.city_id
and c.region_id=rg.region_id
and rg.country_id=ct.country_id
and s.service_name='boat services';

--4) Write a query to find customers who areaged between 60 and 70 and who havereservation in the next month in India resorts.
select customer
from customer cu,reservations r,reservation_line rl,service s,service_line sl,resort rt,country c
where cu.cust_id=r.cust_id
and r.res_id=rl.res_id
and rl.service_id=s.service_id
and s.sl_id=sl.sl_id
and sl.resort_id=rt.resort_id
and c.country_id=rt.resort_id
and age between 60 and 70
and to_char(res_date,'mm-yy')=to_char(add_months(sysdate,1),'mm-yy')
and country='india';
/

--5) Display the regions where we have more than 10 cities.
select r.region
from region r,city2 c
where r.region_id=c.region_id
group by r.region
having count(c.city_id)>10;

--6) Display age group wise customer count.
select age_group_id,count(cust_id)
from customer
group by age_group_id;


--9)Display country_name, number of regions andnumber of cities for each country.
select country, count(region_id),count(city_id)
from city c,region r, country ct,resort rt
where c.region_id=r.region_id
and r.country_id=ct.country_id
and ct.country_id=rt.country_id
group by country;

--10) Display the number of reservations we have basedon each resort.
select resort,count(res_id)
from reservations r,reservation_line rl,service s,service_line sl,resort rt
where r.res_id=rl.res_id
and rl.service_id=s.service_id
and s.sl_id=sl.sl_id
and sl.resort_id=rt.resort_id
group by resort;

