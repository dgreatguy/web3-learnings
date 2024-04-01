//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./studentDetails.sol";

contract studentDetailsFactory {
    studentDetails[] public Details;

    function createStudentDetails()
        external
        returns (studentDetails newDetails)
    {
        // create a new contract and assign newDetails to the contract address
        newDetails = new studentDetails(msg.sender);
        newDetails.admitStudent("ayo", "male", 30);
        newDetails.getStudentDetails(1);
        // push the newDetails to state
        Details.push(newDetails);
    }
}
