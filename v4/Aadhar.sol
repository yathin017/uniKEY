// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Biometrics.sol";

contract Aadhar is Contact, Biometrics {
    struct AadharData {
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => AadharData) internal mapAadharData;

    function setAadhar(address _citizenID) external {
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        require(mapBirthCertificate[_citizenID].verify == true);
        require(mapContactData[_citizenID].verify == true);
        require(verifyBiometrics(_citizenID) == true);
        mapAadharData[_citizenID] = AadharData(
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewAadharData(address _citizenID)
        external
        view
        returns (
            uint256,
            address,
            bool
        )
    {
        return (
            mapAadharData[_citizenID].issueDate,
            mapAadharData[_citizenID].issuedBy,
            mapAadharData[_citizenID].verify
        );
    }

    function verifyAadharData(address _citizenID) public view returns (bool) {
        return (mapAadharData[_citizenID].verify);
    }

    function removeAadharData(address _citizenID) external {
        require(mapAadharData[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapAadharData[_citizenID].verify = false;
    }

    function loginAadhar(address _citizenID) external view returns (bool) {
        require(
            msg.sender == _citizenID && mapAadharData[msg.sender].verify == true
        );
        return (mapAadharData[_citizenID].verify);
    }
}
