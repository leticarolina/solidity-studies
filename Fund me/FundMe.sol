//SPDX-License-Identifier:MIT

pragma solidity ^0.8.17;

import {PriceConverter} from "./PriceConverter.sol";
contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;
    address[] public funders;
    address public immutable i_owner;
    mapping(address => uint256) public funderAdressToAmountFunded;

    error NotOwner(address caller);

    modifier onlyOwner() {
        // require(msg.sender == owner, "Not owner of the contract");
        if (msg.sender != i_owner) {
            revert NotOwner(msg.sender);
        }
        _;
    }

    function fund() public payable {
        // require(msg.value > 1e18, "Value does not meet minimum");
        require(
            msg.value.convertEthAmountToUsd() >= MINIMUM_USD,
            "Value does not meet minimum"
        );
        funders.push(msg.sender);
        funderAdressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            funderAdressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        //call
        (bool callSucess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSucess, "Failed to send Ether");
    }
    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }
}
