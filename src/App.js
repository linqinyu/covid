import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
 
import { About, Api, Data, Contact, Insights, Home, Map, Methodology, Time, Choropleth, Hotspots, Trends, Faq } from './components/';
 
class App extends Component {

  render() {
    return (     
       <Router basename={process.env.PUBLIC_URL}>
        <div>
            <Switch>
             <Route path="/" component={Home} exact/>
             <Route path="/map" component={Map}/>
             <Route path="/map.html" component={Map}/>
             <Route path="/about" component={About}/>
             <Route path="/about.html" component={About}/>
             <Route path="/contact" component={Contact}/>
             <Route path="/contact.html" component={Contact}/>
             <Route path="/insights" component={Insights}/>
             <Route path="/api" component={Api}/>
             <Route path="/api.html" component={Api}/>
             <Route path="/data" component={Data}/>
             <Route path="/data.html" component={Data}/>
             <Route path="/methods" component={Methodology}/>
             <Route path="/methods.html" component={Methodology}/>
             <Route path="/time" component={Time}/>
             <Route path="/time.html" component={Time}/>
             <Route path="/choropleth" component={Choropleth}/>
             <Route path="/choropleth.html" component={Choropleth}/>
             <Route path="/hotspot" component={Hotspots}/>
             <Route path="/hotspot.html" component={Hotspots}/>
             <Route path="/trends" component={Trends}/>
             <Route path="/trends.html" component={Trends}/>
             <Route path="/faq" component={Faq}/>
             <Route path="/faq.html" component={Faq}/>
            <Route />
           </Switch>
        </div> 
      </Router>
    );
  }
}

export default App