//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

//委托调用 关键字delegatecall
//不会改变调用合约里变量的值
//只会改变自己合约里的值
//委托调用合约的属性必须和调用合约里的属性一致

//调用合约
contract testCall{
    uint public number;
    address public onwer;
    uint public value;

    function getSet(uint _number) public payable{
        number=_number;
        onwer=msg.sender;
        value=msg.value;
    }
}


//委托合约
contract delegateCallTest{
    uint public number;
    address public onwer;
    uint public value;
    function setValue(address _test,uint _number) external payable{
        (bool success,)=_test.delegatecall(abi.encodeWithSignature("getSet(uint256)",_number));
        require(success,"error");
    }
}