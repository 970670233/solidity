//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
contract arrayRomve{
    uint[] public arr;
    uint public myfavoutiterNumber;
    //删除数组元素
    //【1，2，3】=>remove(1)=>[1,3]
    function remove(uint index) public{
        require(index<arr.length,"error");
        for(uint i=index;i<arr.length-1 ;i++){
            arr[i]=arr[i+1]; 
        }
        arr.pop();
    } 
    function test() public{
        arr=[1,2,3];
        remove(1);
        assert(arr[0]==1);
        assert(arr[1]==3);
        assert(arr.length==2);
    }
    function deleteArray(uint _index) public arrayFunction(_index){
        arr[_index]=arr[arr.length-1];
        arr.pop;
    }
    modifier arrayFunction(uint _index){
        require(_index<arr.length,"error");
        _;
    }
    function test01() public  returns(uint[] memory){
        arr=[1,2,3,4];
        deleteArray(1);
        arr.pop();
        return arr;
    }
    function getArray() public view returns(uint[] memory){
            return arr;
    }
} 