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
  
  _init =()=>{
    const rawurl = 'https://mainnet.infura.io';
    GethModel.init({rawurl});
  }

  // 0x71c7656ec7ab88b098defb751b7401b5f6d8976f
  // 0xb5538753F2641A83409D2786790b42aC857C5340
  _getBalance =()=>{
    const params = { account:'0x71c7656ec7ab88b098defb751b7401b5f6d8976f' };
    GethModel.getBalance(params);
  }

  _newWallet =()=>{
    GethModel.newWallet();
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={()=>this._init()}>
          <View style={[styles.button, {marginTop: 80}]}>
            <Text>init 【https://mainnet.infura.io】</Text>
          </View>
        </TouchableOpacity>
        <TouchableOpacity onPress={()=>this._getBalance()}>
          <View style={styles.button}>
            <Text>getBalance</Text>
          </View>
        </TouchableOpacity>
        
        <TouchableOpacity onPress={()=>this._newWallet()}>
          <View style={styles.button}>
            <Text>newAccount</Text>
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


  _doSomethingExpensive =()=>{
    GethModel.doSomethingExpensive();
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
