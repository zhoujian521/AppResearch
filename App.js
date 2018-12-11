/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {StyleSheet, View, Text, TouchableOpacity} from 'react-native';
import GethModel from './utils/geth-utils';

export default class App extends Component {

  _addEvent =()=>{
    GethModel.addEvent();
  }

  _findEvents =()=>{
    GethModel.findEvents();
  }

  _findEventsPromise =()=>{
    GethModel.findEventsPromise();
  }

  _doSomethingExpensive =()=>{
    GethModel.doSomethingExpensive();
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={()=>this._addEvent()}>
          <View style={[styles.button, {marginTop: 80}]}>
            <Text>addEvent</Text>
          </View>
        </TouchableOpacity>
        <TouchableOpacity onPress={()=>this._findEvents()}>
          <View style={styles.button}>
            <Text>findEvents</Text>
          </View>
        </TouchableOpacity>
        <TouchableOpacity onPress={()=>this._findEventsPromise()}>
          <View style={styles.button}>
            <Text>findEventsPromise</Text>
          </View>
        </TouchableOpacity>
        <TouchableOpacity onPress={()=>this._doSomethingExpensive()}>
          <View style={styles.button}>
            <Text>doSomethingExpensive</Text>
          </View>
        </TouchableOpacity>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  button:{
    width: 200,
    height: 50, 
    marginTop: 10,
    backgroundColor: 'cyan'
  }
});
