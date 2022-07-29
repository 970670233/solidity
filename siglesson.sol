//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
//签名复习 "\x19Ethereum Message :\n32"
contract sign{
     
     function vailedSign(address _sign,string memory _message,bytes memory _sig) external pure returns(bool){
         //1使用哈希将签名转化为bytes32
         bytes32 messageHash=getMessageHash(_message);
         //将第一次生成的哈希再进行一次哈希
         bytes32 ethMessageHash=getEthMessageHash(messageHash);
         //恢复函数
         return recove(ethMessageHash,_sig)==_sign;
     }
     function getMessageHash(string memory _message) public pure returns(bytes32){
         return keccak256(abi.encodePacked(_message));

     }
     function getEthMessageHash(bytes32 _message) public  pure returns(bytes32){
         //这里注意因为第二次是要在链下进行的所以需要一个string
         return keccak256(abi.encodePacked(
             "\x19Ethereum Message :\n32",
                _message
         ));
     }
     function recove(bytes32 _message,bytes memory _sig) public  pure returns(address){
         (bytes32 r,bytes32 s, uint8 v)=_split(_sig);
         return ecrecover(_message,v,r,s);
     }
     function _split(bytes memory _sig) internal pure returns(bytes32 r,bytes32 s,uint8 v){
            //内部汇编
            //r,s,v
            assembly{
                r :=mload(add(_sig,32))
                s :=mload(add(_sig,64))
                v :=byte(0,mload(add(_sig,96)))
            }
     }
}