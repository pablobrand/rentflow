// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import { IPool } from "@aave/contracts/interfaces/IPool.sol";

import "../interfaces/ILendingSolution.sol";


contract AaveLending is ILendingSolution, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public aToken;
    IERC20 public tokenUsedForPayments;
    //ILendingPool internal aaveLendingPool = ILendingPool(0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe);
    //address public aDaiTokenAddress = 0xdCf0aF9e59C002FA3AA091a46196b37530FD48a8;
    address payable public owner;
    uint256 public depositedAmountBalance;

    constructor(address _tokenUsedToPay) {
        tokenUsedForPayments = IERC20(_tokenUsedToPay);
        aToken = IERC20(aDaiTokenAddress);
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