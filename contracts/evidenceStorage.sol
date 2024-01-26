// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract EvidenceStorage {

    struct Evidence {
        address submitter;
        uint256 timestamp;
    }
    
    mapping(bytes32 => Evidence) public evidences;


    event EvidenceSubmitted(address indexed submitter, bytes32 indexed evidenceHash, uint256 timestamp);

    modifier onlySubmitter(bytes32 evidenceHash) {
        require(msg.sender == evidences[evidenceHash].submitter, "Not the submmiter");
        _;
    }

    function submitEvidence(bytes32 evidenceHash) external  {
        require(evidences[evidenceHash].submitter == address(0), "Evidence already submitted.");        
        evidences[evidenceHash] = Evidence(msg.sender, block.timestamp);
        emit EvidenceSubmitted(msg.sender, evidenceHash, block.timestamp);
    }

    function retrieveEvidence(bytes32 evidenceHash) external view onlySubmitter(evidenceHash) returns (address, uint256) {
        Evidence memory evidence = evidences[evidenceHash];
        return (evidence.submitter, evidence.timestamp);
    }
}