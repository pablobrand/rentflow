// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

// aave
import "@aave/contracts/misc/AaveProtocolDataProvider.sol";
import "@aave/contracts/protocol/configuration/PoolAddressesProvider.sol";

// chainlink
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

//openzeppelin
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "../interfaces/ILendingSolution.sol";

// 1. Accept payment from tenant to landlord (payment screen)
// 2. Write public view function to get balance of the contract (chainlink keeper)
// 3. return a bool if youre the landlord (landlord dashboard page)
// 4. Required: X amount of tenants

contract LandLord is KeeperCompatibleInterface {
    using SafeERC20 for IERC20;

    address public landlord;
    address public tenant;

    mapping(address => bool) public my_tenants;
    address payable[] public tenants;

    IERC20 public tokenUsedForPayments;
    // ILendingSolution public lendingService;

    uint public counter;
    uint public immutable interval;
    uint public lastTimeStamp;


    modifier onlyLandLord() {
        require(msg.sender == landlord, "Restricted to the owner only");
        _;
    }

    constructor(address _landLord, address _tenantAddress, address _tokenUsedToPay, uint updateInterval) {
        interval = updateInterval;
        lastTimeStamp = block.timestamp;

        landlord = _landLord;
        tenant = _tenantAddress;
        tokenUsedForPayments = IERC20(_tokenUsedToPay);
    }    

    modifier onlyTenant() {
        require(my_tenants[msg.sender], "Only tenant can access this");
        _;
    }

    function addTenant(address _address) public onlyLandLord {
        my_tenants[_address] = true;
    }

    function payRent() public payable onlyTenant {
        //require(my_tenants[msg.sender], "You're not a tenant!");
        tenants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    // is used to change the behavior of a function in a declarative way
    function isOwner() public view virtual returns (bool) {
        return msg.sender == landlord;
    }

    function transfer_to_aave(uint256 _amount) internal returns (bool) {
        if (getBalance() > 100_000 gwei ) {
            return true;
        }
        // tokenUsedForPayments.approve(address(lendingService), _amount);

        // lendingService.depositFunds(_amount);
    }

    function checkUpkeep(bytes calldata /*checkData */) external view override returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
        return (upkeepNeeded, performData);
    }

    function performUpkeep(bytes calldata performData) external override {
        if ((block.timestamp - lastTimeStamp) > interval ) {
            lastTimeStamp = block.timestamp;
            counter = counter + 1;
        }
    }
}

// test
// this is our stuff at the bottom

// function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory performData) {
//     upkeepNeeded = address(this).balance > 2 ether; //2 * 1000000000000000000;
//     performData = abi.encode(address(this));
//     return (upkeepNeeded, performData);
// }

// function performUpkeep(bytes calldata performData) external override {
//     if (address(this).balance > 3 ether ) {
//         //transfer to aave
//         //
//         return 1;
//     }
// }
