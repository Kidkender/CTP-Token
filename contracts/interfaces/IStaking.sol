pragma solidity ^0.8.20;

interface IStaking {
    
    function balanceOf(address account) external view returns (uint256);
    function earned(address account) external view returns (uint256);
    function getRewardforDuration() external view returns (uint256);
    function lastTimeRewardApplicable() external view returns (uint256);
    function rewardPerToken() external view returns (uint256);
    function rewardsDistribution() external view returns (address); 
    function rewardsToken() external view returns (address);

    function exit() external; 
    function getReward() external;
    function stake(uint256 amount) external;
    function withdraw(uint256 amount) external;
}