import React from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { setGeoid, storeData } from './actions';
import * as d3 from 'd3-dsv';
import * as _ from 'lodash';

async function getParseCSV(url){
  const tempData = await fetch(url).then(function(response) {
    return response.ok ? response.text() : Promise.reject(response.status);
    }).then(function(text) {
      return d3.csvParse(text, d3.autoType);
  });
  console.log(Date.now());
  console.log('got csv');
  return tempData;
}

async function getJson(url){
  const tempData = await fetch(url)
    .then(response => response.json())
    .then(data => {return data});
    
  console.log('got json');
  console.log(Date.now());
  return tempData;
}

function mergeData(featureCollection, featureCollectionJoinCol, joinData, joinDataNames, joinDataCol) {
  console.log(Date.now());
  console.log('started merging');
  // declare parent dictionaries
  let features = {}
  let dataDicts = {}

  // declare and prep feature collection object
  let i = featureCollection.features.length;
  let colNumCheck = parseInt(featureCollection.features[0].properties[featureCollectionJoinCol])
  if (Number.isInteger(colNumCheck)) {
    while (i>0) {
      i--;
      features[parseInt(featureCollection.features[i].properties[featureCollectionJoinCol])] = featureCollection.features[i];
    }
  } else {
    while (i>0) {
      i--;
      features[featureCollection.features[i].properties[featureCollectionJoinCol]] = featureCollection.features[i];
    }
  }

  // declare data objects
  for (let n=0; n < joinDataNames.length; n++) {
    dataDicts[`${joinDataNames[n]}`] = {}
  }

  // loop through data and add to dictionaries
  i = joinData[0].length;
  while (i>0) {
    i--;
    for (let n=0; n<joinData.length; n++) {
      dataDicts[joinDataNames[n]][joinData[n][i][joinDataCol]] = {[`${joinDataNames[n]}`]: joinData[n][i]}
    }
  }

  // use lodash to merge data
  let merged = _.merge(features, dataDicts[joinDataNames[0]])
  for (let n=1; n < joinDataNames.length; n++){
    merged = _.merge(merged, dataDicts[joinDataNames[n]])
  }
  return merged;
}

function App() {

  const geoid = useSelector(state => state.currentGeoid);
  const storedData = useSelector(state => state.storedData);
  const dispatch = useDispatch();
  
  async function loadData(geojson, csvs, joinCols, names) {
    console.log(Date.now())
    const csvPromises = csvs.map(csv => getParseCSV(`${process.env.PUBLIC_URL}/csv/${csv}.csv`).then(result => {return result}))

    Promise.all([
      getJson(`${process.env.PUBLIC_URL}/geojson/${geojson}.geojson`),
      ...csvPromises
    ]).then(values => {
        dispatch(storeData(mergeData(values[0], joinCols[0], values.slice(1,), names, joinCols[1]), geojson));
        console.log(Date.now());
      }
    )
  }

  var test = () => {
    try {
      return storedData['county_usfacts'][1001]['type']
    } catch {
      return 'no data'
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        Hello. The GEOID is {geoid}<br/>
        Stored data = {test()}<br/>
        <button onClick={() => loadData('county_usfacts', ['covid_confirmed_usafacts','covid_deaths_usafacts'], ['GEOID', 'countyFIPS'], ['cases','deaths'])}>load data</button>
      </header>
    </div>
  );
}

export default App;
