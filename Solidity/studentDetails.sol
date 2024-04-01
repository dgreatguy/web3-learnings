//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// a record of students in the uni
//allows only principal to admit, expel

contract studentDetails {
    address public principal;
    address public Deployer;

    struct Student {
        string name;
        uint age;
        string gender;
    }

    uint id;

    mapping(uint => Student) public _student;

    event Admitted(string _name, string _gender, uint _age, uint id);

    constructor(address _prin) {
        principal = _prin;
        Deployer = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == principal, "Not Principal");
        _;
    }

    function admitStudent(
        string memory _name,
        string memory _gender,
        uint _age
    ) external onlyOwner {
        id = id + 1;
        // uint _id = id;

        Student storage newStudent = _student[id];
        newStudent.name = _name;
        newStudent.age = _age;
        newStudent.gender = _gender;

        emit Admitted(_name, _gender, _age, id);
    }

    function expel(uint _id) external onlyOwner {
        delete _student[_id];
    }

    function getStudentDetails(
        uint _id
    ) external view returns (Student memory _stud) {
        _stud = _student[_id];
    }
}
