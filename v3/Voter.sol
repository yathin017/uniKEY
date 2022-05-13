// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Aadhar.sol";

contract Voter is Aadhar {
    struct VoterData {
        string referenceNumber;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => VoterData) private mapVoterData;

    function setVoterID(address _citizenID, string memory _referenceNumber)
        public
    {
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
        );
        require(block.timestamp - ageBirthCertificate(_citizenID) >= 567648000);
        require(verifyAadharData(_citizenID) == true);
        mapVoterData[_citizenID] = VoterData(
            _referenceNumber,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewVoterData(address _citizenID)
        public
        view
        returns (string memory)
    {
        require(verifyBirthCertificate(_citizenID) == true);
        require(
            _citizenID == msg.sender ||
                verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
        );
        return (mapVoterData[_citizenID].referenceNumber);
    }

    function verifyVoterData(address _citizenID) public view returns (bool) {
        return (mapVoterData[_citizenID].verify);
    }

    function setterVoterData(address _citizenID)
        public
        view
        returns (uint256, address)
    {
        return (
            mapVoterData[_citizenID].issueDate,
            mapVoterData[_citizenID].issuedBy
        );
    }
}
