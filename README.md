# Staker Solidity Smart Contract
This repository contains the Staker.sol smart contract written in Solidity, as part of 🚩 Challenge 1: 🔏 Decentralized Staking App from speedrunethereum.com. The frontend was already built beforehand, and this repository focuses on the implementation of the staking logic in the Staker.sol contract.

## Description
The Staker.sol smart contract allows users to send ETH for staking and tracks each participant's balance. The following features have been implemented:

- **Staking**: Users can stake ETH, and their balances are stored in a mapping of addresses to amounts.
- **Execution**: If the threshold of 0.02 ETH is reached before the deadline, the contract executes the complete() function of the ExampleExternalContract. If the threshold is not met, participants can withdraw their funds.
- **Withdrawal**: Users can withdraw their funds if the threshold is not reached by the deadline.
- **Time Left**: The contract provides a function that displays the remaining time before the staking deadline.
- **ETH Reception**: The contract can receive ETH directly and automatically add it to the sender's staking balance.

## Technologies Used
- **Solidity v0.8.4**: Used to write the smart contract.
- **Hardhat**: Framework for developing, testing, and deploying smart contracts.
- **ExampleExternalContract.sol**: An external contract that interacts with Staker.sol.

## Installation
1. Clone the repository:
```
git clone https://github.com/LouDriu/staker-solidity.git
```
2. Install the dependencies:
```
npm install
```
3. Compile the contracts:
```
npx hardhat compile
```
4. Deploy the contract on a local development network or a test network:
```
npx hardhat run scripts/deploy.js
```
## Main Contract Functions
1. stake()
Allows users to stake ETH. The funds are added to the sender's balance, and a Stake event is emitted.
```
function stake() public payable
```
2. execute()
After the deadline, anyone can call this function. If the threshold is met, the funds are transferred to ExampleExternalContract. If not, users can withdraw their funds.
```
function execute() public
```
3. withdrawn()
Allows users to withdraw their funds if the threshold was not met.
```
function withdraw() public
```
4. timeLeft()
Returns the time remaining before the staking deadline.
```
function timeLeft() public view returns (uint256)
```
5. receive()
Allows the contract to receive ETH and automatically calls the stake() function.
```
receive() external payable
```
## Credits
This project is part of the 🚩 Challenge 1: 🔏 Decentralized Staking App from speedrunethereum.com.

## License
This project is licensed under the MIT License.