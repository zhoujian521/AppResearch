import { NativeModules, Platform} from 'react-native'; 
const gethModule = NativeModules.GethModule;

function addEvent(){
    gethModule.addEvent("Birthday Party", "4 Privet Drive, Surrey");
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

async function findEventsPromise(){
    console.log('=============findEventsPromise=======================');
    try {
        const datas = await gethModule.findEventsPromise();
        console.log('==============datas======================');
        console.log(datas);
        console.log('==============datas======================');
    } catch (error) {
        console.log('===============error=====================');
        console.log(error);
        console.log('===============error=====================');
        
    }
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
    addEvent,
    findEvents,
    findEventsPromise,
    doSomethingExpensive
};