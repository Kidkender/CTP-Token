// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract EvidenceStorage {
    mapping(bytes32 => address) public  evidenceHashToSubmitter;

    event EvidenceSubmitted(address indexed submitter, bytes32 indexed evidenceHash);

    modifier onlySubmitter(bytes32 evidenceHash) {
        require(msg.sender == evidenceHashToSubmitter[evidenceHash], "Not the submmiter");
        _;
    }

    function submitEvidence(bytes32 evidenceHash) external  {
        require(evidenceHashToSubmitter[evidenceHash] == address(0), "Evidence already submitted");
        evidenceHashToSubmitter[evidenceHash] = msg.sender;
        emit EvidenceSubmitted(msg.sender, evidenceHash);
    }

    function retrieveEvidence(bytes32 evidenceHash) external view onlySubmitter(evidenceHash) returns (address) {
        return evidenceHashToSubmitter[evidenceHash];
    }
}