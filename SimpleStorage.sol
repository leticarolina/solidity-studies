// -------------------- SOLIDITY TYPES --------------------------

//SPDX-License-Identifier: MIT
//This specifies the licensing for the smart contract code you are writing in Solidity. 
//SPDX (Software Package Data Exchange) is a standard format used to define the licensing of software. It helps developers understand how a piece of software can be used, modified, and distributed.
//SPDX-License-Identifier: This part is a directive indicating that you are declaring the license for your code.
//MIT: This refers to the MIT License, which is a widely used open-source license. It allows developers to freely use, modify, and distribute the software, as long as they include the original license notice in any copies of the software.

pragma solidity >=0.8.19; //stating our version

contract SimpleStorage {
    //basic types: boolean, uint,int, address, bytes
    
    //using boolean to create a variable and give it a value
    bool hasFavoriteNumber = true;
    //can algo give a value using unit - unsigned integer
    uint256 favoriteNumber = 88;
    //can also be int, int can be positive or negative
    int256 favoriteNumber = -3;
    //or write some value
    string favoriteCity = "Paris";
    //the address type
    address myETHAddress = 0x76Cdd5a850a5B721A4f8285405d8a7ab5c3fc7E4;
    //using bytes , the largest byte is 32
    bytes32 = favoriteBytes32 = "Animal" //0x3j34fd will represent the hex of what the byte is

//all the types has a default value for eg uint 256 has default value of 0, boolean is false...
}

// -------------------- FUNCTIONS --------------------------
// Solidity Function Visibility Specifiers
// default is internal is no keyword is given
// 1. **Public**: 
//    - Can be called both internally and externally.
//    - Use when the function should be accessible by anyone.
// 
// 2. **External**: 
//    - Can only be called from outside the contract.
//    - Use for functions expected to be called externally, optimizing gas usage.
// 
// 3. **Internal**: 
//    - Can be called from within the contract and by derived contracts.
//    - Use for functions intended for internal use and inheritance.
// 
// 4. **Private**: 
//    - Can only be called from within the contract itself.
//    - Use for functions that should be completely hidden from outside access and inheritance.
// 
// Summary Table:
// | Specifier  | Internal Access  | External Access  | Inherited Access |
// |------------|------------------|------------------|------------------|
// | public     | Yes              | Yes              | Yes              |
// | external   | No               | Yes              | No               |
// | internal   | Yes              | No               | Yes              |
// | private    | Yes              | No               | No               |

contract SimpleStorage {
  uint256 public fav;

  function store(uint256 _fav) public {
    fav = _fav;
    fav = fav + 1;
  }

  function restore() public view returns(uint256){
    return fav;
  }
}