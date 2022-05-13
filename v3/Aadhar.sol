// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Biometrics.sol";

contract Aadhar is Contact, Biometrics {
    struct AadharData {
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => AadharData) private mapAadharData;

    function setAadhar(address _citizenID) public {
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
        );
        require(verifyBirthCertificate(_citizenID) == true);
        require(verifyContactData(_citizenID) == true);
        require(verifyBiometrics(_citizenID) == true);
        mapAadharData[_citizenID] = AadharData(
            block.timestamp,
            msg.sender,
            true
        );
    }

    function verifyAadharData(address _citizenID) public view returns (bool) {
        if (verifyBiometrics(_citizenID) == true) {
            return (mapAadharData[_citizenID].verify);
        } else {
            return (false);
        }
    }

    function setterAadharData(address _citizenID)
        public
        view
        returns (uint256, address)
    {
        return (
            mapAadharData[_citizenID].issueDate,
            mapAadharData[_citizenID].issuedBy
        );
    }

    function removeAadharData(address _citizenID) public {
        require(mapAadharData[_citizenID].verify == true);
        require(verifyGovernmentWorker(msg.sender) == true);
        mapAadharData[_citizenID].verify = false;
    }

    function loginAadhar(address _citizenID) public view returns (bool) {
        require(_citizenID == msg.sender);
        return (mapAadharData[_citizenID].verify);
    }
}
