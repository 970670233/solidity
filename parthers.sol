//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
library arrayMath{
    function search(address[] storage _address,address _addr) internal view returns(uint)
    {
        for(uint i;i<_address.length;i++){
            if(_address[i]==_addr){
                return i;
            }
        }
    }
    function remove(address[] storage _address,uint _index) internal{
        _address[_index]=_address[_address.length-1];
        _address.pop();
    }
}

contract Wallet{
    using arrayMath for address[];
    event PartNets(address indexed _address,uint indexed _index);
    address[] public onwers;
    mapping(address=>bool) public isExist;
    mapping(uint=>mapping(address=>bool)) public depoved;
    mapping(address=>uint) public funder;
    uint public required;
    
    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool isSuccess;
    }
    Transaction[] public transactions;

    constructor(address[] memory _address,uint _value){
        require(_value>0&&_value<_address.length,"error");
        require(_address.length>0,"error");
        for(uint i;i<_address.length;i++){
            address temp=_address[i];
            require(temp!=address(0),"error");
            require(!isExist[temp],"error");
            isExist[temp]=true;
            onwers.push(temp);
    }
            required=_value;
    }

    function funderMe() public onlyOnwer payable{
            funder[msg.sender]+=msg.value;
    }
    modifier onlyOnwer(){
        require(isExist[msg.sender],"error");
        _;
    }

    modifier isExists(uint _id){
        require(_id<transactions.length,"error");
        _;
    }

    modifier onwerByagent(uint _id){
        require(!depoved[_id][msg.sender]);
        _;
    }
    modifier tranIsTrue(uint _id){
        require(!transactions[_id].isSuccess,"error");
        _;
    }

    function  addTrans(address _to,uint _value,bytes calldata _data) external onlyOnwer{
            transactions.push(Transaction({
                to:_to,
                value:_value,
                data:_data,
                isSuccess:false
            }));
    }                                                                                       
    function agentByonwer(uint _id) external onlyOnwer isExists(_id) onwerByagent(_id) tranIsTrue(_id)
    {
        depoved[_id][msg.sender]=true;
    } 

    function getCount(uint _id) private view returns(uint count)
    {   
        for(uint i;i<onwers.length;i++){
            if(depoved[_id][onwers[i]]){
                count+=1;
            }
        }    
    }

    function send(uint _id) external isExists(_id) tranIsTrue(_id)
    {
        uint count =getCount(_id);
        require(count<required,"error");
        Transaction storage temp=transactions[_id];
        temp.isSuccess=true;
        (bool success,)=temp.to.call{value:temp.value}(temp.data);
        require(success,"error");
    }

    function back(uint _id) external onlyOnwer isExists(_id) tranIsTrue(_id){
                require(depoved[_id][msg.sender],"error");
                depoved[_id][msg.sender]=false;
    }
        function exit() external onlyOnwer{
                uint index=onwers.search(msg.sender);
                address temp=onwers[index];
                uint amount=funder[temp];
                funder[temp]-=amount;
                onwers.remove(index);
                emit PartNets(temp,amount);
        
         }

    receive() external payable{
        funderMe();
    }
    fallback() external payable{
        funderMe();
    }

    
}