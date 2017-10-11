
var ProdTypes = React.createClass({

  getInitialState: function () {
    return {type_id: '', type_name: '', data2: []};
  },

  componentDidMount() {
   
    $.ajax({
        url: "api/getprodtypes",
        type: "GET",
        dataType: 'json',
        ContentType: 'application/json',
        success: function(data) {
	  this.setState({data2: data.recordset});
          }.bind(this),
        error: function(jqXHR) {
          console.log(jqXHR);
          }.bind(this)
    });
  },  

  render: function() {
    var sel = this.props.selected;
    //console.log('sel = ' + sel);
    return <select onChange={this.props.onChange}> {
      this.state.data2.map(function(item, index){
        if (item.type_id == sel)
	  return <option selected key={index} value={item.type_id}>{item.type_name}</option>;
        else
	  return <option key={index} value={item.type_id}>{item.type_name}</option>;
      })
    }</select>;
  }
});

//ReactDOM.render(<ProdTypes/>, document.getElementById('root'))

var Stores = React.createClass({
  
  getInitialState: function () {
    return {stor_name: '', stor_city: '', stor_id: '', Buttontxt: 'Save', data1: []};
  },

  handleChange: function(e) {
    this.setState({[e.target.name]: e.target.value});
  },
  
  componentDidMount() {
   
    $.ajax({
        url: "api/getstores",
        type: "GET",
        dataType: 'json',
        ContentType: 'application/json',
        success: function(data) {
	  this.setState({data1: data.recordset});
          }.bind(this),
        error: function(jqXHR) {
          console.log(jqXHR);
          }.bind(this)
    });
  },  
    
  DeleteData(id) {
    var StoreDelete = {'stor_id': id};

    $.ajax({
        url: "/api/delstore/",
        dataType: 'json',
        type: 'POST',
        data: StoreDelete,
        success: function(data) {
            alert(data.data);  
            this.componentDidMount();  
        }.bind(this),
        error: function(xhr, status, err) {
            alert(err);   
        }.bind(this),
    });
  },  
  

  EditData(item) {
    this.setState({stor_name: item.stor_name, stor_city: item.stor_city, stor_id: item.stor_id, Buttontxt:'Update'});
  },
  
  handleClick: function() {
   
    var Url = "";

    if (this.state.Buttontxt == "Save") {
      Url = "/api/insstore";
    }  
    else {
      Url = "/api/updstore";
    }

    var StoreData = {
      'stor_id': this.state.stor_id,
      'stor_name': this.state.stor_name,
      'stor_city': this.state.stor_city
    }  

    $.ajax({
        url: Url,
        dataType: 'json',
        type: 'POST',
        data: StoreData,
        success: function(data) {
            alert(data.data);
            this.setState(this.getInitialState());
            this.componentDidMount();
        }.bind(this),
        error: function(xhr, status, err) {
            alert(err);
        }.bind(this)
    });
  },
  
  render: function() {
    return (
<div className="container" style={{marginTop:'50px'}}>
  <p className="text-center" style={{fontSize:'25px'}}><b>Manage stores</b></p>
  <form>  
    <div className="col-sm-12 col-md-12" style={{marginLeft:'400px'}} >
      <table className="table-bordered">
        <tbody>
          <tr>
            <td><b>Store Name</b></td>
            <td>
              <input className="form-control" type="text" value={this.state.stor_name} name="stor_name" onChange={this.handleChange} />
              <input type="hidden" value={this.state.stor_id} name="stor_id" />
            </td>
          </tr>
          <tr>
            <td><b>Store City</b></td>
            <td>
              <input type="text" className="form-control" value={this.state.stor_city} name="stor_city" onChange={this.handleChange} />
            </td>
          </tr>
          <tr>
            <td></td>
            <td>
              <input className="btn btn-primary" type="button" value={this.state.Buttontxt} onClick={this.handleClick} />
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  
    <div className="col-sm-12 col-md-12" style={{marginTop:'50px',marginLeft:'300px'}} >
   
      <table className="table-bordered">
        <tbody>
          <tr>
            <th><b>ID</b></th>
            <th><b>Store Name</b></th>
            <th><b>Store City</b></th>
            <th><b>Edit</b></th>
            <th><b>Delete</b></th>
          </tr>  
          {this.state.data1.map((item, index) => (  
             <tr key={index}>  
               <td>{item.stor_id}</td>   
               <td>{item.stor_name}</td>                        
               <td>{item.stor_city}</td>  
               <td>   
                 <button type="button" className="btn btn-success" onClick={(e) => {this.EditData(item)}}>Edit</button>
               </td>
               <td>
                 <button type="button" className="btn btn-info" onClick={(e) => {this.DeleteData(item.stor_id)}}>Delete</button>
               </td>
             </tr>
          ))}
        </tbody>
      </table>
    </div>
  </form>
</div>
);  
}  
});
  
//ReactDOM.render(<Stores/>, document.getElementById('root'))



var Products = React.createClass({
  
  getInitialState: function () {
    return {prod_name: '', prod_type: '', type_name: '', prod_id: '', Buttontxt: 'Save', data1: []};
  },

  handleChange: function(e) {
    this.setState({[e.target.name]: e.target.value});
  },
  
  componentDidMount() {
   
    $.ajax({
        url: "api/getproducts",
        type: "GET",
        dataType: 'json',
        ContentType: 'application/json',
        success: function(data) {
            this.setState({data1: data.recordset});
          }.bind(this),
        error: function(jqXHR) {
          console.log(jqXHR);
          }.bind(this)
    });
  },  
    
  DeleteData(id) {
    var ProductDelete = {'prod_id': id};

    $.ajax({
        url: "/api/delproduct/",
        dataType: 'json',
        type: 'POST',
        data: ProductDelete,
        success: function(data) {
            alert(data.data);  
            this.componentDidMount();  
        }.bind(this),
        error: function(xhr, status, err) {
            alert(err);   
        }.bind(this),
    });
  },  
  

  EditData(item) {
    this.setState({prod_name: item.prod_name, prod_type: item.prod_type, type_name: item.type_name, prod_id: item.prod_id, Buttontxt:'Update', selectValue: item.prod_type});
  },
  
  handleClick: function() {
   
    var Url = "";

    if (this.state.Buttontxt == "Save") {
      Url = "/api/insproduct";
    }  
    else {
      Url = "/api/updproduct";
    }

    var ProductData = {
      'prod_id': this.state.prod_id,
      'prod_name': this.state.prod_name,
      'prod_type': this.state.selectValue
    }  

    $.ajax({
        url: Url,
        dataType: 'json',
        type: 'POST',
        data: ProductData,
        success: function(data) {
            alert(data.data);
            this.setState(this.getInitialState());
            this.componentDidMount();
        }.bind(this),
        error: function(xhr, status, err) {
            alert(err);
        }.bind(this)
    });
  },
  
  selected (ev) {
    //console.log({selectValue:ev.target.value});
    this.setState({selectValue:ev.target.value});
  },

  SetProdType(item) {
    var self = this;
    return (<ProdTypes selected={item} onChange={self.selected} />);
  },
  
  render: function() {
    return (
<div className="container" style={{marginTop:'50px'}}>
  <p className="text-center" style={{fontSize:'25px'}}><b>Manage products</b></p>
  <form>  
    <div className="col-sm-12 col-md-12" style={{marginLeft:'400px'}} >
      <table className="table-bordered">
        <tbody>
          <tr>
            <td><b>Product Name</b></td>
            <td>
              <input className="form-control" type="text" value={this.state.prod_name} name="prod_name" onChange={this.handleChange} />
              <input type="hidden" value={this.state.prod_id} name="prod_id" />
            </td>
          </tr>
          <tr>
            <td><b>Product type</b></td>
            <td>
	      {this.SetProdType(this.state.prod_type)}
            </td>
          </tr>
          <tr>
            <td></td>
            <td>
              <input className="btn btn-primary" type="button" value={this.state.Buttontxt} onClick={this.handleClick} />
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  
    <div className="col-sm-12 col-md-12" style={{marginTop:'50px',marginLeft:'300px'}} >
   
      <table className="table-bordered">
        <tbody>
          <tr>
            <th><b>ID</b></th>
            <th><b>Product name</b></th>
            <th style={{display:'none'}}><b>Product type</b></th>
            <th><b>Product type</b></th>
            <th><b>Edit</b></th>
            <th><b>Delete</b></th>
          </tr>  
          {this.state.data1.map((item, index) => (  
             <tr key={index}>  
               <td>{item.prod_id}</td>   
               <td>{item.prod_name}</td>                        
               <td style={{display:'none'}}>{item.prod_type}</td>                        
               <td>{item.type_name}</td>  
               <td>   
                 <button type="button" className="btn btn-success" onClick={(e) => {this.EditData(item)}}>Edit</button>
               </td>
               <td>
                 <button type="button" className="btn btn-info" onClick={(e) => {this.DeleteData(item.prod_id)}}>Delete</button>
               </td>
             </tr>
          ))}
        </tbody>
      </table>
    </div>
  </form>
</div>
);  
}  
});
  
//ReactDOM.render(<Products/>, document.getElementById('root'))


var MainMenu = React.createClass({

    getInitialState: function(){
        return { focused: 3 };
    },

    clicked: function(index){

        // The click handler will update the state with
        // the index of the focused menu entry

        this.setState({focused: index});
    },

    ShowPage: function(item){
      if (item == 'Manage Stores')
        return <Stores />;
      else if (item == 'Manage Products')
        return <Products />;
      else if (item == 'Manage Prices')
        return <div><h4>Sorry, this page hasn't been done yet.</h4><br></br>
	    <p><b>And please notice that I'm a complete novice to React and Node, so it took 95% of time doing UI and Node API and the rest of time - doing database scheme :)<br></br></b></p>
            <br></br>
            <p><b>And the main idea how to create functionality for this page is:<br></br>
            1. Create form with inplace editing of fields for Store, Product and Price and use API to call stored procedure sp_get_prices to get data from database.<br></br>
            2. Mark edited rows with hidden value by next principle: -1 - deleted row (and hide it), 0 - edited row, 1 - inserted row.<br></br>
            3. On submit use API to call stored procedure sp_prices_upd using Table-Valued Parameter based oh changed rows and merge statement inside procedure to update the data.<br></br>
               Maybe it could be useful to use streams of node package mssql for faster data transfer, but I'm not very familiar with it so I'm not sure :)<br></br>
          </b></p></div>;
      else if (item == 'About')
        return <div><h4>This is simple test CRUD application. Use Menu to navigate between pages</h4></div>;
    },

    render: function() {

        // Here we will read the items property, which was passed
        // as an attribute when the component was created

        var self = this;

        // The map method will loop over the array of menu entries,
        // and will return a new array with <li> elements.

        return (
            <div>
                <ul>{ this.props.items.map(function(m, index){
        
                    var style = '';
        
                    if(self.state.focused == index){
                        style = 'focused';
                    }
        
                    // Notice the use of the bind() method. It makes the
                    // index available to the clicked function:
        
                    //console.log(self.props.items[self.state.focused]);
	 	    return <li className={style} onClick={self.clicked.bind(self, index)}>{m}</li>;
        
                }) }
                        
                </ul>
      		<div>
		  {this.ShowPage(self.props.items[self.state.focused])}
      		</div>
            </div>
        );
    }
});

// Render Main Menu

ReactDOM.render(
  <MainMenu items={ ['Manage Stores', 'Manage Products', 'Manage Prices', 'About'] } />,
  document.getElementById('root')
);
