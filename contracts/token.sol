// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/utils/Nonces.sol";

contract Token is Ownable, ERC20, ERC20Permit, ERC20Votes {

        uint256 public constant MAX_TAX_RATE = 10000;
        // Transaction tax rate in basis points (1% = 100 basis points)
        uint256 public transactionTaxRate ;
        address public receiveTax;
        uint256 public poolReward;
        uint256 public rewardTokenAmount;

        mapping(address => uint256) private holderSince;

        constructor(
            address _inititalOwner,
            uint256 _inititalSupply, 
            uint256 _transactionTax, 
            address _receiveTax
            )
        ERC20("Carbon Token Proposals", "CTP")
        Ownable(_inititalOwner)
        ERC20Permit("GT")
        ERC20Votes()
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

        function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Votes) {
            super._update(from, to, value);
        }

        function nonces(address owner) public view virtual override(ERC20Permit, Nonces) returns (uint256) {
            return super.nonces(owner);
        }

        function setTransactionTaxRate(uint256 _newTaxRate) external onlyOwner {
            require(_newTaxRate<MAX_TAX_RATE, "Tax rate must be in basic point 0 - 10000");
            transactionTaxRate = _newTaxRate;    
        }

        function setReceiveTax(address _newReceiveTax) external onlyOwner {
            receiveTax = _newReceiveTax;
        }

        function transfer(address to, uint256 amount) public virtual  override returns (bool) {
            uint256 taxAmount = (amount * transactionTaxRate) / 10000;
            uint256 afterTaxAmount = amount - taxAmount;
            require(taxAmount>= 0, "tax Amount can not less 0");

            poolReward += taxAmount;
            require(super.transfer( to, afterTaxAmount), "Token transfer failed.");
            
            require(super.transfer( receiveTax, taxAmount), "Transfer to pool failed");    
            
            if (holderSince[to] == 0) {
                holderSince[to] = block.timestamp;
            }

            return true;            
        }

        function claimRewards() external returns (bool) {
            require(holderSince[msg.sender] > 0, "Not a holder");
            uint256 holdingDuration = block.timestamp - holderSince[msg.sender];
            require(holdingDuration >= 30, "Not eligible for rewards yet");


            uint256 rewards = holdingDuration / 1 days;

            require(rewards <= poolReward, "Insufficient rewards in the pool");
            _transfer(receiveTax, msg.sender, rewards);
            poolReward -= rewards;

            return true;
        }     

        function rewardForValidEvidence(address recipient) external  {
            require(recipient != address(0), "Address is not valid.");
            super._mint(recipient, rewardTokenAmount);
        }

        function setRewardTokenAmount(uint256 _newRewardTokenAmount) external onlyOwner {
            require(_newRewardTokenAmount > 0, "Reward token amount must be greater than 0");
            rewardTokenAmount = _newRewardTokenAmount;
        }
}