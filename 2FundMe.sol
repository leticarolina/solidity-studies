// --------------------- FUND ME PROJECT -------------------------------------
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//get funds from users
//set a minimum value in 5USD
//be able to withdraw funds
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

uint256 minimumValueUsd = 5;

//in order for the function be able to receive neeed to have payable?
    function getFunds() public payable {
    require(msg.value >= minimumValueUsd, "If the value is less than required then pop this message");
    }

 function getPrice() public {

 }
 function getCpnversionRtae() public{

 }
    function withdraw() public {

    }
}