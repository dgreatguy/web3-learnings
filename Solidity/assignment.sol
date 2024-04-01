// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract BioForm {

    enum Status { Pending, Filled }

    struct FamilyBio {
        string name;
        string relation;
        uint phoneNo;
    }

    struct Bio {
        uint age;
        uint year;
        string fullName;
        mapping(uint => FamilyBio) family;
    }

    struct Record {
        uint id;
        string school;
        Bio bio;
        Status bioStatus;
    }

    mapping(uint => Record) private records;

    function setFamilyInfo(uint _recordId, uint _familyMemberId, string memory _name, string memory _relation, uint _phoneNo) public {
        Record storage record = records[_recordId];
        record.bio.family[_familyMemberId] = FamilyBio(_name, _relation, _phoneNo);
    }

    function getFamilyInfo(uint _recordId, uint _familyMemberId) public view returns (string memory, string memory, uint) {
        return (
            records[_recordId].bio.family[_familyMemberId].name,
            records[_recordId].bio.family[_familyMemberId].relation,
            records[_recordId].bio.family[_familyMemberId].phoneNo
        );
    }
}
