create database food_oms_db;
use food_oms_db;

-- 2. Create tables that represent the entities
-- Table: user
create table users (
    user_id int not null auto_increment,
    user_name varchar(100) unique,
    user_password varchar(60),
    primary key (user_id)
);

-- Table: customer
create table customers (
    customer_id int not null auto_increment,
    customer_name varchar(100) unique,
    customer_phone char(15) unique,
    primary key (customer_id)
);

-- Table: order
create table orders (
    order_id int not null auto_increment,
    user_id int,
    customer_id int,
    order_date datetime,
    primary key (order_id),
    foreign key (user_id) references users(user_id),
    foreign key (customer_id) references customers(customer_id)
);

-- Table: items
create table items (
    item_id int not null auto_increment,
    item_name varchar(255),
    item_price int,
    primary key (item_id)
);

-- Table: categories
create table categories (
    category_id int not null auto_increment,
    category_name varchar(100),
    primary key (category_id)
);

-- Table: item_categories
create table item_categories (
    item_id int,
    category_id int,
    foreign key (item_id) references items(item_id),
    foreign key (category_id) references categories(category_id)
);

-- Table: order_details
create table order_details (
    order_id int,
    item_id int,
    item_qty int,
    foreign key (order_id) references orders(order_id),
    foreign key (item_id) references items(item_id)
);

-- 3. insert minimal 5 dummy records for each entity
insert into users (user_name, user_password) values
    ("Daniel", "password"),
    ("Andika", "password"),
    ("Jonathan", "password"),
    ("Clarissa","password"),
    ("Jason", "password");

insert into customers (customer_name, customer_phone) values
    ("Shelly", "081212121210"),
    ("Agus", "081212121211"),
    ("Leo", "081212121212"),
    ("Agatha", "0812121212123"),
    ("Kevin", "081212121214");

insert into items (item_name, item_price) values
    ("Tepung", 25000),
    ("Biskuit", 15000),
    ("Teh Botol", 5000),
    ("Jus Jeruk", 30000),
    ("Sabun Mandi", 10000);

insert into categories (category_name) values
    ("Bahan Kue"),
    ("Cemilan"),
    ("Teh"),
    ("Jus"),
    ("Perawatan Badan");

insert into item_categories values
    (1,1),
    (2,2),
    (3,3),
    (4,4),
    (5,5);

insert into orders (user_id, customer_id, order_date) values
    (1, 1, now()),
    (2, 2, now()),
    (3, 3, now()),
    (4, 4, now()),
    (5, 5, now());

insert into order_details values
    (1,1,1),
    (1,3,2),
    (1,5,3),
    (2,2,2),
    (2,4,1),
    (3,3,4),
    (3,2,5),
    (5,4,1);

-- 4. Display data which contains all order information, with their respective customer name and phone informations
select orders.order_id "Order ID",
       orders.order_date "Order Date",
       customers.customer_name "Customer Name",
       customers.customer_phone "Customer Phone",
       sum(order_details.item_qty * items.item_price) "Total",
       group_concat(items.item_name separator ', ') "Items Bought"
from order_details 
     inner join orders on order_details.order_id = orders.order_id
     inner join customers on customers.customer_id = orders.customer_id
     inner join items on order_details.item_id = items.item_id
group by orders.order_id;
