//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

// a multisig Wallet
// contract should accept ether
// array of signatories
// approving transaction
// mapping address to bool for valid Admins
//mapping uint => address => bool  to track approval of each admin on each transaction
// transaction Detail

struct Transaction {
        address spender;
        uint amount;
        uint numberOfApproval;
        bool isActive;
    }
    
contract MultiSig {

    address[] Admins;
    uint constant MINIMUM = 3;
    uint transactionId;

    mapping(address => bool) isAdmin;
    mapping(uint => Transaction) transaction;
    mapping(uint => mapping(address => bool)) hasApproved;

    error InvalidAddress(uint position);
    error InvalidAdminNo(uint number);
    error Duplicate(address addr);

    event Create(address who, address spender, uint amount);

    // fallback() external payable {}

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Not a valid admin");
        _;
    }

    constructor(address[] memory _admins) payable {
        if (_admins.length < MINIMUM) {
            revert InvalidAdminNo(MINIMUM);
        }
        for (uint i = 0; i < _admins.length; i++) {
            if (_admins[i] == address(0)) {
                revert InvalidAddress(i + 1); //to return position, not number, and account for index
            }
            if (isAdmin[_admins[i]]) {
                revert Duplicate(_admins[i]); //to prevent duplicate admin
            }
            isAdmin[_admins[i]] = true;
        }
        Admins = _admins;
    }

    function createTransaction(
        uint _amount,
        address _spender
    ) external onlyAdmin {
        transactionId++;
        Transaction storage _transaction = transaction[transactionId];
        _transaction.amount = _amount;
        _transaction.spender = _spender;
        _transaction.isActive = true;
        emit Create(msg.sender, _spender, _amount);
        approveTransaction(transactionId);
    }

    function approveTransaction(uint id) public onlyAdmin {
        //check if admon has not approved yet
        require(!hasApproved[id][msg.sender], "Already approved!");
        hasApproved[id][msg.sender] = true;

        Transaction storage _transaction = transaction[id];

        require(_transaction.isActive, "Not active");

        _transaction.numberOfApproval += 1;
        uint count = _transaction.numberOfApproval;
        uint MinApp = calculateMinimumApproval();
        if (count > MinApp) {
            sendTransaction(id);
        }
    }

    function sendTransaction(uint id) internal {
        Transaction storage _transaction = transaction[id];
        payable(_transaction.spender).transfer(_transaction.amount);
        _transaction.isActive = false;
    }

    function calculateMinimumApproval() public view returns (uint MinApp) {
        uint size = Admins.length;
        MinApp = (size * 70) / 100;
    }

    function getTransaction(
        uint id
    ) external view returns (Transaction memory) {
        return transaction[id];
    }

    receive() external payable {}
}
