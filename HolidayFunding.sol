
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//HELPful: für umrechnungen https://eth-converter.com/

// To-Do
// preis je nach urlaubsziel/ dynamisieren


import "./HolidayVoting.sol";
import "./ETHtoUSDTconverter.sol";

contract Funding is Voting {
    using Converter for uint256;

    address [] friends;
    uint public neededMoney; // pro person 
    mapping(address => uint256) public addressToAmountMoney;
    string FinalWinner;
    uint  expenses;
    // uint test = 100;
    
    //To-Do evtl event einfügen welches setWinner nach einer gewissen zeit/bedingung immer intalisiert
    constructor(){
        setWinner();
    }    
    /*
    function tester() public view returns(uint){
        return test.getConversionRate();
    }
    */
   function setWinner() public {
    (,expenses) = winnerOfVoting();
    neededMoney = expenses * 1e18;
    }


    function funding() public payable   {
        // require(msg.value.getConversionRate() >= neededMoney, "You didnt send enough money"); => funktioniert gerade nicht
        require(msg.value>= neededMoney, "You didnt send enough money"); // kann auch mehr geld schicken; msg.value.getConversionRate() == getConversionRate(msg.value) erster parameter wird genommen
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