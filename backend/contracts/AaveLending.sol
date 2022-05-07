// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;


import { IPool } from "@aave/contracts/interfaces/IPool.sol";
import { IPoolAddressesProvider } from "@aave/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/contracts/misc/AaveProtocolDataProvider.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";

import "../interfaces/ILendingSolution.sol";

contract AaveLending is ILendingSolution {
    using SafeERC20 for IERC20;

    // Openzeppelin tokens
    IERC20 public aToken;
    IERC20 public tokenUsedForPayments;

    // aave pool
    IPoolAddressesProvider addressProvider = IPoolAddressesProvider(address(poolAddressesProvider));
    IPool internal aavePool = IPool(addressProvider.getPool());

    // ILendingPool internal aaveLendingPool = ILendingPool(0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe);
    //provider = addressProvider
    //TokenData[] aTokens = getAllATokens()
    //address public aETHTokenAddress = 0xE101EcB2283Acf0C91e05A428DDD8833Ac66B572;
    
    // contract variables
    
    // addresses
    address public poolAddressesProvider;
    address public aETHTokenAddress = 0xec6E5B3Bd3e8CC74756Af812994361d8D1EF30F8;
    
    address payable public owner;
    uint256 public depositedAmountBalance;

    modifier onlyOwner() {
        require(msg.sender == owner, "Restricted to the owner only");
        _;
    }

    constructor(address _tokenUsedToPay, address _poolAddressProvider) {
        tokenUsedForPayments = IERC20(_tokenUsedToPay);
        aToken = IERC20(aETHTokenAddress);
        owner = payable(msg.sender);
        poolAddressesProvider = _poolAddressProvider;
    }

    function depositFunds(uint256 amount) external override(ILendingSolution) onlyOwner {
        require(amount <= tokenUsedForPayments.balanceOf(address(this)), "amount exceeds contract balance");
        // Approve the LendingPool contract to pull the amount to deposit
        tokenUsedForPayments.approve(address(aavePool), amount);
        // Deposit the amount in the LendingPool
        aavePool.deposit(address(tokenUsedForPayments), amount, address(this), 0);

        depositedAmountBalance += amount;
    }
}