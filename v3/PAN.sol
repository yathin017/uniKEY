// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Aadhar.sol";

contract PAN is Aadhar {
    struct PANData {
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => PANData) private mapPANData;

    function setPAN(address _citizenID) public {
        // 567648000 = 18 years
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
        );
        require(verifyAadharData(_citizenID) == true);
        require(block.timestamp - ageBirthCertificate(_citizenID) >= 567648000);
        mapPANData[_citizenID] = PANData(block.timestamp, msg.sender, true);
    }

    function verifyPANData(address _citizenID) public view returns (bool) {
        require(verifyAadharData(_citizenID) == true);
        return (mapPANData[_citizenID].verify);
    }

    function setterPANData(address _citizenID)
        public
        view
        returns (uint256, address)
    {
        return (
            mapPANData[_citizenID].issueDate,
            mapPANData[_citizenID].issuedBy
        );
    }

    function removePANData(address _citizenID) public {
        require(mapPANData[_citizenID].verify == true);
        require(verifyGovernmentWorker(msg.sender) == true);
        mapPANData[_citizenID].verify = false;
    }

    function loginPAN(address _citizenID) public view returns (bool) {
        require(_citizenID == msg.sender);
        return (mapPANData[_citizenID].verify);
    }
}
