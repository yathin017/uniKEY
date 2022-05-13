// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Biometrics.sol";

contract Aadhar is Biometrics {
    struct AadharData {
        uint256 enrollmentNumber;
        uint256 aadharNumber;
        uint256 VID;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => AadharData) public mapAadharData;

    function setAadhar(
        address _citizenID,
        uint256 _enrolmentNumber,
        uint256 _aadharNumber,
        uint256 _VID
    ) public {
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        require(mapBirthCertificate[_citizenID].verify == true);
        require(mapContactData[_citizenID].verify == true);
        require(verifyBiometrics(_citizenID) == true);
        mapAadharData[_citizenID] = AadharData(
            _enrolmentNumber,
            _aadharNumber,
            _VID,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewAadhar(address _citizenID)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            address,
            bool
        )
    {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            _citizenID == msg.sender ||
                mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0
        );
        return (
            mapAadharData[_citizenID].enrollmentNumber,
            mapAadharData[_citizenID].aadharNumber,
            mapAadharData[_citizenID].VID,
            mapAadharData[_citizenID].issueDate,
            mapAadharData[_citizenID].issuedBy,
            verifyAadhar(_citizenID)
        );
    }

    function verifyAadhar(address _citizenID) public view returns (bool) {
        if (verifyBiometrics(_citizenID) == true) {
            return (mapAadharData[_citizenID].verify);
        } else {
            return (false);
        }
    }
}
