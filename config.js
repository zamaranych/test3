var sql = require("mssql");

// config for your database
var config = {
    user: 'sa',
    password: 'Qwe1234',
    server: 'KIE-PC\\SQLEXPRESS', 
    database: 'test_db' 
};

// connect to your database
sql.connect(config, function (err) {
    if (err) console.log(err);
});
