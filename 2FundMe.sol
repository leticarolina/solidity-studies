// --------------------- FUND ME PROJECT -------------------------------------
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//get funds from users
//set a minimum value in 5USD
//be able to withdraw funds

// This interface allows your contract to interact with a Chainlink price feed
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

uint256 minimumValueUsd = 5e18;
address[] public listOfAddressSentMoney;
mapping(address addressOfSender => uint256 amountSent) public addressToAmountSent;

//payable: This keyword allows the function to receive Ether. Functions that are expected to receive Ether must be marked payable.
//require is a way to enforce rules and conditions in your smart contract. If the condition is not satisfied, the function execution is halted, and any state changes are reverted.
//msg.value: This is a global variable that stores the amount of Ether (in wei) sent with the transaction.
function getFunds() public payable {
   require(getConversionRate(msg.value) >= minimumValueUsd, "If the value is less than required then pop this message");
   listOfAddressSentMoney.push(msg.sender);
   addressToAmountSent[msg.sender] = addressToAmountSent[msg.sender] + msg.value;

 }


//AggregatorV3Interface is an interface, meaning it's a definition of how the contract at the specified address is structured.
//It tells the Solidity compiler which functions exist in the contract and how to interact with it.
//feedPrice: This is a variable that holds a reference to the existing contract at the specified address.
//AggregatorV3Interface feedPrice: This creates an instance of the AggregatorV3Interface contract at the specified address (0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF)
//you're connecting to a contract that is already deployed at 0xAddress and using its interface to call functions like latestRoundData().
 function getPrice() public view returns (uint256){
   AggregatorV3Interface feedPrice = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
   (, int256 answer, , , ) = feedPrice.latestRoundData(); //answer = 244725000000
   return uint256(answer) * 1e18; //current example: 244,725,000,000,000,000,000,000,000,000 
   //this function retrieves the price of 1 ETH in USD, scaled up by 1e18 to handle decimal precision.
 }

//When a function takes an uint256 parameter intended to represent Ether, it is expected to be in wei.
//The division by 1e18 is necessary to convert from wei to Ether, ensuring the units align correctly.
 function getConversionRate(uint256 ethAmountInWei) public view returns (uint256){
  uint256 ethPrice = getPrice(); // Step 1: Get the current price of 1 ETH in USD (scaled up by 1e18)
  uint256 ethAmountInUsd = (ethPrice * ethAmountInWei) / 1e18; //Step 2: Calculate the USD value of the specified ETH amount.You divide by 1e18 to scale the result back down to a human-readable number, since ethPrice was scaled up.
  return ethAmountInUsd; // Step 3: Return the calculated amount in USD

 }
 //
    function withdraw() public {

    }
}