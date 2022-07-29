//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
//签名验证
//"\x19Ethereum Message :\n32"
contract VerifySig{

    function verify(address _singer,string memory _message,bytes memory _sig)external pure returns(bool){
            bytes32 messageHash=getMessageHash(_message);
            bytes32 ethMessageHash=getEthMessageHash(messageHash);
            return recove(ethMessageHash,_sig)==_singer;
    }
    function getMessageHash(string memory _message) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_message));
    }
    function getEthMessageHash(bytes32 messageHash) public pure returns(bytes32){
        //本次哈希是在链下完成的所以要增加一个签名
        //为啥要进行两次哈希又可能是因为一次会被破解
         return keccak256(abi.encodePacked(
             "\x19Ethereum Message :\n32",
             messageHash));
    }
    //恢复函数
    function recove(bytes32 ethMessageHash,bytes memory _sig) public pure returns(address){
            (bytes32 r,bytes32 s,uint8 v)=_split(_sig);
            //solidity 提供的一个恢复函数
           return  ecrecover(ethMessageHash,v,r,s);
    }
    function _split(bytes memory _sig) internal pure returns(bytes32 r,bytes32 s,uint8 v){
        require(_sig.length==65,"error");
        //内联汇编
        assembly{
            r :=mload(add(_sig,32))
            s :=mload(add(_sig,64))
            v :=byte(0,mload(add(_sig,96)))
        }
    }
}