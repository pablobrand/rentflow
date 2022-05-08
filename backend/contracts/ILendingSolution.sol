// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

//1. factory
//2. rental agreement
//3. interface
//4. aave, or any other service

interface ILendingSolution {

    function depositFunds(uint256 amount) external;

    // function withdrawFunds(uint256 amount) external;

    // function withdrawFundsAndInterest() external;

    // function checkBalance() external view returns(uint256); 

}

