create table menu_items(
name varchar(50) ,
price decimal(5,2),
active varchar(5) check (active in ('yes','no')) default 'yes',
dateOfLaunch date,
category varchar(20) check(category in ('Main Course','Staters','Deserts')),
freeDelivery varchar(3) check(freeDelivery in ('yes','no')) default 'yes'
);
go
alter table menu_items alter column name varchar(50) not null 
go
alter table menu_items add constraint pkey1 primary key(name)
go
alter table menu_items drop constraint pkey1
go
alter table menu_items add constraint fkey1 primary key(menuItemId)
go
insert into menu_items(name,price,active,dateOfLaunch,category,freeDelivery) 
values('SandWich',99.00,'yes','2017/03/15','Main Course','yes'),
('Burger',129.00,'yes','2017/12/23','Main Course','no'),
('Pizza',149.00,'yes','2017/08/21','Main Course','no'),
('French Fries',57.00,'no','2017/07/02','Staters','yes'),
('Chocolate Browniee',32.00,'yes','2022/11/02','Deserts','yes')
go
--TYUC001
select * from menu_items
go
--TYUC002
select * from menu_items where dateOfLaunch < GETDATE() and active = 'yes'
go
--Adding menu item id  column
alter table menu_items add menuItemId int identity(1,1)
go
--TYUC003 (select based on menu item id)
create procedure getMenuItems (@id int)
as select * from menu_items where [menuItemId] = @id
go
exec getMenuItems @id = '1'
go
--TYUC003 (update all columns based on menu item id)
create procedure editMenuItems (@id int, @name varchar(50),@price decimal(5,2),@active varchar(5),@dateOfLaunch date,@category varchar(20),@freeDelivery varchar(20))
as
update menu_items
set name = @name, price = @price, active = @active, dateOfLaunch = @dateOfLaunch, category = @category, freeDelivery = @freeDelivery
where menuItemId = @id
go
exec editMenuItems @id='2',@name = 'chocolate browniee', @active ='no', @dateOfLaunch = '2020/11/02', @category = 'Staters', @freeDelivery = 'no',@price = '36.00'
go
--TYUC004
create table users(
user_id int primary key identity(1,1),
user_name varchar(20)
)
go
create table cart(
cart_id int primary key identity(1,1),
user_id int,
menuItemId int,
 constraint fkey2 foreign key (user_id) references users(user_id),
 constraint fkey3 foreign key (menuItemId) references menu_items(menuItemId)
 )
 go
 insert into users (user_name) values('aravind1'),('aravind2')
 go
 insert into cart (user_id, menuItemId)
 values(2,1),(2,3),(2,4)
 go
 --TYUC005 (getting details)
 create procedure getCartDetails (@user_id int)
 as
 select m.name from menu_items m
 inner join cart c on c.menuItemId = m.menuItemId
 go 
 exec getCartDetails @user_id = '2'
 go
 --getting total cost
 create procedure getTotalCost (@user_id int)
 as
 select sum(m.price) from cart c
 inner join menu_items m on m.menuItemId = c.menuItemId
 where c.user_id = @user_id
 go
 exec getTotalCost @user_id = '2'
 go

 --TYUC006
 create procedure removeCartItems (@user_id int, @menuItemId int)
 as
 delete from cart where user_id = @user_id and menuItemId = @menuItemId
 go
 exec removeCartItems @user_id = '2', @menuItemId = '1'
 go