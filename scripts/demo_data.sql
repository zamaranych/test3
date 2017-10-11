use test_db
GO

delete from stores
insert into stores(stor_name, stor_city)
select 'Gucci', 'Milan'
union
select 'Petrovka', 'Kyiv'
union
select 'AMG', 'New York'

delete from prod_types
insert into prod_types (type_id, type_name)
select 1, 'Book'
union
select 2, 'Toy'
union
select 3, 'Clothes'

delete from products
insert into products (prod_name, prod_type)
select 'Prod 1', 1
union
select 'Prod 2', 1
union
select 'Prod 3', 2
union
select 'Prod 4', 2
union
select 'Prod 5', 3
union
select 'Prod 6', 3
