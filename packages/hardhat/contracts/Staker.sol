// SPDX-License-Identifier: MIT
pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
	// Variables go here
	uint256 public constant threshold = 1 ether;
	uint256 public deadline = block.timestamp + 72 hours; // 30 seconds
	ExampleExternalContract public exampleExternalContract;
	mapping(address => uint256) public balances;
	bool public openForWithdraw;
	bool public openForExecute;

	// Events go here
	event Stake(address indexed staker, uint256 amount);
	event Message(string message);

	constructor(address exampleExternalContractAddress) {
		exampleExternalContract = ExampleExternalContract(
			exampleExternalContractAddress
		);
	}

	// Modifiers functions go here
	modifier notCompleted() {
		require(
			!exampleExternalContract.completed(),
			"Staker: Staking completed"
		);
		_;
	}

	// Functions go here

	// Collect funds in a payable `stake()` function and track individual `balances`
	// with a mapping:
	// (Make sure to add a `Stake(address,uint256)` event and emit it for the
	// frontend `All Stakings` tab to display)

	function stake() public payable notCompleted {
		// Add the `stake()` function to the `stake()` function in the `ExampleExternalContract` and call it here
		require(
			block.timestamp < deadline,
			"Staker: You can't stake the deadline was passed"
		);
		require(msg.value > 0, "Staker: Cannot stake 0 ETH");
		balances[msg.sender] += msg.value;
		emit Stake(msg.sender, msg.value);
	}

	// After some `deadline` allow anyone to call an `execute()` function
	// If the deadline has passed and the threshold is met, it should call
	// `exampleExternalContract.complete{value: address(this).balance}()`

	function execute() public notCompleted {
		require(block.timestamp > deadline, "Staker: Deadline hasn't passed");
		require(!openForExecute, "Staker: Execute already called");

		// If the `threshold` was not met, allow everyone to call a `withdraw()`
		// function to withdraw their balance
		if (address(this).balance >= threshold) {
			exampleExternalContract.complete{ value: address(this).balance }();
		} else {
			openForWithdraw = true;
		}
		openForExecute = true;
	}

	function withdraw() public notCompleted {
		require(block.timestamp > deadline, "Staker: Deadline hasn't passed");
		require(
			address(this).balance <= threshold,
			"Staker: The goal was met, you can't withdraw your funds"
		);
		require(
			balances[msg.sender] > 0,
			"Staker: You don't have funds to withdraw"
		);

		if (openForWithdraw == false) {
			execute();
		}

		if (openForWithdraw == true && balances[msg.sender] > 0) {
			address payable recipient = payable(msg.sender);
			recipient.transfer(balances[msg.sender]);
			balances[msg.sender] = 0;
		}
	}

	// Add a `timeLeft()` view function that returns the time left before the deadline
	// for the frontend

	function timeLeft() public view returns (uint256) {
		if (block.timestamp >= deadline) {
			return 0;
		} else {
			return deadline - block.timestamp;
		}
	}

	// Add the `receive()` special function that receives eth and calls stake()}

	receive() external payable {
		stake();
	}
}
