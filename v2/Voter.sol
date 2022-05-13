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
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        require(
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        );
        require(mapAadharData[_citizenID].verify == true);
        mapVoterData[_citizenID] = VoterData(
            _referenceNumber,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewVoterID(address _citizenID)
        public
        view
        returns (
            string memory,
            uint256,
            address
        )
    {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            _citizenID == msg.sender ||
                mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0
        );
        return (
            mapVoterData[_citizenID].referenceNumber,
            mapVoterData[_citizenID].issueDate,
            mapVoterData[_citizenID].issuedBy
        );
    }

    function verifyVoterID(address _citizenID) public view returns (bool) {
        return (mapVoterData[_citizenID].verify);
    }
}
