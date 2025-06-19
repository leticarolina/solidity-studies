//SPDX-License-Identifier: MIT
pragma solidity >=0.8.18;


import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

SimpleStorage[] public simpleStorageArray;

function createSimpleStorage() public {
     SimpleStorage newSimpleStorage = new SimpleStorage();
     simpleStorageArray.push(newSimpleStorage);
}

//function allows to store a value in the SimpleStorage contract at the specified index
function sfStoreValueInIndex(uint256 _index, uint256  _favoriteNumber) public {
    simpleStorageArray[_index].store(_favoriteNumber);
}

function sfGetValueInIndex(uint256 _index) public view returns (uint256){
  return simpleStorageArray[_index].retrieve();
}}
