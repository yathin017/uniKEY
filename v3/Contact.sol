// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract Contact is Identity {
    struct ContactData {
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => ContactData) private mapContactData;

    function setContactData(address _citizenID) public {
        require(verifyBirthCertificate(msg.sender) == true);
        require(verifyGovernmentWorker(msg.sender) == true);
        mapContactData[_citizenID] = ContactData(
            block.timestamp,
            msg.sender,
            true
        );
    }

    function verifyContactData(address _citizenID) public view returns (bool) {
        return (mapContactData[_citizenID].verify);
    }

    function setterContactData(address _citizenID)
        public
        view
        returns (uint256, address)
    {
        return (
            mapContactData[_citizenID].issueDate,
            mapContactData[_citizenID].issuedBy
        );
    }

    function removeContactData(address _citizenID) public {
        require(mapContactData[_citizenID].verify == true);
        require(verifyGovernmentWorker(msg.sender) == true);
        mapContactData[_citizenID].verify = false;
    }

    function loginContact(address _citizenID) public view returns (bool) {
        require(_citizenID == msg.sender);
        return (mapContactData[_citizenID].verify);
    }
}
