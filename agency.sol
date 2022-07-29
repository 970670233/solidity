//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

//使用合约来部署合约

//测试合约一
contract Test01Contract{
    address public onwer=msg.sender;

    function setOnwer(address _address) public {
        require(msg.sender==onwer,"error");
        onwer = _address;
    }
}
//测试合约二
contract Test02Contract{
    address public onwer=msg.sender;
    uint public value=msg.value;
    uint public x;
    uint public y;
    constructor(uint _x,uint _y) payable{
                x=_x;
                y=_y;
    }
}
//代理合约及配置合约完成动态代理合约实现一个合约部署多个合约
contract Proxy{
    event Deploy(address);

    //隐藏式返回
    function deploy(bytes memory _code) external payable returns(address addr){
        //内敛汇编
        assembly{
            //1.callvalue用来替代msg.data表示这次合约所要发送的ether
            //2.机器码开始的位置也就是合约部署的data
            //3.机器码的大小
             addr :=create(callvalue(),add(_code, 0x20),mload(_code))
        }
        //防止部署失败
        require(addr!=address(0),"deploy error");
        //触发事件
        emit Deploy(addr);
    }
    function execute(address _target,bytes memory _data) external payable{
        (bool success,) =_target.call{value:msg.value}(_data);
        require(success,"error");
    }
    //防止失败时接受ether
    fallback() external payable{}
}
//帮助合约用于获取部分参数
contract Helper{
    //获取第一个测试合约的code，机器码
    function getTest01Code() external pure returns(bytes memory bytecode){
           bytecode=type(Test01Contract).creationCode;
            //create
    }
    //第二个合约拥有构造方法所以我们使用打包的形式将参数放到机器码的最末尾
     function getTest02Code(uint _x,uint _y) external pure returns(bytes memory){
           bytes memory bytecode=type(Test02Contract).creationCode;
            return abi.encodePacked(bytecode,abi.encode(_x,_y));
    }
    function getCalldata(address _onwer) external pure returns(bytes memory){
            return abi.encodeWithSignature("setOnwer(address)",_onwer);
    }   
}
