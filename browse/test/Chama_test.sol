// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "../contracts/Chama.sol";

contract ChamaTest {
    SimpleChama chama;

    function beforeAll() public payable {
        chama = new SimpleChama();
    }

    function testInitialChairperson() public {
        Assert.equal(chama.chairperson(), address(this), "Chairperson should be the deployer");
    }

    /// #value: 1 ether
    function testDeposit() public payable {
        chama.deposit{value: 1 ether}();
        Assert.equal(chama.balances(address(this)), 1 ether, "Balance should be 1 ETH");
    }

    function testTotalFunds() public {
        Assert.equal(chama.getChamaBalance(), 1 ether, "Total funds should be 1 ETH");
    }

    function testWithdrawal() public {
        uint256 preBalance = address(this).balance;
        chama.withdraw(0.5 ether);
        Assert.equal(chama.balances(address(this)), 0.5 ether, "Balance should be 0.5 ETH after withdrawal");
        Assert.ok(address(this).balance > preBalance, "Contract should have received ETH");
    }

    receive() external payable {}

    function testFailDepositZero() public {
        try chama.deposit{value: 0}() {
            Assert.ok(false, "Should have reverted on 0 deposit");
        } catch Error(string memory reason) {
            Assert.equal(reason, "You must deposit some ETH", "Wrong revert reason");
        }
    }

    function testFailOverWithdraw() public {
        try chama.withdraw(10 ether) {
            Assert.ok(false, "Should have reverted for over-withdrawing");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Insufficient balance in your account", "Wrong revert reason");
        }
    }
}