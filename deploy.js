const ethers=require("ethers");
const fs=require("fs-extra"); 
//async关键字异步操作
async function main(){
    //脚本连接到区块链
    const provider=new ethers.providers.JsonRpcProvider("http://127.0.0.1:7545");
    //配置钱包参数可以是私钥
    const wallet=new ethers.Wallet("798aa804111e8c77ce8d6377845e05d25e4157c0ccbdcf25df9c80630f87521b",
    provider);
    // abi
    const abi=fs.readFileSync("./SimpleStorage_sol_fallbackSolidity.abi","utf8");
    //binary  编译后的文件类似于java的.class
    const binary=fs.readFileSync("./SimpleStorage_sol_fallbackSolidity.bin","utf8");
    //配置contract  需要参数abi，binary，wallet等参数
    const constractFactory=new ethers.ContractFactory(abi,binary,wallet);
    console.log("合约正在部署请稍等。。。。");
    // //这里的await关键字是和async关键字配合使用
    //含义就是在这稍等一下等合约部署
    //在这可以设置gas消耗
    const contract= await constractFactory.deploy({gasPrice:1000000000});
    // //等待区块确认
    await contract.deployTransaction.wait(1);
    //调用合约中的方法
    const number=await contract.getNumber();
    console.log(`最喜欢的数字为:${number.toString()}`);
    const Response=await contract.store("7");
    const updateResponse=await Response.wait(1);
    const updateNumber=await contract.getNumber();
    console.log(`update:${updateNumber.toString()}`);
    
    // const nonce=await wallet.getTransactionCount();
    // const xt={
    //     nonce:nonce,
    //     gasPrice:20000000000,
    //     gasLimit:1000000,
    //     to:null,
    //     value:0,
    //     data:"0x608060405234801561001057600080fd5b5060c98061001f6000396000f3fe608060405260043610601f5760003560e01c80636537214714603757602d565b36602d576001600081905550005b6002600081905550005b348015604257600080fd5b506049605d565b604051605491906070565b60405180910390f35b60005481565b606a816089565b82525050565b6000602082019050608360008301846063565b92915050565b600081905091905056fea26469706673582212201187e993f8a58c951ed02b2a94a82c31c8364be426292974f663bcad6a79eca564736f6c63430008070033",
    //     chainId:  1337
    // };
    // //发送以太也可以说是发起交易
    // const sendTxResponse=await wallet.sendTransaction(xt);
    // await sendTxResponse.wait(1);
    // console.log(sendTxResponse);
     
}
main();