//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//constant. immutable
//865943
//846407
contract Funder{
//23537
//21437
uint256 public  constant NUMBER_BY_MONEY=50*1e18;


address[] public funderAdress;

address public onwer;

constructor(){
    onwer=msg.sender;
}

mapping(address=>uint256) public funderAdressByAmount;

function fund() public payable{
    require(getConversion(msg.value)>=NUMBER_BY_MONEY,'sorry');
    funderAdress.push(msg.sender);
    funderAdressByAmount[msg.sender]+=msg.value;
}
function payMoney() public view returns(uint256){
    //ABI
    //address
    AggregatorV3Interface aggregatorV3Interface=AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    (,int price,,,)=aggregatorV3Interface.latestRoundData();
    return uint256(price*1e10);
}
    function getConversion(uint256 someMoney) public view returns(uint256){
        uint256 fixation=payMoney();
        return (someMoney*fixation)/1e18;
    }
    function forEach() public onlyOnwer{
        for(uint256 funderIndex=0;funderIndex<funderAdress.length;funderIndex++){
            address funder=funderAdress[funderIndex];
            funderAdressByAmount[funder]=0;
        }
        funderAdress=new address[](0);
        //transfer
        //抛出异常
        // payable(msg.sender).transfer(address(this).balance);
        // //send
        //返回值是一个布尔类型
        //如果有异常仅会返回一个false不会终止合约
        // bool successful=payable(msg.sender).send(address(this).balance);
        // require(successful,"sorry");
        //call
        //返回值有两个一个是布尔类型，另一个是字符类型
        //如果有异常也只是会返回false不会终止合约
        //推荐使用call函数来实现转账
        //将ether发送到msg.sender地址
       (bool successfulCall,)=payable(msg.sender).call{value: address(this).balance}("");
       require(successfulCall,"sorry");
    }
    //mod
    modifier onlyOnwer{
        require(onwer==msg.sender,"Onwer is not sender");
        _;
    } 
    //以下这两个函数用于接收外部汇款者的信息
    receive() external payable{
        fund();
    }
    fallback() external payable{
        fund();
    }

}
