var express = require("express");
var path = require("path");
var sql = require("mssql");
var bodyParser = require('body-parser');
var morgan = require("morgan");
var db = require("./config.js");
  
var app = express();
var port = process.env.port || 7777;
var srcpath = path.join(__dirname,'/public') ;

app.use(express.static('public'));
app.use(bodyParser.json({limit:'5mb'}));
app.use(bodyParser.urlencoded({extended:true, limit:'5mb'}));

//api for get data from database
app.get("/api/getprodtypes", function(req,res){
  // create Request object
  var request = new sql.Request();

  // query to the database and get the records
  request.execute('sp_get_prod_types', function (err, recordset) {
    if (err) console.log(err)
    // send records as a response
    res.send(recordset);
  });
})  


//api for get data from database
app.get("/api/getstores", function(req,res){
  // create Request object
  var request = new sql.Request();

  // query to the database and get the records
  request.execute('sp_get_stores', function (err, recordset) {
    if (err) console.log(err)
    // send records as a response
    res.send(recordset);
  });
})  
  

//api for Delete data from database
app.post("/api/delstore", function(req,res){
 
  var myTransaction = new sql.Transaction();
    myTransaction.begin(function (error) {
      var rollBack = false;
      myTransaction.on('rollback', function (aborted) {
        rollBack = true;
      });

      var request = new sql.Request();

      // input params
      request.input('p_stor_id', sql.Int, req.body.stor_id);

      request.execute("sp_store_del", function (err, recordset) {
        if (err) {
          if (!rollBack) {
            myTransaction.rollback(function (err) {
              console.dir(err);
            });
          }
          res.send({data: err.originalError.info.message});
        }
        else {
          myTransaction.commit()
            .then(function (recordset) {
               //console.dir('Record has been deleted successfully!');
               res.send({data: 'Record has been deleted successfully!'});
             })
            .catch(function (err) {
               //console.dir('Error in transaction commit ' + err);
               res.send({data: 'Error in transaction commit ' + err.originalError.info.message});
             });
        }
      });
    });
})
  
  
//api for Update data in database  
app.post("/api/updstore", function(req,res){

  var myTransaction = new sql.Transaction();
    myTransaction.begin(function (error) {
      var rollBack = false;
      myTransaction.on('rollback', function (aborted) {
        rollBack = true;
      });

      var request = new sql.Request();

      // input params
      request.input('p_stor_id', sql.Int, req.body.stor_id);
      request.input('p_stor_name', sql.NVarChar, req.body.stor_name);
      request.input('p_stor_city', sql.NVarChar, req.body.stor_city);

      request.execute("sp_store_upd", function (err, recordset) {
        if (err) {
          if (!rollBack) {
            myTransaction.rollback(function (err) {
              console.dir(err);
            });
          }
          res.send({data: err.originalError.info.message});
        }
        else {
          myTransaction.commit()
            .then(function (recordset) {
               //console.dir('Record has been updated successfully!');
               res.send({data: 'Record has been updated successfully!'});
             })
            .catch(function (err) {
               //console.dir('Error in transaction commit ' + err);
               res.send({data: 'Error in transaction commit ' + err.originalError.info.message});
             });
        }
      });
    });
})

  
//api for Insert data to database  
app.post("/api/insstore", function(req,res){
       
  var myTransaction = new sql.Transaction();
    myTransaction.begin(function (error) {
      var rollBack = false;
      myTransaction.on('rollback', function (aborted) {
        rollBack = true;
      });

      var request = new sql.Request();

      // input params
      request.input('p_stor_name', sql.NVarChar, req.body.stor_name);
      request.input('p_stor_city', sql.NVarChar, req.body.stor_city);

      request.execute("sp_store_ins", function (err, recordset) {
        if (err) {
          if (!rollBack) {
            myTransaction.rollback(function (err) {
              console.dir(err);
            });
          }
          res.send({data: err.originalError.info.message});
        }
        else {
          myTransaction.commit()
            .then(function (recordset) {
               //console.dir('Record has been inserted successfully!');
               res.send({data: 'Record has been inserted successfully!'});
             })
            .catch(function (err) {
               //console.dir('Error in transaction commit ' + err);
               res.send({data: 'Error in transaction commit ' + err.originalError.info.message});
             });
        }
      });
    });
})

      
//api for get data from database
app.get("/api/getproducts", function(req,res){
  // create Request object
  var request = new sql.Request();

  // query to the database and get the records
  request.execute('sp_get_products', function (err, recordset) {
    if (err) console.log(err)
    // send records as a response
    res.send(recordset);
  });
})  
  

//api for Delete data from database
app.post("/api/delproduct", function(req,res){
 
  var myTransaction = new sql.Transaction();
    myTransaction.begin(function (error) {
      var rollBack = false;
      myTransaction.on('rollback', function (aborted) {
        rollBack = true;
      });

      var request = new sql.Request();

      // input params
      request.input('p_prod_id', sql.Int, req.body.prod_id);

      request.execute("sp_product_del", function (err, recordset) {
        if (err) {
          if (!rollBack) {
            myTransaction.rollback(function (err) {
              console.dir(err);
            });
          }
          res.send({data: err.originalError.info.message});
        }
        else {
          myTransaction.commit()
            .then(function (recordset) {
               //console.dir('Record has been deleted successfully!');
               res.send({data: 'Record has been deleted successfully!'});
             })
            .catch(function (err) {
               //console.dir('Error in transaction commit ' + err);
               res.send({data: 'Error in transaction commit ' + err.originalError.info.message});
             });
        }
      });
    });
})
  
  
//api for Update data in database  
app.post("/api/updproduct", function(req,res){

  var myTransaction = new sql.Transaction();
    myTransaction.begin(function (error) {
      var rollBack = false;
      myTransaction.on('rollback', function (aborted) {
        rollBack = true;
      });

      var request = new sql.Request();

      // input params
      request.input('p_prod_id', sql.Int, req.body.prod_id);
      request.input('p_prod_name', sql.NVarChar, req.body.prod_name);
      request.input('p_prod_type', sql.Int, req.body.prod_type);

      request.execute("sp_product_upd", function (err, recordset) {
        if (err) {
          if (!rollBack) {
            myTransaction.rollback(function (err) {
              console.dir(err);
            });
          }
          //console.log(err);
          res.send({data: err.originalError.info.message});
          //res.send({data: 'oops'});
        }
        else {
          myTransaction.commit()
            .then(function (recordset) {
               //console.dir('Record has been updated successfully!');
               res.send({data: 'Record has been updated successfully!'});
             })
            .catch(function (err) {
               //console.dir('Error in transaction commit ' + err);
               res.send({data: 'Error in transaction commit ' + err.originalError.info.message});
             });
        }
      });
    });
})

  
//api for Insert data to database  
app.post("/api/insproduct", function(req,res){
       
  var myTransaction = new sql.Transaction();
    myTransaction.begin(function (error) {
      var rollBack = false;
      myTransaction.on('rollback', function (aborted) {
        rollBack = true;
      });

      var request = new sql.Request();

      // input params
      request.input('p_prod_name', sql.NVarChar, req.body.prod_name);
      request.input('p_prod_type', sql.Int, req.body.prod_type);

      request.execute("sp_product_ins", function (err, recordset) {
        if (err) {
          if (!rollBack) {
            myTransaction.rollback(function (err) {
              console.dir(err);
            });
          }
          res.send({data: err.originalError.info.message});
        }
        else {
          myTransaction.commit()
            .then(function (recordset) {
               //console.dir('Record has been inserted successfully!');
               res.send({data: 'Record has been inserted successfully!'});
             })
            .catch(function (err) {
               //console.dir('Error in transaction commit ' + err);
               res.send({data: 'Error in transaction commit ' + err.originalError.info.message});
             });
        }
      });
    });
})


// call by default index.html page
app.get("*", function(req,res){
  res.sendFile(srcpath +'/index.html');
})
  
// server start on given port
app.listen(port, function(){
  console.log("Server started on port " + port);
})  
