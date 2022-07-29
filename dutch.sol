//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;


interface IERC721{
    function transferFrom(
        address _from,
        address _to,
        uint _nftId
    ) external;
}



contract DuthAution{
  
    uint private constant DURAITION= 7 days;

    IERC721 public immutable nft;
    
    uint public immutable nftId;

  
    address payable public immutable seller;
    
    uint public immutable startingPrice;
  
    uint public immutable startAt;

    uint public immutable lastAt;
    
    uint public immutable discountRate;


    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _nft,
        uint  _nftId
    ){
        
        require(_startingPrice>=_discountRate*DURAITION,"error");
        seller=payable(msg.sender);
        startingPrice=_startingPrice;
        discountRate=_discountRate;
        nft=IERC721(_nft);
        nftId=_nftId;
        startAt=block.timestamp;
        lastAt=block.timestamp+DURAITION;
    }


       
    function getPrice() public view returns (uint)
    {
       
        uint freetime=block.timestamp-startAt;
        uint discount=discountRate*freetime;
        return startingPrice-discount;
    }
    function buy() external payable{
        require(block.timestamp<lastAt,"error");
        uint price=getPrice();
        require(msg.value>=price,"error");
        nft.transferFrom(seller,msg.sender,nftId);
        uint back=msg.value-price;
        if(back>0){
            payable(msg.sender).transfer(back);
        }
        selfdestruct(seller);

    }


}


contract EnglishAuction{
    IERC721 public immutable nft;
    uint public immutable nftId;
    address payable public  immutable seller;
    uint32 public endAt;
    bool public started;
    bool public ended;
    address public highestBidder;
    uint public highestMoney;
    mapping(address=>uint) public bidder;
    
    
    constructor(
        address _nft,
        uint  _nftId,
        uint startngBid
    ){
        nft=IERC721(_nft);
        nftId=_nftId;
        seller=payable(msg.sender);
        highestMoney=startngBid;
    }

    function start() external payable{
        require(msg.sender==seller,"error");
        require(!started,"error");
        started=true;

        endAt=uint32(block.timestamp+60);

        nft.transferFrom(seller,address(this),nftId);


    }
    
    function bid() external  payable{
        require(started,"error");
        require(block.timestamp<endAt);
        require(msg.value>highestMoney,"error");
        if(highestBidder!=address(0)){
            bidder[highestBidder]+=highestMoney;
        }
        highestMoney=msg.value;
        highestBidder=msg.sender;
    }
       
    function widthMoney() external payable{
        uint amount =bidder[highestBidder];
        bidder[highestBidder]=0;
        payable(msg.sender).transfer(amount);
    } 
    
    function end() external{
        require(started,"error");
        require(!ended,"error");
        require(block.timestamp>=endAt,"error");
        ended=true;

        if(highestBidder!=address(0)){
            nft.transferFrom(address(this),highestBidder,nftId);
        }
        else{
            nft.transferFrom(address(this),seller,nftId);
        }
    }

}