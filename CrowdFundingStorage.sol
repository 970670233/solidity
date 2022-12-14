//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;



contract CrowdFundingStorage{
    struct Campaign {
        address payable receiver;
        uint numFunders;
        uint fundingGoal;
        uint totalAmount;
    }
    struct Funder{
        address addr;
        uint amount;
    }
    uint public numCampagins;
    mapping(uint => Campaign) campaigns;
    mapping(uint => Funder[]) funders;
    mapping(uint =>mapping(address =>bool)) isParticipate;
}

contract CrowdFunding is CrowdFundingStorage{

    address immutable owner;

    constructor(){
        owner=msg.sender;
    }

    modifier judgeParticipate(uint campaignID){
        require(isParticipate[campaignID][msg.sender]==false,"msg.sender is exist");
        _;
    }


    modifier isOwner() {
        require(msg.sender==owner);
        _;
    }

    function newCampaign(address payable receiver,uint goal)external isOwner() returns(uint campaignID){
        campaignID= numCampagins++;
        Campaign storage c =campaigns[campaignID];
        c.receiver=receiver;
        c.fundingGoal=goal;
    }


    function bid(uint campaignID) external payable judgeParticipate(campaignID){
        Campaign storage c= campaigns[campaignID];
        c.totalAmount+=msg.value;
        c.numFunders+=1;
        funders[campaignID].push(Funder({
            addr: msg.sender,
            amount: msg.value
        }));

        isParticipate[campaignID][msg.sender]=true;
    }


    function withdraw(uint campaignID)external returns(bool reached){
        Campaign storage c=campaigns[campaignID];

        if (c.totalAmount<c.fundingGoal){
            return false;
        }

        uint amount =c.totalAmount;
        c.totalAmount=0;

        c.receiver.transfer(amount);

        return true;
    }

}