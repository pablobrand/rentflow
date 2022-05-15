// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6 <0.8.0;

// aave
// import "@aave/contracts/misc/AaveProtocolDataProvider.sol";
// import "@aave/contracts/interfaces/IlendingPoolAddressesProvider.sol";

// chainlink
// import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

//openzeppelin
import { IERC20 } from "../interfaces/IERC20.sol";
//import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import { ILendingPool } from "../interfaces/ILendingPool.sol";

// import "./ILendingSolution.sol";

// 1. Accept payment from tenant to landlord (payment screen)
// 2. Write public view function to get balance of the contract (chainlink keeper)
// 3. return a bool if youre the landlord (landlord dashboard page)
// 4. Required: X amount of tenants

contract LandLord {


    IERC20 public tokenUsedForPayments;
    ILendingPool public aavePool;

    event seeme(address aavePool, uint256 _amount, address sender, address tokenUsedForPayments);

    constructor (
        address _tokenUsedToPay,
        address _lendingService /*uint updateInterval*/
    ) public {
        tokenUsedForPayments = IERC20(_tokenUsedToPay);
        aavePool = ILendingPool(_lendingService);
    }

    function transferToAave(uint256 _amount) public {
        // require(tokenUsedForPayments.allowance(tenant, address(this)) >= rent, "No Allowance");
        tokenUsedForPayments.transferFrom(msg.sender, address(this), _amount);
        
        tokenUsedForPayments.approve(address(aavePool), _amount);
        // Deposit the _amount in the LendingPool

        //emit seeme(address(aavePool), _amount, address(msg.sender), address(tokenUsedForPayments));
        aavePool.deposit(address(tokenUsedForPayments), _amount, address(this), 0);

    }







    // function addTenant(address _address) public onlyLandLord {
    //     my_tenants[_address] = true;
    // }

    // function payRent() public payable onlyTenant {
    //     //require(my_tenants[msg.sender], "You're not a tenant!");
    //     tenants.push(payable(msg.sender));
    // }

    // function getBalance() public view returns (uint256) {
    //     return address(this).balance;
    // }

    // modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    // is used to change the behavior of a function in a declarative way
    // function isOwner() public view virtual returns (bool) {
    //     return msg.sender == landlord;
    // }

    
}





// // function checkUpkeep(bytes calldata /*checkData */) external view override returns (bool upkeepNeeded, bytes memory performData) {
// //     upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
// //     return (upkeepNeeded, performData);
// // }
// // function performUpkeep(bytes calldata performData) external override {
// //     if ((block.timestamp - lastTimeStamp) > interval ) {
// //         lastTimeStamp = block.timestamp;
// //         counter = counter + 1;
// //     }
// // }

// // test
// // this is our stuff at the bottom

// // function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory performData) {
// //     upkeepNeeded = address(this).balance > 2 ether; //2 * 1000000000000000000;
// //     performData = abi.encode(address(this));
// //     return (upkeepNeeded, performData);
// // }

// // function performUpkeep(bytes calldata performData) external override {
// //     if (address(this).balance > 3 ether ) {
// //         //transfer to aave
// //         //
// //         return 1;
// //     }
// // }
