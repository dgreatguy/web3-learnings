// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface IToken {
    function balanceOf(address account) external view returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function withdrawEther() external;
}

contract StakingRewards is Ownable {
    IToken public stakedToken;
    ERC20 public rewardToken;
    uint256 public rewardRatePerMinute;

    struct StakerInfo {
        uint256 stakedAmount;
        uint256 stakingTime;
        uint256 lastRewardCalculationTime;
        uint256 accruedReward;
    }

    mapping(address => StakerInfo) public stakerInfo;

    event TokensStaked(
        address indexed user,
        uint256 amountStaked,
        uint256 timestamp
    );
    event TokensUnstaked(
        address indexed user,
        uint256 amountUnstaked,
        uint256 rewardEarned,
        uint256 timestamp
    );
    event RewardClaimed(address indexed user, uint256 reward);
    event RewardRateUpdated(uint256 newRate);

    constructor(
        address stakedTokenAddress,
        address rewardTokenAddress,
        uint256 initialRewardRate
    ) {
        stakedToken = IToken(stakedTokenAddress);
        rewardToken = ERC20(rewardTokenAddress);
        rewardRatePerMinute = initialRewardRate;
    }

    function stakeTokens(uint256 amount) external {
        require(
            stakedToken.transferFrom(msg.sender, address(this), amount),
            "TransferFailed"
        );

        StakerInfo storage staker = stakerInfo[msg.sender];
        staker.stakedAmount += amount;
        staker.stakingTime = block.timestamp;
        staker.lastRewardCalculationTime = block.timestamp;
        staker.accruedReward += calculateAccruedReward(msg.sender);

        emit TokensStaked(msg.sender, amount, block.timestamp);
    }

    function unstakeTokens(uint256 amount) external {
        StakerInfo storage staker = stakerInfo[msg.sender];
        require(staker.stakedAmount >= amount, "InsufficientStakedTokens");
        require(
            (block.timestamp - staker.stakingTime) >= 300,
            "UnstakeCooldownNotMet"
        );

        staker.accruedReward += calculateAccruedReward(msg.sender);
        staker.stakedAmount -= amount;
        staker.stakingTime = block.timestamp;

        require(stakedToken.transfer(msg.sender, amount), "TransferFailed");

        emit TokensUnstaked(
            msg.sender,
            amount,
            staker.accruedReward,
            block.timestamp
        );
    }

    function getStakedAmount(address user) external view returns (uint256) {
        return stakerInfo[user].stakedAmount;
    }

    function withdrawTokens(uint256 amount) external {
        StakerInfo storage staker = stakerInfo[msg.sender];
        uint256 totalStaked = staker.stakedAmount;
        require(totalStaked >= amount, "InsufficientStakedAmount");

        staker.accruedReward -= amount;

        require(stakedToken.transfer(msg.sender, amount), "TransferFailed");
    }

    function calculateAccruedReward(
        address user
    ) public view returns (uint256) {
        StakerInfo storage staker = stakerInfo[user];
        uint256 stakingDuration = (block.timestamp -
            staker.lastRewardCalculationTime) / 60;
        return
            (staker.stakedAmount * stakingDuration * rewardRatePerMinute) / 100;
    }

    function claimAccruedReward() external {
        StakerInfo storage staker = stakerInfo[msg.sender];
        uint256 reward = staker.accruedReward +
            calculateAccruedReward(msg.sender);
        require(reward > 0, "NoRewardToClaim");

        staker.accruedReward = 0;
        staker.lastRewardCalculationTime = block.timestamp;

        require(
            rewardToken.transfer(msg.sender, reward),
            "RewardTransferFailed"
        );

        emit RewardClaimed(msg.sender, reward);
    }

    function setRewardRate(uint256 newRate) external onlyOwner {
        rewardRatePerMinute = newRate;
        emit RewardRateUpdated(newRate);
    }

    function withdrawEther() external onlyOwner {
        stakedToken.withdrawEther();
        payable(owner()).transfer(address(this).balance);
    }
}
