# Voting Smart Contract

This project implements a **secure and decentralized voting system** using Solidity. The smart contract allows voters to cast their votes, delegate voting rights, and determine the winning proposal in a fair and transparent manner.

## Features
- 🗳 **Voting Mechanism**: Users can vote on predefined proposals.
- 👥 **Delegation**: Voters can delegate their voting rights to others.
- 🔒 **Secure & Fair**: Prevents double voting and ensures fair elections.
- 📊 **Result Calculation**: The contract tracks and determines the winning proposal.

## Smart Contract Details
- **Language**: Solidity `^0.8.24`
- **License**: MIT
- **Key Functions**:
  - `giveRightToVote(address voter)`: Grants voting rights.
  - `delegate(address to)`: Delegates voting power.
  - `vote(uint256 proposal)`: Casts a vote for a proposal.
  - `winningProposal()`: Returns the index of the winning proposal.
  - `winnerName()`: Returns the name of the winning proposal.

## Installation & Deployment
To deploy and test the contract:

1. Clone the repository:
   ```sh
   git clone https://github.com/YOUR_GITHUB_USERNAME/Voting.git
   cd Voting
