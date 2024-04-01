//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IStandardToken {
    function transferFrom(
        address _from,
        address _to,
        uint256 value
    ) external returns (bool success);

    function balanceOf(address owner) external view returns (uint256 balance);

    function transfer(
        address _to,
        uint256 _value
    ) external view returns (bool success);

    function withdrawEther() external;
}
