// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleChama {
    address public chairperson;
    mapping(address => uint256) public balances;
    uint256 public totalFunds;

    // Events help the frontend/client "listen" to what happened on-chain
    event DepositMade(address indexed member, uint256 amount);
    event WithdrawalMade(address indexed member, uint256 amount);

    constructor() {
        // The person who deploys the contract becomes the chairperson
        chairperson = msg.sender;
    }

    // Function to save money into the Chama
    function deposit() public payable {
        require(msg.value > 0, "You must deposit some ETH");
        
        balances[msg.sender] += msg.value;
        totalFunds += msg.value;

        emit DepositMade(msg.sender, msg.value);
    }

    // Function to withdraw your own personal savings
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance in your account");
        
        balances[msg.sender] -= _amount;
        totalFunds -= _amount;
        
        // Transfer the actual ETH back to the user
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed");

        emit WithdrawalMade(msg.sender, _amount);
    }


    // View function to check group total (doesn't cost gas)
    function getChamaBalance() public view returns (uint256) {
        return totalFunds;
    }
}