// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    // Structure to represent a voter
    struct Voter {
        uint256 weight; // Voting weight (1 if eligible)
        bool voted; // Has the voter already voted?
        address delegate; // Address of delegate
        uint256 vote; // Index of voted proposal
    }

    // Structure to represent a proposal
    struct Proposal {
        string name; // Proposal name
        uint256 voteCount; // Number of votes received
    }

    address public chairperson; // Address of the contract creator (admin)
    mapping(address => Voter) public voters; // Mapping of voter addresses

    Proposal[] public proposals; // List of proposals

    uint256 private winningProposalIndex; // Tracks the current winning proposal

    event Voted(address indexed voter, uint256 proposal); // Event emitted when a vote is cast

    /**
     * @dev Constructor initializes proposals and assigns chairperson role.
     * @param proposalNames Array of proposal names.
     */
    constructor(string[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1; // Chairperson gets initial voting right

        // Initialize proposals
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    /**
     * @dev Grants voting rights to an address. Can only be called by the chairperson.
     * @param voter Address of the voter.
     */
    function giveRightToVote(address voter) external {
        require(
            msg.sender == chairperson,
            "Only chairperson can grant voting rights."
        );
        require(!voters[voter].voted, "Voter has already voted.");
        require(voters[voter].weight == 0, "Voter already has the right.");

        voters[voter].weight = 1; // Assign voting weight
    }

    /**
     * @dev Delegates voting power to another voter.
     * @param to Address of the delegate.
     */
    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "No voting rights.");
        require(!sender.voted, "Already voted.");
        require(to != msg.sender, "Cannot delegate to yourself.");

        // Loop to prevent delegation cycles
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Delegation cycle detected.");
        }

        Voter storage delegate_ = voters[to];
        require(delegate_.weight >= 1, "Delegate has no voting rights.");

        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            // If delegate has already voted, add sender's weight to the chosen proposal
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // Otherwise, transfer voting weight
            delegate_.weight += sender.weight;
        }
    }

    /**
     * @dev Allows a voter to cast their vote.
     * @param proposal Index of the chosen proposal.
     */
    function vote(uint256 proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "No voting rights.");
        require(!sender.voted, "Already voted.");
        require(proposal < proposals.length, "Invalid proposal index.");

        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;

        emit Voted(msg.sender, proposal);

        // Update winning proposal index
        if (
            proposals[proposal].voteCount >
            proposals[winningProposalIndex].voteCount
        ) {
            winningProposalIndex = proposal;
        }
    }

    /**
     * @dev Returns the index of the winning proposal.
     */
    function winningProposal() public view returns (uint256) {
        return winningProposalIndex;
    }

    /**
     * @dev Returns the name of the winning proposal.
     */
    function winnerName() external view returns (string memory) {
        return proposals[winningProposal()].name;
    }
}

    /*
    VGhlIHNlZWtlciBvZiB0cnV0aCB3aWxsIGZpbmQgbWUuIOKcoA0K
    SW4gdGhlIHJlYWxtIG9mIHRoZSB1bmtub3duLCBvbmx5IHRoZSBz
    ZWVrZXJzIHdpbGwgZmluZCB0aGVpciBwYXRoLiBZb3UgYXJlIG9u
    ZSBvZiB0aGVtLg0KRW1hZCBTYWhlYml
    */

