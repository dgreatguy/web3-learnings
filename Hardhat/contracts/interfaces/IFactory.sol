//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;
import "./IMultisig.sol";

interface IFactory {
    function createMultiSig(address[] memory _admins) external payable returns (IMultisig newMultisig);
}