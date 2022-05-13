// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Aadhar.sol";

contract Voter is Aadhar {
    struct VoterData {
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => VoterData) internal mapVoterData;

    function setVoterID(address _citizenID) external {
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        require(
            block.timestamp - mapBirthCertificate[msg.sender].DOB >= 567648000
        );
        require(verifyAadharData(_citizenID) == true);
        mapVoterData[_citizenID] = VoterData(block.timestamp, msg.sender, true);
    }

    function viewVoterData(address _citizenID)
        external
        view
        returns (
            uint256,
            address,
            bool
        )
    {
        return (
            mapVoterData[_citizenID].issueDate,
            mapVoterData[_citizenID].issuedBy,
            mapVoterData[_citizenID].verify
        );
    }

    function verifyVoterData(address _citizenID) public view returns (bool) {
        return (mapVoterData[_citizenID].verify);
    }

    function removeVoterData(address _citizenID) external {
        require(mapVoterData[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapVoterData[_citizenID].verify = false;
    }
}
