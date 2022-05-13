// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract Contact is Identity {
    struct ContactData {
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => ContactData) internal mapContactData;

    function setContactData(address _citizenID) external {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapContactData[_citizenID] = ContactData(
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewContactData(address _citizenID)
        external
        view
        returns (
            uint256,
            address,
            bool
        )
    {
        return (
            mapContactData[_citizenID].issueDate,
            mapContactData[_citizenID].issuedBy,
            mapContactData[_citizenID].verify
        );
    }

    function verifyContactData(address _citizenID) public view returns (bool) {
        return (mapContactData[_citizenID].verify);
    }

    function removeContactData(address _citizenID) external {
        require(mapContactData[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapContactData[_citizenID].verify = false;
    }

    function loginContact(address _citizenID) external view returns (bool) {
        require(
            msg.sender == _citizenID &&
                mapContactData[_citizenID].verify == true
        );
        return (mapContactData[_citizenID].verify);
    }
}
