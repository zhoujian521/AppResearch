import { NativeModules, Platform} from 'react-native'; 
const gethModule = NativeModules.GethModule;

/**
 * 初始化客户端
 *
 * @param {*} {rawurl=''} 以太坊[geth和parity]节点
 */
function init({rawurl=''}){
    gethModule.init(rawurl);
}

/**
 * 账户余额
 *
 * @param {*} {context='', account='', number=''}
 */
async function getBalance({context='', account='', number=''}){
    try {
        const datas = await gethModule.getBalance(context, account, number);
        console.log('==============getBalance======================');
        console.log(datas);
    } catch (error) {
        console.log('===============getBalance=====================');
        console.log(error);        
    }
    
}

async function newWallet(){
    try {
        const datas = await gethModule.newWallet();
        console.log('==============newWallet======================');
        console.log(datas);
    } catch (error) {
        console.log('===============newWallet=====================');
        console.log(error);        
    }
    ;
}




































function findEvents(){
    gethModule.findEvents((error, events) => {
        if (error) {
          console.error(error);
        } else {
          console.log('====================================');
          console.log(events);
          console.log('====================================');
        }
      });
}

function doSomethingExpensive(){
    const param = '121212121212';
    gethModule.doSomethingExpensive(param ,(error, events) => {
        console.log('============doSomethingExpensive========================');

        if (error) {
          console.error(error);
        } else {
          console.log('====================================');
          console.log(events);
          console.log('====================================');
        }
      });
}



export default {
    init,
    getBalance,
    newWallet,

    findEvents,
    doSomethingExpensive
};