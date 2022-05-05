// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { IPool } from "@aave/contracts/interfaces/IPool.sol";
import "../interfaces/ILendingSolution.sol";

import "@aave/core-v3/contracts/misc/AaveProtocolDataProvider.sol";
import "@aave/contracts/protocol/configuration/PoolAddressesProvider.sol";


contract AaveLending is ILendingSolution, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public aToken;
    IERC20 public tokenUsedForPayments;

    PoolAddressesProvider addressProvider = PoolAddressesProvider(address(0x651b8A8cA545b251a8f49B57D5838Da0a8DFbEF9)); //mainnet address
    LendingPool internal aaveLendingPool = LendingPool(addressProvider.getLendingPool());

    // ILendingPool internal aaveLendingPool = ILendingPool(0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe);
    //provider = addressProvider
    //TokenData[] aTokens = getAllATokens()
    //address public aETHTokenAddress = 0xE101EcB2283Acf0C91e05A428DDD8833Ac66B572;
    address public aEthTokenAddress = '0xec6E5B3Bd3e8CC74756Af812994361d8D1EF30F8;
    address payable public owner;
    uint256 public depositedAmountBalance;

    constructor(address _tokenUsedToPay) {
        tokenUsedForPayments = IERC20(_tokenUsedToPay);
        aToken = IERC20(aETHTokenAddress);
        owner = payable(msg.sender);
    }

    function depositFunds(uint256 amount) external override(ILendingSolution) onlyOwner {
        require(amount <= tokenUsedForPayments.balanceOf(address(this)), "amount exceeds contract balance");
        // Approve the LendingPool contract to pull the amount to deposit
        tokenUsedForPayments.approve(address(aaveLendingPool), amount);
        // Deposit the amount in the LendingPool
        aaveLendingPool.depositFunds(address(tokenUsedForPayments), amount, address(this), 0);

        depositedAmountBalance += amount;
    }
}