// -------------------- SOLIDITY TYPES --------------------------

//SPDX-License-Identifier: MIT
//This specifies the licensing for the smart contract code you are writing in Solidity. 
//SPDX (Software Package Data Exchange) is a standard format used to define the licensing of software. It helps developers understand how a piece of software can be used, modified, and distributed.
//SPDX-License-Identifier: This part is a directive indicating that you are declaring the license for your code.
//MIT: This refers to the MIT License, which is a widely used open-source license. It allows developers to freely use, modify, and distribute the software, as long as they include the original license notice in any copies of the software.

pragma solidity >=0.8.19; //stating our version (equal or greater than 0.8.19) of solidity compiler to use)
pragma solidity >0.8.19 <0.9.0; //stating our version (greater than 0.8.19 and less than 0.9.0) of solidity compiler to use)
pragma solidity ^0.8.19; //stating our version (equal or greater than 0.8.19) of solidity compiler to use)

contract SimpleStorage {
    //basic types: boolean, uint, int, address, bytes
    
    //using boolean to create a variable and give it a value
    bool hasFavoriteNumber = true;
    //can give a value using uint - unsigned integer
    uint256 favoriteNumber = 88;
    //can also be int, integer can be positive or negative
    int256 favoriteNumberInt = -3;
    //write some value
    string favoriteCity = "Paris";
    //the address type
    address myETHAddress = 0x76Cdd5a850a5B721A4f8285405d8a7ab5c3fc7E4;
    //using bytes , the largest byte is 32
    bytes32 favoriteBytes32 = "Animal"; //0x3j34fd will represent the hex of what the byte is
        bytes myDynamicBytes = "Can be any value"; // Default: 0x0, dynamic size

}

// ------------------------------------- VARIABLES --------------------------
//all the types has a default value (e.g. uint 256 has default value of 0, boolean is false...)

// variables should generally be lowercase or in camelCase
//contract names and struct names usually start with uppercase letters (PascalCase).

//if something is referenc type, it means that it is not stored directly in the variable but rather a reference to where the data is stored.
//so need memory or storage to tell solidity where to store the data.
// ------------------------------------- FUNCTIONS --------------------------
// Solidity Function Visibility Specifiers
// default is internal if no keyword is given on function
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
  uint256 public fav;  //created a state variable called 'fav' without assigning a value //default is 0
  //The public keyword automatically generates a getter function for this variable
  //allowing external users or contracts to read its value without explicitly creating a getter function.
  //if visibility is private it will need a getter function
  // PS for public variables - In Solidity,  state variable as public, the name of that getter is exactly the name of the variable, used like a function.


//State-modifying function: Because this function changes the value of fav, it alters the blockchain state. 
//Since it changes the state, it will require gas to be executed when called in a transaction.
//function that takes an argument of type uint256 and stores it in the state variable fav.
//The underscore _ is often used to differentiate between local variables and state variables.
  function store(uint256 _fav) public {
    fav = _fav; //This assigns the value passed to the _fav parameter to the state variable fav, updating the value of fav stored on the blockchain.
    fav = fav + 1; 
  }

//This is a view function, meaning it can read but not modify the blockchain's state.
//public: The function can be called by anyone, both from within the contract and externally by users or other contracts.
//Since this function only reads the value of fav and doesn’t change it, it qualifies as a 'view' function.
  function restore() public view returns(uint256){
    return fav;
  }
}

contract SimpleStorage {
  uint256 public fav;  //state variable
  
  //_fav is local variable
  function store(uint256 _fav) public {
  fav = _fav; 
  //Assigns the value passed to the _fav local variable to the state variable fav 
  //Essentially updating the value of fav stored on the blockchain.
  }
}

//View and pure functions
//View functions can read data from the blockchain but cannot modify it. For example, the restore() function is marked as view because it reads the value of fav but doesn't change it.
//Pure functions neither read from nor write to the blockchain. They are used for purely computational purposes, such as performing calculations using only the inputs passed to the function. They cannot access state variables or any blockchain data.
//Gas Costs: Since view and pure functions don't modify the blockchain state, they don’t require gas when called externally (e.g., via a call). However, if they are called within a function that modifies state, they will consume gas as part of the overall transaction
//like if it's called within a function that does modify state

//rewriting clean function
contract MyFirstContract {
    uint256 public number = 13;

    error ZeroInput(); // custom error 

//uint256 newNumer: This is a parameter of type uint256 that the function accepts when called. It represents the number that the user wants to store.
    function double(uint256 newNumer) public {
        // newNumer*number = number; //wrong way to declare!!
        number = newNumer * number;  // Multiply and assign the result to 'number'
    } 

    function reveal() public view returns(uint256){
        return number;
    }
}

//example tests for this basic contract above
contract MyFirstContractTest is Test {
    MyFirstContract contractInstance;

    function setUp() public {
        contractInstance = new MyFirstContract();
    }

    function testInitialNumberIs13() public {
        uint256 stored = contractInstance.reveal();
        assertEq(stored, 13, "number not 13");
    }

    function testDoubleFunctionWorks() public {
        contractInstance.double(2);
        uint256 result = contractInstance.reveal();
        assertEq(result, 26, "After times 2, number should be 26");
    }

    function testDoubleWithZero() public {
        contractInstance.double(0);
        uint256 result = contractInstance.reveal();
        assertEq(result, 0, "Should result in 0");
    }

     function testRevertWhenInputIsZero() public {
        vm.expectRevert(MyFirstContract.ZeroInput.selector); // tell Foundry you expect the revert , What is .selector?
// Every function and custom error in Solidity has a 4-byte selector. The .selector is the 4-byte fingerprint of that error.
        contractInstance.double(0); //  the revert
    }

    function testDoubleWithNegativeFails() public {
        // Solidity doesn't support negative uints, so trying to pass a negative value isn’t possible here.
    }
}



//Recreating an object? use Struct
contract SimpleStorage {
  uint256 myFav; //created a variable without assigning a value //0

// Struct 'Person' defines a custom data type with for example stings, bool, uint256...
  struct Person{
    uint256 favoriteNumber;
    string name;
  }

  // Example of creating a new 'Person' struct/object, the parameters will be in the same order.
   Person public newPerson1 = Person(7, "leti"); //creting a new object
  // Another way to initialize struct using named parameters, which improves readability.
   Person public newPerson2 = Person({favoriteNumber: 7, name: "leticia"});

  // Declares a dynamic array of 'Person' structs. Dynamic arrays can grow in size.
  // Each element of this array will be a 'Person' struct.
  Person[] public listOfPeople;

// Function 'addPerson' adds a new 'Person' to the 'listOfPeople' array.
// It takes two arguments: string and uint256 (string must be stored in memory, as it's not stored on-chain).
 function addPerson(string memory _name, uint256 _favoriteNumber) public {
    listOfPeople.push(Person( _favoriteNumber, _name));
    // 'Person(_favoriteNumber, _name)' creates a new 'Person' struct and adds it to the array.
    // cannot .push(newPerson1) into listOfPeople as-is, because newPerson1 is a storage variable, and listOfPeople.push() expects a memory struct 
 }
}

//-------------------------------------   STRUCTS --------------------------
 //structs are a a way to group multiple variables of different data types under a single entity, just like an object in JavaScript.


    struct Person {
        uint256 age;
        string name;
        bool isMember;
    }

//Here, you’re creating a new instance of the Person struct with the following values
//The reason you repeat Person in the initialization is that you are instantiating a new struct instance.
    Person leticia = Person(1997, "Leticia", true);

    // Function to update a person’s information
    function updatePerson(uint256 _age, string memory _name, bool _isMember) public {
        leticia.age = _age;
        leticia.name = _name;
        leticia.isMember = _isMember;
    }

// ------------------------------------- MAPPING --------------------------
//Syntax 
//mapping(keyType => valueType) visibility mappingName;
//keyType: The data type of the key. Keys can be any value type (e.g., uint, address, string).
//valueType: The data type of the value associated with each key that will be returned. Values can be any type, including structs and arrays.

//easy example
contract SimpleStorage {

  struct Person{
    uint256 favoriteNumber;
    string name;
  }
  
  Person[] public listOfPeople;

  // Declare a mapping that links a keyType name (string) to a value: favorite number (uint256)
  //syntax mapping(key -> value) visibility mappingName;
  mapping(string => uint256) public giveNameGetFavoriteNumber;

  //function to add a new person to the list and update the mapping
 function addPerson(string memory _name, uint256 _favoriteNumber) public {
  // Add a new Person struct to the array with the provided name and favorite number
    listOfPeople.push(Person( _favoriteNumber, _name));

 // Update the mapping with the person's name as the key, and their favorite number as the value
    giveNameGetFavoriteNumber[_name] = _favoriteNumber;
 }
}


//another example
contract SimpleBank {
  
    // Define a mapping to link each user (address) to a balance (uint256)
    // `public` visibility lets anyone check any address's balance, so private we create our own getter function
    mapping(address => uint256) private balances;

    // A function to allow users to deposit Ether into their own balance
    function deposit() public payable {
        // `msg.sender` refers to the address of the person calling this function
        // `msg.value` is the amount of Ether sent with the transaction
        balances[msg.sender] += msg.value; // Add the Ether sent to the caller's balance
    }

    // A function that lets users check their balance
    function getBalance() public view returns (uint256) {
        return balances[msg.sender]; // Return the balance associated with the caller's 'address'
    }
}

//Mappings with Structs
//Mappings can also be used with structs to create more complex data structures.
struct User {
    uint256 balance;
    bool verified;
}

contract UserManagement {
    // Mapping each user (address) to a User struct
    // This allows us to store multiple pieces of information about each user
mapping(address => User) public users; // Mapping each user (address) to a User struct

function updateUser(address _user, uint256 _balance) public {
    users[_user].balance = _balance; // Update the balance of the user
    users[_user].verified = true; // Mark the user as verified
}
}
contract example{
//deleting a mapping
//This will reset the value associated with the key to its default value (0 for uint256, false for bool, etc.).
mapping(address => uint256) private balances;

function clearBalance(address _user) external {
    delete balances[_user];  // Resets balance to 0
}
}


// ------------------------------------- MEMORY VS CALLDATA --------------------------
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataLocationExample {

    function processMemory(string memory data) public pure returns (string memory) {
        data = "Modified in Memory";
        return data;
    }

    function processCalldata(string calldata data) public pure returns (string memory) {
        // This will throw an error: 
        data = "Cannot modify calldata";
        return data;
    }
}

//---------------------- MEMORY --------------------------
//Memory data is temporary and disappears after the function ends.
//But if you explicitly move that data to a storage location, it will persist even after the function ends.
//The push operation in the example transfers data from memory to storage, allowing us to access it later.
//That’s why you can still access the struct data later using the array index, even though the original memory struct has been wiped out.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MemoryVsStorage {

    struct Person {
        uint256 id;
        string name;
    }

    // This array is in storage by default
    Person[] public people;

    // Function that stores a person
    function addPerson(uint256 _id, string memory _name) public {
        // The `Person` struct instance is created in memory
        Person memory newPerson = Person(_id, _name); // This is a temporary instance of the struct, only existing during this function call

        // Now, we push the `newPerson` struct to the `people` array
        // This action stores it in storage, not memory
        people.push(newPerson); // The `push` moves the data from memory to storage
    }
}

// ------------------------------------ IMPORT --------------------------
//SYNTAX: import {ContractOrLibrary} from "filepath";

//importing a contract to use in another, this can make one contract run/deploy another
import {SimpleStorage2} from "SimpleStorage.sol"; //The curly braces allow to specify a specific contract or library from the file.
//can also without braces, like >import "SimpleStorage.sol"< if you want access to all its contents/contracts in the file.

contract StorageFactory {
// this is like a common variable declaration but the type IS the CONTRACT
///type visibility variable
 SimpleStorage2 public simpleStorage; // first w capital letter is reffering to the contract itself and the second reffers to the 'variable name'
 //SimpleStorage2 refers to the contract type (from SimpleStorage.sol), while simpleStorage is the variable name.

 //after calling createSimpleStorageContract(), you have a freshly deployed SimpleStorage2 contract that you can use and interact with via simpleStorage.
 //new SimpleStorage2(): The keyword new is used to create a brand new instance *Copy* and deploy a contract in Solidity. 
 //When the new SimpleStorage2 instance is created, it’s assigned to simpleStorage, which is a state variable in StorageFactory.
 //This means that from within StorageFactory, you can interact with this deployed instance through the simpleStorage variable.
function createSimpleStorageContract() public {
    simpleStorage= new SimpleStorage2(); //the keyword 'new' is how solidity knows to deploy a contract
    }

  // PS : It does not pull or interact with a pre-existing deployed SimpleStorage2 contract.
  //Instead, it creates and deploys a new instance of SimpleStorage2 on the blockchain each time new SimpleStorage2() is called.
    
}


// --------------------------------- INTERACTING WITH CONTRACTS ABI ----------------------------------
//interacting with the new instance of imported contract

contract SimpleStorageOriginal {
  uint256 public favoriteNumber; 
  
  function store(uint256 _favoriteNumber) public {
  favoriteNumber = _favoriteNumber; 
  favoriteNumber = _favoriteNumber + 1;
  }

  function retrieve() public view returns (uint256){
    return favoriteNumber;
  }

}


//_____

//regular import
import {SimpleStorageOriginal} from "SimpleStorage.sol";

contract Factory {
//SimpleStorageOriginal[]: Declares a dynamic array to store multiple instances of the type SimpleStorageOriginal.
//but it does NOT declare the type so that's why SimpleStorageOriginal will be repeated in the function (to declare a type)
//Here, SimpleStorageOriginal specifies the type of each element in the array listOfGeneratedContracts
 SimpleStorageOriginal[] public listOfGeneratedContracts; 

//When you’re creating a new variable for the first time, you always have to specify the type so that the compiler knows what kind of data it will hold. 
//This is why you write 'SimpleStorageOriginal generatedContractVariable'
 function createSimpleStorageContract() public {
 //SimpleStorageOriginal is a contract type in this context, just like uint256 is a type for numbers. 
    SimpleStorageOriginal generatedContract = new SimpleStorageOriginal(); 
    listOfGeneratedContracts.push(generatedContract);
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

//example in the SimpleStorageOriginal that was overriden, same function in the SimpleStorageOriginal contract
//PS: the function you want to make overridable needs the 'virtual' keyword. This specifies that the function is open to being overridden by derived contracts.
 function store(uint256 _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }
}
//------------------- SUPER FUNCTION --------------------------
//The super keyword is used to call a function from the parent contract.
//This is useful when you want to extend or modify the behavior of a function in the derived contract while still retaining the functionality of the parent contract's implementation.
//In the example, super.store(_favoriteNumber) calls the store function from the parent contract (SimpleStorageOriginal) before adding 5 to the favorite number.
//You use super.functionName() inside your override to call the parent contract’s logic.

function store(uint256 _favoriteNumber) public virtual {
  myFavoriteNumber = _favoriteNumber;
}

function store (uint256 _favoriteNumber) public override{
  super.store(_favoriteNumber); // Call the parent logic
  myFavoriteNumber = myFavoriteNumber + 5; // Extend it 
}


//--------------------------deployed to zksync sepolia testnet via remix
// 0x9768942ad4c0c04e48beb2f297826bd43ff683e21d7dcd86ba8795c8e0a6c4d8
contract FamilyProfile {

  struct Person {
   uint256 birthYear;
   string name;
 }

  //created new instance of the Person struct, must follow order of the data struct
  Person public myself = Person(1997, "Leticia Azevedo");
  //If using named arguments, the order does not matter.
  Person public myMom = Person({birthYear: 1977, name: "Katia"});

 // Function to update a struct, only updates the 'myself' struct instance.
 function updatePerson(uint256 _birthYear, string memory _name) public {
    myself.birthYear = _birthYear;
    myself.name = _name;
  }
}
// --------------------------------- ENUMS ----------------------------------
//Enums are a way to define a custom type with a finite set of possible values.
//Enums are useful for representing a state or condition that can take on a limited number of values.
//Enums are often used to make code more readable and maintainable by replacing magic numbers or strings with meaningful names.
//Enums are stored as uint256 under the hood, starting from 0 for the first value, 1 for the second, and so on.
//Enums are a way to define a custom type with a finite set of possible values.
//Enums are useful for representing a state or condition that can take on a limited number of values.
//Enums are often used to make code more readable and maintainable by replacing magic numbers or strings with meaningful names.
//Enums are stored as uint256 under the hood, starting from 0 for the first value, 1 for the second, and so on.
//Enums are a way to define a custom type with a finite set of possible values. 

//-------------------reentrancy security --------------------------
function withdrawSecure() public {
    uint256 amount = balances[msg.sender];

    //State update FIRST
    balances[msg.sender] = 0;

    //External call AFTER state is safe
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}


bool private locked;

modifier noReentrant() {
    require(!locked, "Reentrant call");
    locked = true;
    _;
    locked = false;
}   

// withdraw function will use the noReentrant modifier
function withdrawSecure() public noReentrant {
}

//------------------ VERIFICATION --------------------------
mapping(address => bool) public isVerified; // Mapping to track verified addresses
address public admin; // The address of the admin who can verify/revoke addresses

constructor() {
    admin = msg.sender; 
}

modifier onlyAdmin() {
    require(msg.sender == admin, "Not admin"); // Only allow the admin to call the function
    _;
}

function verifyAddress(address _user) external onlyAdmin {
    isVerified[_user] = true;  // Set the address as verified
}

function revokeAddress(address _user) external onlyAdmin {
    isVerified[_user] = false; // Revoke the verification
}

import {SimpleStorageOriginal} from "SimpleStorage.sol";

contract Factory {
SimpleStorageOriginal[] public listOfGeneratedContracts; 

function createSimpleStorageContract() public {
    SimpleStorageOriginal generatedContract = new SimpleStorageOriginal(); 
    listOfGeneratedContracts.push(generatedContract);
}


address public owner;

modifier onlyOwner() {
    require(msg.sender == owner, "Not the owner");
    _; //Placeholder for the function, means: “Now run the actual function.”
}


function withdraw() public onlyOwner {
    // Only runs if msg.sender == owner
    // Function body goes here
}

error NotOwner(address caller);

if (msg.sender != i_owner) {
    revert NotOwner(msg.sender);
}

error NotOwner(address caller);

modifier onlyOwner {
    // require(msg.sender == owner, "Not contract owner");
    if (msg.sender != i_owner) {
        revert NotOwner(msg.sender);
    }
    _;
}

