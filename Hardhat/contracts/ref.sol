// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CPPMMarket is Ownable {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public constant k = 10 ** 18; // Initial constant product, adjust as needed

    uint256 public totalSupply;
    mapping(address => uint256) public balancesA;
    mapping(address => uint256) public balancesB;

    event TokensSwapped(address indexed user, uint256 amountA, uint256 amountB);
    event LiquidityProvided(
        address indexed user,
        uint256 amountA,
        uint256 amountB
    );
    event LiquidityWithdrawn(
        address indexed user,
        uint256 amountA,
        uint256 amountB
    );

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // Calculate the number of tokens B that will be received for a given amount of tokens A
    function getAmountOut(uint256 amountA) public view returns (uint256) {
        return
            (k * balancesB[msg.sender] - k * totalSupply) /
            (k + balancesA[msg.sender] + amountA) -
            balancesB[msg.sender];
    }

    // Calculate the number of tokens A that will be received for a given amount of tokens B
    function getAmountIn(uint256 amountB) public view returns (uint256) {
        return
            (k * balancesA[msg.sender] - k * totalSupply) /
            (k + balancesB[msg.sender] + amountB) -
            balancesA[msg.sender];
    }

    // Swap tokens A for tokens B
    function swapAToB(uint256 amountA) external {
        uint256 amountB = getAmountOut(amountA);
        require(amountB > 0, "Insufficient output amount");
        require(
            tokenA.transferFrom(msg.sender, address(this), amountA),
            "Transfer of tokenA failed"
        );
        balancesA[msg.sender] += amountA;
        balancesB[msg.sender] -= amountB;
        totalSupply += amountA;
        emit TokensSwapped(msg.sender, amountA, amountB);
    }

    // Swap tokens B for tokens A
    function swapBToA(uint256 amountB) external {
        uint256 amountA = getAmountIn(amountB);
        require(amountA > 0, "Insufficient input amount");
        require(
            tokenB.transferFrom(msg.sender, address(this), amountB),
            "Transfer of tokenB failed"
        );
        balancesB[msg.sender] += amountB;
        balancesA[msg.sender] -= amountA;
        totalSupply += amountB;
        emit TokensSwapped(msg.sender, amountA, amountB);
    }

    // Provide liquidity to the pool
    function provideLiquidity(uint256 amountA, uint256 amountB) external {
        require(
            tokenA.transferFrom(msg.sender, address(this), amountA),
            "Transfer of tokenA failed"
        );
        require(
            tokenB.transferFrom(msg.sender, address(this), amountB),
            "Transfer of tokenB failed"
        );
        balancesA[msg.sender] += amountA;
        balancesB[msg.sender] += amountB;
        totalSupply += amountA;
        emit LiquidityProvided(msg.sender, amountA, amountB);
    }

    // Withdraw liquidity from the pool
    function withdrawLiquidity(uint256 amountA, uint256 amountB) external {
        require(
            balancesA[msg.sender] >= amountA,
            "Insufficient balance of tokenA"
        );
        require(
            balancesB[msg.sender] >= amountB,
            "Insufficient balance of tokenB"
        );
        balancesA[msg.sender] -= amountA;
        balancesB[msg.sender] -= amountB;
        totalSupply -= amountA;
        require(
            tokenA.transfer(msg.sender, amountA),
            "Withdrawal of tokenA failed"
        );
        require(
            tokenB.transfer(msg.sender, amountB),
            "Withdrawal of tokenB failed"
        );
        emit LiquidityWithdrawn(msg.sender, amountA, amountB);
    }

    // View function to get the current balance of token A for a user
    function getBalanceA(address user) external view returns (uint256) {
        return balancesA[user];
    }

    // View function to get the current balance of token B for a user
    function getBalanceB(address user) external view returns (uint256) {
        return balancesB[user];
    }
}
