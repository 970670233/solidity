
//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
//erc20合约
//实现ierc20接口的全部方法
interface IERC20{
    function totalSupply() external view returns(uint);

    function balanceOf(address account) external view returns(uint);

    function transfer(address recipient, uint amount) external returns(bool);

    function allowance(address owner,address spender) external view  returns(uint);

    function approve(address spender,uint amount) external returns(bool);

    function transferFrom(address sender, address recipient,uint amount) external returns(bool);

    event Transfer(address indexed from,address indexed to,uint amount);
    event Approval(address indexed onwer,address indexed spedner,uint amount);
}

contract ERC20 is IERC20{
    //token总量
    uint public override totalSupply;
    //账本 
    mapping(address=>uint256) public override balanceOf;
    //批准
    mapping(address=>mapping(address=>uint)) public override allowance;
    //token的名字
    string public name ="Test";
    //token的缩写
    string public symbol="TEST";
    //token的精度
    uint public decimals=18;
    //代表当前合约的token总量 
    // function totalSupply() external view returns(uint){
    //     return totalSupply;
    // }
    //代表某一个账户余额
    // function balanceOf(address account) external view returns(uint){
    //     return balanceOf[account]; 
    // }
    //代表将余额从前调用者发送到另一账户
    function transfer(address recipient, uint amount) external override returns(bool){
        balanceOf[msg.sender]-=amount;
        balanceOf[recipient]+=amount;
        emit Transfer(msg.sender,recipient,amount);
        return true;
    }
    //查询某一个账户对另一账户批准余额的多少
   // function allowance(owner, spender) external view  returns(uint){}
    //代表批准把我账户里的余额批准给另一个账户
    function approve(address spender, uint amount) external override returns(bool){
        allowance[msg.sender][spender]=amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }
    //向另一个账户存款
    function transferFrom(address spender,address recipient,uint amount) external override returns(bool){
            //从方法调用者被批准额度中减少
            allowance[spender][msg.sender]-=amount;
            balanceOf[spender]-=amount;
            balanceOf[recipient]+=amount; 
            return true;
    }
    //注币方法
    function mint(uint amount) external{
            balanceOf[msg.sender]+=amount;
            totalSupply+=amount;
            emit Transfer(address(0),msg.sender,amount);
    }
    //销毁方法
    function burn(uint amount)external{
        balanceOf[msg.sender]-=amount;
        totalSupply-=amount;
        emit Transfer(msg.sender,address(0),amount);
    }

}