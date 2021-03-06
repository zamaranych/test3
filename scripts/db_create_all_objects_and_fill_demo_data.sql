USE [master]
GO
/****** Object:  Database [test_db]    Script Date: 11.10.2017 12:05:45 ******/
CREATE DATABASE [test_db]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'test_db', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\test_db.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'test_db_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\test_db_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [test_db] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [test_db].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [test_db] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [test_db] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [test_db] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [test_db] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [test_db] SET ARITHABORT OFF 
GO
ALTER DATABASE [test_db] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [test_db] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [test_db] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [test_db] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [test_db] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [test_db] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [test_db] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [test_db] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [test_db] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [test_db] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [test_db] SET  DISABLE_BROKER 
GO
ALTER DATABASE [test_db] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [test_db] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [test_db] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [test_db] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [test_db] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [test_db] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [test_db] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [test_db] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [test_db] SET  MULTI_USER 
GO
ALTER DATABASE [test_db] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [test_db] SET DB_CHAINING OFF 
GO
ALTER DATABASE [test_db] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [test_db] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [test_db]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_prices]    Script Date: 11.10.2017 12:05:45 ******/
CREATE TYPE [dbo].[udt_prices] AS TABLE(
	[stor_id] [int] NOT NULL,
	[prod_id] [int] NOT NULL,
	[price] [numeric](18, 2) NOT NULL,
	[mode] [int] NOT NULL
)
GO
/****** Object:  StoredProcedure [dbo].[sp_get_prices]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_get_prices] 
  @p_stor_id int = null,
  @p_prod_type int = null,
  @p_prod_id int = null
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  begin try
    select prod_id, prod_name, prod_type, type_name
	  from prices
	    inner join stores on stor_id = pric_stor_id
		inner join products on prod_id = pric_prod_id
	    left join prod_types on type_id = prod_type
	 where 1=1
	   and stor_id = isnull(@p_stor_id, stor_id)
	   and (@p_prod_type is null or prod_type = @p_prod_type)
	   and prod_id = isnull(@p_prod_id, prod_id);
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_get_prod_types]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_get_prod_types] 
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  begin try
    select type_id, type_name
	  from prod_types
	 where 1=1;
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_get_products]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_get_products] 
  @p_prod_id int = null,
  @p_prod_name varchar(50) = null,
  @p_prod_type int = null
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  begin try
    select prod_id, prod_name, prod_type, type_name
	  from products
	    left join prod_types on type_id = prod_type
	 where 1=1
	   and prod_id = isnull(@p_prod_id, prod_id)
	   and (@p_prod_name is null or lower(prod_name) like '%' + lower(replace(@p_prod_name, '%', '')) + '%')
	   and (@p_prod_type is null or prod_type = @p_prod_type);
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_get_stores]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_get_stores] 
  @p_stor_id int = null,
  @p_stor_name varchar(50) = null,
  @p_stor_city varchar(50) = null
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  begin try
    select stor_id, stor_name, stor_city
	  from stores
	 where 1=1
	   and stor_id = isnull(@p_stor_id, stor_id)
	   and (@p_stor_name is null or lower(stor_name) like '%' + lower(replace(@p_stor_name, '%', '')) + '%')
	   and (@p_stor_city is null or lower(stor_city) like '%' + lower(replace(@p_stor_city, '%', '')) + '%');
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_prices_upd]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_prices_upd]
  @p_prices_tab udt_prices ReadOnly
AS
  declare
    @err varchar(1000),
	@cnt int;
BEGIN
  SET NOCOUNT ON;

  select @cnt = count(*) from @p_prices_tab;
  if @cnt = 0
    throw 51000, 'Nothing to update', 1;

  begin try
	MERGE prices AS a
	USING @p_prices_tab AS b
	  ON (a.pric_stor_id = b.stor_id and a.pric_prod_id = b.prod_id)
	WHEN MATCHED AND b.mode = -1 -- delete row
      THEN DELETE
	WHEN MATCHED AND b.mode = 0 -- update row
      THEN UPDATE SET a.pric_value = b.price
	WHEN NOT MATCHED and b.mode = 1 -- insert row
      THEN INSERT (pric_stor_id, pric_prod_id, pric_value)
        VALUES (b.stor_id, b.prod_id, b.price)
	OUTPUT $action, deleted.*, inserted.*;
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_product_del]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_product_del] 
  @p_prod_id int
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  if @p_prod_id is null
    throw 51000, 'Not allowed to call procedure [dbo].[sp_product_del] with NULL parameter', 1;

  begin try
    delete from products where prod_id = @p_prod_id;
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_product_ins]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_product_ins]
  @p_prod_name varchar(50) = null,
  @p_prod_type int = null
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  if @p_prod_name is null or len(@p_prod_name) = 0
    throw 51000, 'Please fill in field <Product Name>', 1;

  begin try
    insert into products(prod_name, prod_type)
	  values(@p_prod_name, @p_prod_type);
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_product_upd]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_product_upd]
  @p_prod_id int,
  @p_prod_name varchar(50) = null,
  @p_prod_type int = null
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  if @p_prod_id is null
    throw 51000, 'Not allowed to call procedure [dbo].[sp_product_upd] with NULL parameter @p_prod_id', 1;
  
  if @p_prod_name is null or len(@p_prod_name) = 0
    throw 51000, 'Please fill in field <Product Name>', 1;

  begin try
    update products
	   set prod_name = @p_prod_name,
	       prod_type = @p_prod_type
	 where prod_id = @p_prod_id;
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_store_del]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_store_del] 
  @p_stor_id int
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  if @p_stor_id is null
    throw 51000, 'Not allowed to call procedure [dbo].[sp_store_del] with NULL parameter', 1;

  begin try
    delete from stores where stor_id = @p_stor_id;
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_store_ins]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_store_ins] 
  @p_stor_name varchar(50) = null,
  @p_stor_city varchar(50) = null
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  if @p_stor_name is null or len(@p_stor_name) = 0
    throw 51000, 'Please fill in field <Store Name>', 1;

  begin try
    insert into stores(stor_name, stor_city)
	  values(@p_stor_name, @p_stor_city);
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  StoredProcedure [dbo].[sp_store_upd]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_store_upd]
  @p_stor_id int,
  @p_stor_name varchar(50) = null,
  @p_stor_city varchar(50) = null
AS
  declare @err varchar(1000);
BEGIN
  SET NOCOUNT ON;

  if @p_stor_id is null
    throw 51000, 'Not allowed to call procedure [dbo].[sp_store_upd] with NULL parameter @p_stor_id', 1;
  
  if @p_stor_name is null or len(@p_stor_name) = 0
    throw 51000, 'Please fill in field <Store Name>', 1;

  begin try
    update stores
	   set stor_name = @p_stor_name,
	       stor_city = @p_stor_city
	 where stor_id = @p_stor_id;
  end try
  begin catch
    select @err = ERROR_MESSAGE();
    throw 51000, @err, 1;
  end catch

END

GO
/****** Object:  Table [dbo].[prices]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prices](
	[pric_stor_id] [int] NOT NULL,
	[pric_prod_id] [int] NOT NULL,
	[pric_value] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_prices] PRIMARY KEY CLUSTERED 
(
	[pric_stor_id] ASC,
	[pric_prod_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[prod_types]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[prod_types](
	[type_id] [int] NOT NULL,
	[type_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_prod_types] PRIMARY KEY CLUSTERED 
(
	[type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[products]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[products](
	[prod_id] [int] IDENTITY(1,1) NOT NULL,
	[prod_name] [varchar](50) NOT NULL,
	[prod_type] [int] NULL,
 CONSTRAINT [PK_products] PRIMARY KEY CLUSTERED 
(
	[prod_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stores]    Script Date: 11.10.2017 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[stores](
	[stor_id] [int] IDENTITY(1,1) NOT NULL,
	[stor_name] [varchar](50) NOT NULL,
	[stor_city] [varchar](50) NULL,
 CONSTRAINT [PK_stores] PRIMARY KEY CLUSTERED 
(
	[stor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [IX_products]    Script Date: 11.10.2017 12:05:46 ******/
CREATE NONCLUSTERED INDEX [IX_products] ON [dbo].[products]
(
	[prod_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[prices]  WITH CHECK ADD  CONSTRAINT [FK_prices_products] FOREIGN KEY([pric_prod_id])
REFERENCES [dbo].[products] ([prod_id])
GO
ALTER TABLE [dbo].[prices] CHECK CONSTRAINT [FK_prices_products]
GO
ALTER TABLE [dbo].[prices]  WITH CHECK ADD  CONSTRAINT [FK_prices_stores] FOREIGN KEY([pric_stor_id])
REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[prices] CHECK CONSTRAINT [FK_prices_stores]
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD  CONSTRAINT [FK_products_prod_types] FOREIGN KEY([prod_type])
REFERENCES [dbo].[prod_types] ([type_id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[products] CHECK CONSTRAINT [FK_products_prod_types]
GO
USE [master]
GO
ALTER DATABASE [test_db] SET  READ_WRITE 
GO

/****** Fill in demo data ******/
use [test_db]
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

GO
