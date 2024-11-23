//common structure for organizing Solidity contracts:

//Pragma Statements - Version declarations and imports.
//State Variables - Define variables to store contract state.
//Modifiers - Place modifiers after state variables to provide access control or reusable checks for the functions below.
//Constructor - Initialization logic.
//Functions - Functions using modifiers can then be defined, and having modifiers close to them makes the purpose of each function clear.

// --------------------- FUND ME PROJECT -------------------------------------
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//get funds from users
//set a minimum value in 5USD
//be able to withdraw funds

import {Converter} from "./Converter.sol"; //IMPORTING THE LIBRARY 
using Converter for uint256; //essentially saying that any uint256 variable in our contract can use the functions defined in the Converter library 

// you can define custom errors to provide meaningful descriptions for conditions that fail in your smart contract
//error is the keyword used to define a custom error. //notOwner is the name of the error
error notOwner();

contract FundMe {

uint256 public constant MINIMUM_VALUE_USD = 5e18; //Variables declared as constant are set at the time of compilation and cannot be change afterward.
address[] public listOfAddressSentMoney;
//Mappings Are Like Hash Tables key to value
mapping(address addressOfSender => uint256 amountSent) public addressToAmountSent; //This line means that for each address key, there’s an associated uint256 value.
uint256 funderIndex; //the loop counter and the index variable in the for loop. 
address public immutable i_owner; //Variables declared as immutable are set once, but only at deployment time, and cannot be changed afterward.


//The constructor is executed only once, when the contract is deployed. After deployment, it cannot be called again.
//The purpose of the constructor is often to initialize important variables or set initial values for the contract.
//msg.sender in the context of the constructor refers to the address that deployed the contract
//This code is commonly used to establish ownership of the contract. 
constructor(){
    i_owner = msg.sender;
}

//Modifiers in Solidity are used to define reusable conditions or checks that can be applied to multiple functions to control access or enforce certain behaviors. 
//The modifier checkIfItsOwner is a common example, which restricts access to certain functions so only the owner can call them.
//Revert: If the condition is true (the sender is not the owner), the transaction is reverted using the revert keyword, and the notOwner() error is triggered.
modifier checkIfItsOwner() {
      if(msg.sender != i_owner) {
        revert notOwner();
    }
     _; //Continues to function execution if the require passes

//msg.sender == owner: This condition checks if the address calling the function (msg.sender) is the same as the owner address stored in the contract.
//This line is used for access control. By placing this require statement at the beginning of a function, you ensure that only the contract owner can call that function.
// require(msg.sender == i_owner, "Message.sender must be equal owner");
}


//This function is designed to handle plain Ether transfers (without any data) to the contract.
//Visibility: external means that it can only be called from outside the contract, which is standard for receive().
    receive() external payable {
        getFunds();
    }
//This function is used as a catch-all function that gets triggered when the contract:
//Receives Ether along with data, or attempts to call a function that doesn’t exist in the contract.
    fallback() external payable {
        getFunds();
    }


//payable: This keyword allows the function to receive Ether. Functions that are expected to receive Ether must be marked payable.
//require is a way to enforce rules and conditions in your smart contract. If the condition is not satisfied, the function execution is halted, and any state changes are reverted.
//msg.value: This is a global variable that stores the amount of Ether (in wei) sent with the transaction. In this case is also the FIRST parameter for getConversionRate(second parameter here if necessary);
function getFunds() public payable {
   require(msg.value.getConversionRate() >= MINIMUM_VALUE_USD, "If the value is less than required then pop this message");
   listOfAddressSentMoney.push(msg.sender);
   addressToAmountSent[msg.sender] = addressToAmountSent[msg.sender] + msg.value;

 }

function withdraw() public checkIfItsOwner {
//no need for this code below bcs the CheckIfItsOwner modifier is being embed in the function
// require(msg.sender == owner, "Message.sender must be equal owner");

// this for loop is looping thru each index of listOfAddressSentMoney,using the mapping addressToAmountSent to get the amount sent by each address and reset it to zero.
//in a mapping, you can access a value by providing the key in square brackets. For example, addressToAmountSent[0xabcm...] would return 2 ether
//setting addressToAmountSent[0xabcm...] = 0, it updates the value associated with that address key to 0.
for (funderIndex = 0; funderIndex < listOfAddressSentMoney.length; funderIndex++) {
    address funder = listOfAddressSentMoney[funderIndex];
    addressToAmountSent[funder] = 0; //This sets the amount sent by each address to 0, "withdrawing" their funds.
}
//tells Solidity to create a new dynamic array of type address[].
//(0) specifies that the initial length of this new array should be zero, effectively creating an empty array.
listOfAddressSentMoney = new address[] (0);

//callSuccess: A boolean indicating whether the call was successful (true) or not (false).
////The require statement below checks the value of callSuccess. If callSuccess is false, the transaction reverts with the error message "Call failed".
// msg.sender refers to the address of the account or contract that triggered the current function execution.
//.call is a low-level function in Solidity used to send Ether to another address
//value: specifies how much Ether to send. In Solidity, value is a keyword used to set the amount of Ether (in wei) that should be sent along with the call.
//address(this).balance refers to the total balance of Ether held by the contract (this refers to the current contract). 
//By using address(this).balance, we’re telling the contract to send all of its current Ether balance to msg.sender
//("") represents an empty call payload.
//In Solidity, call can take data that the receiving contract could use to execute a specific function or logic. By passing an empty string (""), we're simply sending Ether without any additional data or instructions.
(bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
require(callSuccess, "Call failed");
    }

    function calculateSum(uint256 number1, uint256 number2) public pure returns (uint256){
    return MathLibrary.sum(number1, number2);
    }
}


// ------------------------------- LIBRARY CONVERTER  -------------------------------------
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// This interface allows contract to interact with a Chainlink price feed
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
        return num1.add(num2); //can call the 1st parameter before the function and then second and rest parameters after
        //not using extension style, need to use the library name aswell
        MathLibrary.add(num1, num2); 
    }
}

// ------------------------------- Constrcutor  -------------------------------------
// the constructor in Solidity is always called once at the beginning when the contract is deployed.
//Once the contract is on the blockchain, the constructor code is no longer accessible.
// It’s where you typically define any initial setup, like initial balances, owner addresses, or other settings that should be established when the contract starts.
contract MyContract {
 address public owner;

 constructor () {
    owner = msg.sender; // Sets the deployer as the contract owner
    }
 }


// ------------------------------- FALLBACK & RECEIVE -------------------------------------
//The fallback and receive functions in Solidity are special functions that handle how a contract interacts with incoming transactions that don't call a specific function. 

//If neither receive nor fallback is implemented, any Ether sent to the contract will revert.
//Both functions are optional but useful for creating flexible, error-resilient contracts.
//Misuse of fallback (e.g., allowing arbitrary calls without checks) can lead to security vulnerabilities.
contract FallBackExample {
    uint256 public resultFromUnknownTransaction;

    receive() external payable{
        resultFromUnknownTransaction = 1;
        //"money was sent to this contract without using 'GetFunds' function, so receive () will take care of it";
    }

    fallback() external payable {
        resultFromUnknownTransaction = 2;
        //"an unknown fucntion was called in CALLDATA so this is the fallback";
    }


}

// !!!----- FOR CONSTANT AND IMMUTABLE , check my OneNote!!
// !!!----- FOR CONSTANT AND IMMUTABLE , check my OneNote!!