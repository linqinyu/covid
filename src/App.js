import React, { Component } from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
 
import { Home, Map, About, Contact } from './components/';
 
class App extends Component {

  render() {
    return (     
       <BrowserRouter>
        <div>
            <Switch>
             <Route path="/" component={Home} exact/>
             <Route path="/map" component={Map}/>
             <Route path="/about" component={About}/>
             <Route path="/contact" component={Contact}/>
            <Route />
           </Switch>
        </div> 
      </BrowserRouter>
    );
  }
}

export default App