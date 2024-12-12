// -------------------- SOLIDITY TYPES --------------------------

//SPDX-License-Identifier: MIT
//This specifies the licensing for the smart contract code you are writing in Solidity. 
//SPDX (Software Package Data Exchange) is a standard format used to define the licensing of software. It helps developers understand how a piece of software can be used, modified, and distributed.
//SPDX-License-Identifier: This part is a directive indicating that you are declaring the license for your code.
//MIT: This refers to the MIT License, which is a widely used open-source license. It allows developers to freely use, modify, and distribute the software, as long as they include the original license notice in any copies of the software.

pragma solidity >=0.8.19; //stating our version

contract SimpleStorage {
    //basic types: boolean, uint, int, address, bytes
    
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

// variables should generally be lowercase or in camelCase
//contract names and struct names usually start with uppercase letters (PascalCase).


// ------------------------------------- FUNCTIONS --------------------------
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
  uint256 public fav;  //created a variable called 'fav' without assigning a value //default is 0
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

//This is a view function, meaning it can read but not modify the blockchain's state.
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

//uint256 newNumer: This is a parameter of type uint256 that the function accepts when called. It represents the number that the user wants to store.
    function double(uint256 newNumer) public {
        // newNumer*number = number; //wrong way to declare!!
        number = newNumer * number;  // Multiply and assign the result to 'number'
    } 

    function reveal() public view returns(uint256){
        return number;
    }
}


//Recreating an object? Struct
contract SimpleStorage {
  uint256 myFav; //created a variable without assigning a value //0

// Struct 'Person' defines a custom data type 
  struct Person{
    uint256 favoriteNumber;
    string name;
  }
  // Example of creating a new 'Person' struct/object directly.
   Person public newPerson = Person(7, "leti"); //creting a new object
  // Another way to initialize using named parameters, which improves readability.
   Person public newPerson = Person({favoriteNumber: 7, name: "leticia"});

  // Declares a dynamic array of 'Person' structs. Dynamic arrays can grow in size.
  // Each element of this array will be a 'Person' struct.
  Person[] public listOfPeople;

// Function 'addPerson' adds a new 'Person' to the 'listOfPeople' array.
// It takes two arguments: string and uint256 (string must b stored in memory, as it's not stored on-chain).
 function addPerson(string memory _name, uint256 _favoriteNumber) public {
    listOfPeople.push(Person( _favoriteNumber, _name));
    // 'Person(_favoriteNumber, _name)' creates a new 'Person' struct and adds it to the array.
 }
}

// ------------------------------------- MAPPING --------------------------
//Syntax 
//mapping(keyType => valueType) visibility mappingName;
//keyType: The data type of the key. Keys can be any value type (e.g., uint, address, string).
//valueType: The data type of the value associated with each key that will be returned. Values can be any type, including structs and arrays.

//easy example
contract SimpleStorage {

  struct Person{uint256 favoriteNumber;
    string name;
  }
  
  Person[] public listOfPeople;

  // Declare a mapping that links a keyType name (string) to a value: favorite number (uint256)
  //syntax mapping(key -> type) visibility mappingName;
  mapping(string => uint256) public giveNameGetFavoriteNumber;

  //function to add a new person to the list and update the mapping
 function addPerson(string memory _name, uint256 _favoriteNumber) public {
  // Add a new Person struct to the array with the provided name and favorite number
    listOfPeople.push(Person( _favoriteNumber, _name));

 // Update the mapping with the person's name as the key and their favorite number as the value
    giveNameGetFavoriteNumber[_name] = _favoriteNumber;
 }
}


// Define a contract called SimpleBank
contract SimpleBank {
    
    // Define a mapping to link each address (user) to a balance (uint256)
    // `public` visibility lets anyone check any address's balance
    mapping(address => uint256) public balances;

    // A function to allow users to deposit Ether into their own balance
    function deposit() public payable {
        // `msg.sender` refers to the address of the person calling this function
        // `msg.value` is the amount of Ether sent with the transaction
        balances[msg.sender] += msg.value; // Add the Ether sent to the caller's balance
    }

    // A function that lets users check their balance
    function getBalance() public view returns (uint256) {
        return balances[msg.sender]; // Return the balance associated with the caller's address
    }
}


// ------------------------------------ IMPORT --------------------------
//SYNTAX: import {ContractOrLibrary} from "filepath";

//importing a contract to use in another, this can make one contract run/deploy another
import {SimpleStorage2} from "SimpleStorage.sol"; //The curly braces allow to specify a specific contract or library from the file.
//can also without braces, like import "SimpleStorage.sol" if you want access to all its contents/contracts in the file.

contract StorageFactory {
//type visibility variable, this is like a common variable declaration but the type is the CONTRACT
 SimpleStorage2 public simpleStorage; // first w capital letter is reffering to the contract itself and the second reffers to the 'variable name'
 //SimpleStorage2 refers to the contract type (from SimpleStorage.sol), while simpleStorage is the variable name.

 //after calling createSimpleStorageContract(), you have a freshly deployed SimpleStorage2 contract that you can use and interact with via simpleStorage.
 //new SimpleStorage2(): The keyword new is used to create a brand new instance *Copy* and deploy a contract in Solidity. 
 //When the new SimpleStorage2 instance is created, it’s assigned to simpleStorage, which is a state variable in StorageFactory.
 //This means that from within StorageFactory, you can interact with this deployed instance through the simpleStorage variable.
function createSimpleStorageContract() public {
    simpleStorage= new SimpleStorage2(); //the keyword new is how solidity knows to deploy a contract

    }

  // PS : It does not pull or interact with a pre-existing deployed SimpleStorage2 contract.
  //Instead, it creates and deploys a new instance of SimpleStorage2 on the blockchain each time new SimpleStorage2() is called.
    
}


// --------------------------------- INTERACTING WITH CONTRACTS ABI ----------------------------------
//interacting with the new instance of imported contract

//regular import
import {SimpleStorageOriginal} from "SimpleStorage.sol";


contract Factory {
//SimpleStorageOriginal[]: Declares a dynamic array to store multiple instances of the  type SimpleStorageOriginal.
//but it does NOT declare the type so that's why SimpleStorageOriginal will be repeated in the fucntion (to declare a type)
//Here, SimpleStorageOriginal specifies the type of each element in the array listOfGeneratedContracts
 SimpleStorageOriginal[] public listOfGeneratedContracts; 

//When you’re creating a new variable for the first time, you always have to specify the type so that the compiler knows what kind of data it will hold. 
//This is why you write SimpleStorageOriginal generatedContractVariable.
 function createSimpleStorageContract() public {
 //SimpleStorageOriginal is a contract type in this context, just like uint256 is a type for numbers. 
    SimpleStorageOriginal generatedContractVariable = new SimpleStorageOriginal(); 
    listOfGeneratedContracts.push(generatedContractVariable);
    }

//_indexOfGenerateContract: Specifies which instance of SimpleStorageOriginal you want to interact with (using the array index)
//_favoriteNumber: The number you want to store in that specific instance.
 function callingStoreFromSimpleStorageOriginal (uint256 _indexOfGenerateContract, uint256 _favoriteNumber) public {
  //address //ABI ??
 listOfGeneratedContracts[_indexOfGenerateContract].store(_favoriteNumber); //store is the name of function SimpleStorageOriginal has
  }

  function callingRetrieveFromSimpleStorageOriginal(uint256 _indexOfGenerateContract) public view returns (uint256) {
  return listOfGeneratedContracts[_indexOfGenerateContract].retrieve(); //this is a more consed code without declaring a type and variable
//   SimpleStorageOriginal mySimpleStorage = listOfGeneratedContracts[_indexOfGenerateContract];
//   return mySimpleStorage.retrieve();
  }
}

// --------------------------------- OVERRIDING A FUNCTION ----------------------------------

//importing the contract I want to override the function from
import {SimpleStorageOriginal} from "./SimpleStorage.sol";

//this declaration 'is' takes all the data from SimpleStorageOriginal and put into my new contract without having to code it.
//This line means that AddFiveToFavoriteNumber inherits all the functions and variables from SimpleStorageOriginal
contract AddFiveToFavoriteNumber is SimpleStorageOriginal {

//since we are overriding a function from SimpleStorageOriginal the function name HAS to be the same 
//the keyword override has to be in the function 
//about _favoriteNumber The parameter type must remain the same (e.g. uint256), but the parameter name can be different. However, for clarity and consistency, developers often keep the parameter names the same.
//_favoriteNumber is just the name used within the function in the SimpleStorageOriginal contract.
    function store (uint256 _favoriteNumber) public override{
        myFavoriteNumber = _favoriteNumber + 5;

    }

////example in SimpleStorageOriginal, same function in the SimpleStorageOriginal contract
//PS: the function you want to make overridable needs the 'virtual' keyword. This specifies that the function is open to being overridden by derived contracts.
 function store(uint256 _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }
