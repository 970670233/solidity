//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;



//工厂合约
//使用合约来创建合约第二种方式

contract Account{
    uint public value;
    address public onwer;
    constructor(address _onwer) payable{
        value=msg.value;
        onwer=_onwer ;
    }
}
contract AccountFactory{
    Account[] public  accounts;

    function deploy(address _onwer) external payable{
        //使用new 关键字来创建合约
        Account account=new Account{value:msg.value}(_onwer);
        accounts.push(account);
    }
}