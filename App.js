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


  _etherscanGetBalance= async ()=>{
    const apiKey = 'RCDFTNQSB3PW6FMAS4HVQCTD9EYQ1TPMTS';
    const api = require('etherscan-api').init(apiKey,'rinkeby', 1000);
    const balance = await api.account.txlist('0x38bCc5B8b793F544d86a94bd2AE94196567b865c');
    const params = {
      address:'0x38bCc5B8b793F544d86a94bd2AE94196567b865c',
      startblock:0,
      endblock:999999999,
      page:1,
      offset:20,
      sort:'desc'
    };
    const {address, startblock, endblock, page,  offset, sort} = params;
    const txlist = await api.account.txlist(address, startblock, endblock, page, offset, sort);
    console.log('============txlist========================');
    console.log(txlist);
    console.log('============txlist========================');


  }

  render() {
    const iOSGeth = <View>
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

    return (
      <View style={styles.container}>
        {iOSGeth}
        <TouchableOpacity onPress={()=>this._etherscanGetBalance()}>
          <View style={styles.button}>
            <Text>Etherscan=>GetBalance</Text>
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
