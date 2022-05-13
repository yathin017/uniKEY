// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract Contact is Identity {
    struct ContactData {
        uint256 contactNumber;
        string homeAddress;
        uint256 pinCode;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => ContactData) public mapContactData;

    function setContactData(
        address _citizenID,
        uint256 _contactNumber,
        string memory _homeAddress,
        uint256 _pinCode
    ) public {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(mapGovernmentWorker[msg.sender].verify == true);
        mapContactData[_citizenID] = ContactData(
            _contactNumber,
            _homeAddress,
            _pinCode,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function removeContactData(address _citizenID) public {
        require(mapContactData[_citizenID].verify == true);
        require(mapGovernmentWorker[msg.sender].verify == true);
        mapContactData[_citizenID].verify = false;
    }

    function viewContactData(address _citizenID)
        public
        view
        returns (
            uint256,
            string memory,
            uint256,
            uint256,
            address,
            bool
        )
    {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            _citizenID == msg.sender ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0
        );
        return (
            mapContactData[_citizenID].contactNumber,
            mapContactData[_citizenID].homeAddress,
            mapContactData[_citizenID].pinCode,
            mapContactData[_citizenID].issueDate,
            mapContactData[_citizenID].issuedBy,
            mapContactData[_citizenID].verify
        );
    }
}
