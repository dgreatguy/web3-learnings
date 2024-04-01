//SPDX-License-Identifier: MIT
// To overcome this challenge, append your name to the array of champions.
pragma solidity ^0.8.20;
import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract StandardToken is ERC20{
    constructor() ERC20("na", "sy"){
        _mint(address(this),1_000e8);
    }
// 20000e18
    uint ExpectedAmount = 20_000 ether; 
    uint precision = 1e20;

     function decimals() public view override returns (uint8) {
        return 8;
    }

    function buyToken() external  payable returns(uint){
        uint _exchange = exchange();
        uint amount = (msg.value * _exchange) / precision;
    _transfer(address(this), msg.sender, amount);

    }
    function exchange() public view returns(uint TokenValue){
        uint _prec = 1000e8 * precision;
        TokenValue = (_prec / ExpectedAmount);      
    
    }

    function returnBalance() external view returns(uint etherbalance, uint tokenBalance){
        etherbalance = address(this).balance;
        tokenBalance = balanceOf(address(this));
    }

    function withdrawEther() external {
        // payable(msg.sender).transfer(address(this).balance);
      (bool success,) =  payable(msg.sender).call{value: address(this).balance}("");
      require(success, "transferFailed");
    }

}