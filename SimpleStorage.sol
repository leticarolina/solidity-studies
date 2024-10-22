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
  uint256 public fav;  //created a variable called 'fav' without assigning a value //0
  //The public keyword automatically generates a getter function for this variable
  //allowing external users or contracts to read its value without explicitly creating a getter function.


//function that takes an argument of type uint256 and stores it in the state variable fav.
//The underscore _ is often used to differentiate between local variables and state variables.

  function store(uint256 _fav) public {
    fav = _fav; //This assigns the value passed to the _fav parameter to the state variable fav, updating the value of fav stored on the blockchain.
    fav = fav + 1;
  }
  //State-modifying function: Because this function changes the value of fav, it alters the blockchain state. 
  //Since it changes the state, it will require gas to be executed when called in a transaction.

//This function is a view function, meaning it can read but not modify the blockchain's state.
//public: The function can be called by anyone, both from within the contract and externally by users or other contracts.
//Since this function only reads the value of fav and doesn’t change it, it qualifies as a view function.
  function restore() public view returns(uint256){
    return fav;
  }
}

//View and pure functions
//View functions can read data from the blockchain but cannot modify it. For example, the restore() function is marked as view because it reads the value of fav but doesn't change it.
//Pure functions neither read from nor write to the blockchain. They are used for purely computational purposes, such as performing calculations using only the inputs passed to the function. They cannot access state variables or any blockchain data.
//Gas Costs: Since view and pure functions don't modify the blockchain state, they don’t require gas when called externally (e.g., via a call). However, if they are called within a function that modifies state, they will consume gas as part of the overall transaction

//rewriting clean function

contract MyFirstContract {
    uint256 number = 13;

    function double(uint256 newNumer) public {
        // newNumer*number = number; //wrong way to declare!!
        number = newNumer * number;  // Multiply and assign the result to 'number'
    }

    function reveal() public view returns(uint256){
        return number;
    }
}



//recreating an object?
contract SimpleStorage {
  uint256 myFav; //created a variable without assigning a value //0

// Struct 'Person' defines a custom data type 
  struct Person{
    uint256 favoriteNumber;
    string name;
  }

  // Example of creating a new 'Person' object directly.
  //  Person public newPerson = Person(7, "leti"); //creting a new object
  // Another way to initialize using named parameters, which improves readability.
  //  Person public newPerson = Person({favoriteNumber: 7, name: "leticia"});

  // uint256[] listOfPeople; //the brackets declare the array

  // Declares a dynamic array of 'Person' structs. Dynamic arrays can grow in size.
  // Each element of this array will be a 'Person' struct.
  Person[] public listOfPeople;

//function to push a new person
// Function 'addPerson' adds a new 'Person' to the 'listOfPeople' array.
// It takes two arguments: (stored in memory, as it's not stored on-chain).
 function addPerson(string memory _name, uint256 _favoriteNumber) public {
    listOfPeople.push(Person( _favoriteNumber, _name));
    // 'Person(_favoriteNumber, _name)' creates a new 'Person' struct and adds it to the array.
 }
}