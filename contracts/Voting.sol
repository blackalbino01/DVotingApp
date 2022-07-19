//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ECRecovery.sol";

contract Voting {
  using ECRecovery for bytes32;

  mapping (bytes32 => uint8) public votesReceived;

  mapping(bytes32 => string) public idToCandidate;

  mapping(address => bool) public voterStatus;

  constructor(string[] memory _candidateNames){
    for(uint i = 0; i < _candidateNames.length; i++) {
      bytes32 candidateId = keccak256(abi.encodePacked(_candidateNames[i]));
      idToCandidate[candidateId] = _candidateNames[i];
    }
  }

  function totalVotesFor(bytes32 _candidateId) view external returns (uint8) {
    return votesReceived[_candidateId];
  }

  function voteForCandidate(bytes32 _candidateId, address _voter, bytes memory _signedMessage) external {
    require(!voterStatus[_voter]);

    address recoveredAddress = _candidateId.recover(_signedMessage);

    require(recoveredAddress == _voter);

    votesReceived[_candidateId] += 1;
    voterStatus[_voter] = true;
  }
}

