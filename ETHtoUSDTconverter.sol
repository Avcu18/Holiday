pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library Converter{

    function getPrice() public view returns (uint256){
        // https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=eth%2Fusd
        // https://docs.chain.link/data-feeds/api-reference
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        (,int256 price,,,) = priceFeed.latestRoundData();
    }

}