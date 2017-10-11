Test CRUD App

Requirements:
 - MS SQL Server 2012 Express Edition or higher
 - Node.js
 - React

Install:

1. Download project to some folder

2. Create database schema using file /scripts/db_create_all_objects_and_fill_demo_data.sql
Change test_db to your desired database name
This script also includes inserting demo data
If you want reset demo data later use your database name and file /scripts/demo_data.sql

3. Change database connection parameters in file config.js to yours

4. Navigate to your folder with project. Use cmd or bash to run this commands:
npm init
npm install body-parser  
npm install express  
npm install morgan
npm install mssql

5. Run node server with command:
node server.js

6. Use link http://localhost:7777/ to access application

And you are ready to go!
