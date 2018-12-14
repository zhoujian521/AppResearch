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
import ZJWebView from './nativeComponent/ZJWebView';
import WebViewBridge from 'react-native-webview-bridge';



export default class App extends Component {

  componentDidMount=()=>{
    const { webviewbridge, zjWebView } = this.refs;
  }
  
  _init =()=>{
    const rawurl = 'ws://rinkeby03.milewan.com:8546';
    GethModel.init({rawurl});
  }

  _generateWallet =()=>{
    GethModel.generateWallet();
  }

  _createKeyStore =()=>{
    GethModel.createKeyStore();
  }

  _importKeyStore =()=>{
    GethModel.importKeyStore();
  }

  _transferEth =()=>{
    GethModel.transferEth();
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

  onBridgeMessage=(message)=>{
    const { webviewbridge } = this.refs;
    switch (message) {
      case "hello from webview":
        webviewbridge.sendToBridge("hello from react-native");
        break;
      case "got the message inside webview":
        console.log("we have got a message from webview! yeah");
        break;
      default:
        console.log('============message========================');
        console.log(message);
        console.log('============message========================');
        break;
        
    }
  }

  render() {
    // const iOSGeth = <View>
    //     <TouchableOpacity onPress={()=>this._init()}>
    //       <Text style={[styles.button, {marginTop: 80}]}>init 【https://mainnet.infura.io】</Text>
    //     </TouchableOpacity>
    //     <TouchableOpacity onPress={()=>this._getBalance()}>
    //       <Text style={styles.button}>getBalance</Text>
    //     </TouchableOpacity>

    //     <TouchableOpacity onPress={()=>this._generateWallet()}>
    //       <Text style={styles.button}>generateWallet</Text>
    //     </TouchableOpacity>
    //     <TouchableOpacity onPress={()=>this._createKeyStore()}>
    //       <Text style={styles.button}>createKeyStore</Text>
    //     </TouchableOpacity>
    //     <TouchableOpacity onPress={()=>this._importKeyStore()}>
    //       <Text style={styles.button}>importKeyStore</Text>
    //     </TouchableOpacity>
    //     <TouchableOpacity onPress={()=>this._transferEth()}>
    //       <Text style={styles.button}>transferEth</Text>
    //     </TouchableOpacity>


        
    //     <TouchableOpacity onPress={()=>this._newWallet()}>
    //       <Text style={styles.button}>newAccount</Text>
    //     </TouchableOpacity>
    //     <TouchableOpacity onPress={()=>this._doSomethingExpensive()}>
    //       <Text style={styles.button}>doSomethingExpensive</Text>
    //     </TouchableOpacity>
    // </View>


    // const etherscan = <View> 
    //   <TouchableOpacity onPress={()=>this._etherscanGetBalance()}>
    //     <View style={styles.button}>
    //       <Text>Etherscan=>GetBalance</Text>
    //     </View>
    //   </TouchableOpacity>
    // </View>
    
    const injectScript = 
    `(function () {
            if (WebViewBridge) {
              WebViewBridge.onMessage = function (message) {
                if (message === "hello from react-native") {
                  WebViewBridge.send("got the message inside webview");
                }
              };
              webviewbridge.send("Android shouldOverrideUrlLoading");
              WebViewBridge.send("hello from webview");
            }
      }());`;


      // <WebViewBridge style={{ backgroundColor:'red', flex: 1 }}
      //   ref="webviewbridge"
      //   source={{uri: "https://google.com"}}
      //   injectedJavaScript={injectScript}
      //   onBridgeMessage={this.onBridgeMessage.bind(this)}
      //   onMessage={this.onBridgeMessage.bind(this)}/> 

      const webView = <ZJWebView 
        ref="zjWebView"
        style={{ backgroundColor:'cyan', flex: 1}} 
        source={{uri: 'https://google.com'}}/>

    return (
      <View style={{ backgroundColor:'', flex: 1 }}>
        {webView}
      </View>
    );
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

// {iOSGeth}
// {etherscan}