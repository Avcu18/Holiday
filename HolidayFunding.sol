// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// To-Do
//  usdt converser needed
// preis je nach urlaubsziel/ dynamisieren

import "./HolidayVoting.sol";
import "./ETHtoUSDTconverter.sol";

contract Funding is Voting {
    using Converter for uint256;

    address [] friends;
    uint neededMoney; // pro person 
    mapping(address => uint256) public addressToAmountMoney;
    string FinalWinner;
    uint expenses;

    constructor(){
        setWinner();
    }    

   function setWinner() public {
    (,expenses) = winnerOfVoting();
    neededMoney = expenses;
    }


    function funding() public payable   {
        require(msg.value.getConversionRate() >= neededMoney, "You didnt send enough money"); // kann auch mehr geld schicken
        friends.push(msg.sender);
        addressToAmountMoney[msg.sender] = msg.value;

    }

    function withdraw() public onlyOwner{

        for (uint256 funderIndex =0; funderIndex < friends.length; funderIndex++) 
        {
            address funder = friends[funderIndex];
            addressToAmountMoney[funder] = 0;
        }
        friends = new address[](0);
  
    bool sendSuccess = payable(msg.sender).send(address(this).balance);
    require(sendSuccess, "Contracted couldnt be drained");
    }

}