//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;
import {Transaction} from "../multisig.sol";

interface IMultisig {
    function createTransaction(uint _amount, address _spender) external;

    function approveTransaction(uint id) external;

    function calculateMinimumApproval() external view returns (uint MinApp);

    function getTransaction(uint id) external view returns (Transaction memory);
}
