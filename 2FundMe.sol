// --------------------- FUND ME PROJECT -------------------------------------
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//get funds from users
//set a minimum value in 5USD
//be able to withdraw funds

import {Converter} from "./Converter.sol"; //IMPORTING THE LIBRARY 
using Converter for uint256; //essentially saying that any uint256 variable in our contract can use the functions defined in the Converter library 

contract FundMe {

uint256 minimumValueUsd = 5e18;
address[] public listOfAddressSentMoney;
//Mappings Are Like Hash Tables key to value
mapping(address addressOfSender => uint256 amountSent) public addressToAmountSent; //This line means that for each address key, there’s an associated uint256 value.
uint256 funderIndex; //the loop counter and the index variable in the for loop. 

//payable: This keyword allows the function to receive Ether. Functions that are expected to receive Ether must be marked payable.
//require is a way to enforce rules and conditions in your smart contract. If the condition is not satisfied, the function execution is halted, and any state changes are reverted.
//msg.value: This is a global variable that stores the amount of Ether (in wei) sent with the transaction. In this case is also the FIRST parameter for getConversionRate(second parameter here if necessary);
function getFunds() public payable {
   require(msg.value.getConversionRate() >= minimumValueUsd, "If the value is less than required then pop this message");
   listOfAddressSentMoney.push(msg.sender);
   addressToAmountSent[msg.sender] = addressToAmountSent[msg.sender] + msg.value;

 }

function withdraw() public {

// this for loop is looping thru each index of listOfAddressSentMoney,using the mapping addressToAmountSent to get the amount sent by each address and reset it to zero.
//in a mapping, you can access a value by providing the key in square brackets. For example, addressToAmountSent[0xabc...] would return 2 ether
//setting addressToAmountSent[0xabc...] = 0, it updates the value associated with that address key to 0.
for (funderIndex = 0; funderIndex < listOfAddressSentMoney.length; funderIndex++) {
    address funder = listOfAddressSentMoney[funderIndex];
    addressToAmountSent[funder] = 0; //This sets the amount sent by each address to 0, "withdrawing" their funds.
}
//tells Solidity to create a new dynamic array of type address[].
//(0) specifies that the initial length of this new array should be zero, effectively creating an empty array.
listOfAddressSentMoney = new address[] (0);

//callSuccess: A boolean indicating whether the call was successful (true) or not (false).
//The call function is being used here to transfer all the Ether in the contract to msg.sender.
//value: address(this).balance specifies the amount of Ether to send (in this case, all Ether held by the contract).
//The require statement checks the value of callSuccess. If callSuccess is false, the transaction reverts with the error message "Call failed".
(bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
require(callSuccess, "Call failed");
    }

    function calculateSum(uint256 number1, uint256 number2) public pure returns (uint256){
    return MathLibrary.sum(number1, number2);
    }
}


// ------------------------------- LIBRARY CONVERTER  -------------------------------------
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// This interface allows your contract to interact with a Chainlink price feed
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library Converter {
//AggregatorV3Interface is an interface, meaning it's a definition of how the contract at the specified address is structured.
//It tells the Solidity compiler which functions exist in the contract and how to interact with it.
//feedPrice: This is a variable that holds a reference to the existing contract at the specified address.
//AggregatorV3Interface feedPrice: This creates an instance of the AggregatorV3Interface contract at the specified address (0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF)
//you're connecting to a contract that is already deployed at 0xAddress and using its interface to call functions like latestRoundData().
 function getPrice() internal view returns (uint256){
   AggregatorV3Interface feedPrice = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
   (, int256 answer, , , ) = feedPrice.latestRoundData(); //answer = 244725000000
   return uint256(answer) * 1e18; //current example: 244,725,000,000,000,000,000,000,000,000 
   //this function retrieves the price of 1 ETH in USD, scaled up by 1e18 to handle decimal precision.
 }

//When a function takes an uint256 parameter intended to represent Ether, it is expected to be in wei.
//The division by 1e18 is necessary to convert from wei to Ether, ensuring the units align correctly.
 function getConversionRate(uint256 ethAmountInWei) internal view returns (uint256){
  uint256 ethPrice = getPrice(); // Step 1: Get the current price of 1 ETH in USD (scaled up by 1e18)
  uint256 ethAmountInUsd = (ethPrice * ethAmountInWei) / 1e18; //Step 2: Calculate the USD value of the specified ETH amount.You divide by 1e18 to scale the result back down to a human-readable number, since ethPrice was scaled up.
  return ethAmountInUsd; // Step 3: Return the calculated amount in USD

 }
 bool succesSend = payable(msg.sender).send(addres(.this.balance));
 require(succes, "call failed");
 
}




// ------------------------------- LIBRARY SIMPLE EXAMPLE  -------------------------------------
//LIBRARY
library MathLibrary {
    function sum(uint256 a,uint256 b) internal pure returns(uint256 ){
        return a + b;
    }
}
//CONTRACT
import "./MathLibrary.sol";
contract AddNumbers {
    using MathLibrary for uint256;

    function addTwoNumbers(uint256 num1, uint256 num2) public pure returns (uint256) {
        // Using the extension style {because of the using/for}
        return num1.add(num2); //can call the 1st parameter before the function
        //not using extension style
        MathLibrary.add(num1, num2);
    }
}
