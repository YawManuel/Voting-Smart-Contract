// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Voting {
    mapping(uint => Candidate) public candidates; // The list of candidates.
    uint public candidateCount; // Keep track of the number of candidates

    address public votingperson; // The votingperson of the voting.

    uint public startTime; // The start time of the voting.

    uint public endTime; // The end time of the voting.

    // The winning candidate.
    uint public winningCandidate;
    uint public winningVoteCount;

    struct Candidate {
        string name;
        string description;
        uint voteCount;
        mapping(address => bool) voters;
    }

    // The constructor.
    constructor(
        address votingperson_,
        uint startTime_,
        uint endTime_
    ) {
        votingperson = votingperson_;
        startTime = startTime_;
        endTime = endTime_;
    }

    // Add a candidate.
    function addCandidate(string memory name, string memory description) public {
        require(msg.sender == votingperson, "Only the votingperson can vote candidates");

        uint256 candidateId = candidateCount; // Use candidateCount as the candidate ID

        // Initialize the candidate
        candidates[candidateId].name = name;
        candidates[candidateId].description = description;
        candidates[candidateId].voteCount = 0;

        candidateCount++; // Increment the candidate count
    }

    // Vote for a candidate.
    function vote(uint candidateId) public {
        require(block.timestamp >= startTime && block.timestamp <= endTime,
            "Voting is not open"
        );
        require(candidateId < candidateCount, "Invalid candidate ID");

        Candidate storage candidate = candidates[candidateId];
        require(!candidate.voters[msg.sender], "You have already voted for this candidate");

        candidate.voters[msg.sender] = true;
        candidate.voteCount++;

        if (candidate.voteCount > winningVoteCount) {
            winningVoteCount = candidate.voteCount;
            winningCandidate = candidateId;
        }
    }

    // Get the winning candidate.
    function getWinningCandidate() public view returns (uint) {
        return winningCandidate;
    }
}
