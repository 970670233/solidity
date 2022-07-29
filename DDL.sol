//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract DDL{
    struct People{
        string text;
        bool istrue;
    }
    People[] public peoples;
    function insert(string memory _text) external{
            peoples.push(People({
                text:_text,
                istrue:false
            }));
    }
    function update(uint _index,string memory _text) external DDLfunction(_index){
        peoples[_index].text=_text;
    }
    function get(uint _index) external DDLfunction(_index) view returns(string memory,bool){
            People memory temp=peoples[_index];
            return (temp.text,temp.istrue);
    }
    function deleteByindex(uint _index) external DDLfunction(_index){
            peoples[_index]=peoples[peoples.length-1];
            peoples.pop();
    }
    modifier DDLfunction(uint _index){
        require(_index<peoples.length,"error");
        _;
    }
}