// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PiggyBank {
    address public owner;

    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        require(msg.value > 0, "Zero deposit not allowed");
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed");
        emit Withdrawn(amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
