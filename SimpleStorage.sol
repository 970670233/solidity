//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
contract fallbackSolidity{
    
    uint256 public result;

    //回退函数用于接受ETH
    //声明必须是external payable
    //触发条件当合约接受ETH时被触发
    //当接收的ETH msg.data不存在时触发
    receive() external payable{
        result=1;
    }
    //与上类似
    //不同的是当我们调用一个不存在的函数时被触发
    //接收ETH msg.data不为空或者receive函数不存在时触发
    fallback() external payable{
        result=2;
    }
    function getNumber() public view returns(uint256){
        return result;
    }
    function store(uint256 number) public{
        result=number;
    } 
}