// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatible.sol";

// 1. Accept payment from tenant to landlord (payment screen)
// 2. Write public view function to get balance of the contract (chainlink keeper)
// 3. return a bool if youre the landlord (landlord dashboard page)
// 4. Required: X amount of tenants

contract LandLord is Ownable, KeeperCompatibleInterface {

    mapping(address => bool) public my_tenants;
    address payable[] public tenants;
    
    //uint256 funds;

    function addTenant(address _address) public onlyOwner {
        my_tenants[_address] = true;
    }

    function payRent() public payable {
        require(my_tenants[msg.sender], "You're not a tenant!");
        tenants.push(msg.sender);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    // is used to change the behavior of a function in a declarative way
    function isOwner() public view virtual returns (bool) {
        return msg.sender == owner();
    }

    function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /* performData */) {
        upkeepNeeded = address(this).balance > 2 ether; //2 * 1000000000000000000;
        performData = abi.encode(address(this));
        return (upkeepNeeded, performData);
    }

    function performUpkeep(bytes calldata /* performData */) external override {

        if (address(this).balance > 3 ether ) {
            //transfer to aave
            //
            return 1;
        }
    }
}
