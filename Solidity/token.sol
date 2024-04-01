// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DANI {
    string _name;
    string _symbol;
    uint constant DECIMAL = 18;
    uint _totalSupply;

    mapping (address => uint) _balance;
    
    // owner => spender => value
    mapping (address => mapping (address => uint)) _allowance;

    event Transfer(address from, address to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event Minted(address to, uint value);

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimal() public pure returns (uint) {
        return DECIMAL;
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint) {
        return _balance[_owner];
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        require(_to != address(0), "transfer to address ZERO not allowed");
        require(_value > 0, "increase value");
        require(balanceOf(msg.sender) >= _value, "insufficient funds");
        _balance[msg.sender] -= _value;
        _balance[_to] += _value;
        success = true;
        emit Transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_to != address(0), "transfer to address ZERO not allowed");
        require(_value > 0, "increase value");
        require(balanceOf(_from) >= _value, "insufficient funds");
        require(allowance(_from, _to) >= _value, "insufficient allowance");
        // require(allowance(_from, msg.sender) >= _value, "insufficient allowance"); flawed
        _allowance[_from][_to] -= _value;
        _balance[_from] -= _value;
        _balance[_to] += _value;
        success = true;
        emit Transfer(_from, _to, _value);
    }

    function approve(address _spender, uint _value) public returns (bool success){
        _allowance[msg.sender][_spender] = _value;
        success = true;
        emit Approval(msg.sender, _spender, _value);
    }

    function allowance(address _owner, address _spender) public view returns (uint){
        return _allowance[_owner][_spender]; 
    }

    function mint() external payable {
        require(msg.sender != address(0), "transfer to address ZERO not allowed");
        require(msg.value >= 5e18, "insufficient ETH");
        uint token = msg.value / 5e18;
        _balance[msg.sender] += token;
        _totalSupply += token;
        emit Minted(msg.sender, token);
    }
    
    function deposit(uint amount) public payable returns (bool) {
        if (msg.value >= amount * 5e18) {
            return true;
        } else return false;
    }

    // function withdraw() external  {
    //     //get amount of ether stored in this contract
    //     uint amount = address(this).balance;

    //     (bool success, ) = msg.sender.call{value: amount}("");
    //     require(success, "Failed to send ethers");
    // }

    function burn(uint value, address receiver) external{
        require(balanceOf(msg.sender) >= value, "insufficient funds");
        uint tenPercent = 10 * value / 100;
        uint ninetyPercent = 90 * value / 100;
        _balance[msg.sender] -= value;
        _totalSupply -= ninetyPercent;
        transfer(receiver, tenPercent);
        emit Minted(msg.sender, 90 * value / 100);
    }
}

