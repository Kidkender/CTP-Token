// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
        uint256 public constant MAX_TAX_RATE = 10000;
        // Transaction tax rate in basis points (1% = 100 basis points)
        uint256 public transactionTaxRate ;
        address public receiveTax;

        constructor(
            uint256 _inititalSupply, 
            uint256 _transactionTax, 
            address _receiveTax
            )
        ERC20("Carbon Token Proposals", "CTP")
        {
            _mint(msg.sender, _inititalSupply);
            transactionTaxRate = _transactionTax;
            receiveTax = _receiveTax;            
        }

        function mint(address to,uint256 amount) external onlyOwner {
            _mint(to, amount);
        }

        function burn(uint256 amount) external {
            _burn(msg.sender, amount);
        }

        function setTransactionTaxRate(uint256 _newTaxRate) external onlyOwner {
            require(newTaxRate<MAX_TAX_RATE, "Tax rate must be in basic point 0 - 10000");
            transactionTaxRate = _newTaxRate;    
        }

        function setReceiveTax(address _newReceiveTax) external onlyOwner {
            receiveTax = _newReceiveTax;
        }

        function transfer(address to, amount) external returns (bool) {
            
            uint256 taxAmount = (amount * transactionTaxRate) / ;
            uint256 afterTaxAmount = amount - taxAmount;

            require(_transfer(msg.sender, to, afterTaxAmount), "Token transfer failed.");
            require(_transfer(msg.sender, afterTaxAmount, taxAmount), "Transfer to recipient failed.");
            return true;            
        }        
}
