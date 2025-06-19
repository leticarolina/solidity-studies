//SPDX-License-Identifier:MIT

pragma solidity ^0.8.17;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    //returns current price of ethereum in USD, in 18 decimals (eg. 3000_000000000000000000)
    function getPriceOfEthereum() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData(); //assigns just the second return value
        uint256 ethPriceInUsd = uint256(answer) * 1e10; // Convert from 8 decimals to 18
        return ethPriceInUsd;
    }

    //convert specified amount in ETH to USD equivalent
    function convertEthAmountToUsd(
        uint256 ethAmount
    ) public view returns (uint256) {
        uint256 priceOfEthereum = getPriceOfEthereum(); //eg 3000e18
        uint256 ethAmountInUsd = (priceOfEthereum * ethAmount) / 1e18; //3000e18 * 0.05
        return ethAmountInUsd;
    }
}
