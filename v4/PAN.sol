// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Aadhar.sol";

contract PAN is Aadhar {
    struct PANData {
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => PANData) internal mapPANData;

    function setPAN(address _citizenID) external {
        // 567648000 = 18 years
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        require(mapAadharData[msg.sender].verify == true);
        require(
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        );
        mapPANData[_citizenID] = PANData(block.timestamp, msg.sender, true);
    }

    function viewPANData(address _citizenID)
        external
        view
        returns (
            uint256,
            address,
            bool
        )
    {
        return (
            mapPANData[_citizenID].issueDate,
            mapPANData[_citizenID].issuedBy,
            mapPANData[_citizenID].verify
        );
    }

    function verifyPANData(address _citizenID) public view returns (bool) {
        return (mapPANData[_citizenID].verify);
    }

    function removePANData(address _citizenID) external {
        require(mapPANData[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapPANData[_citizenID].verify = false;
    }

    function loginPAN(address _citizenID) external view returns (bool) {
        require(
            msg.sender == _citizenID && mapPANData[msg.sender].verify == true
        );
        return (mapPANData[_citizenID].verify);
    }
}
