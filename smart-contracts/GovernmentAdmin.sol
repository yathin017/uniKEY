// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract GovernmentAdmin {
    address public Admin;

    struct AdminData {
        string name;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => AdminData) public mapAdminData;

    constructor(string memory _name) {
        mapAdminData[msg.sender] = AdminData(
            _name,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function addAdmin(string memory _name) public {
        require(mapAdminData[msg.sender].verify == true);
        mapAdminData[msg.sender] = AdminData(
            _name,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function removeAdmin(address _Admin) public {
        require(mapAdminData[msg.sender].verify == true);
        mapAdminData[_Admin].verify = false;
    }
}
