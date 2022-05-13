// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract GovernmentAdmin {
    struct AdminData {
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => AdminData) public mapAdminData;

    constructor() {
        mapAdminData[msg.sender] = AdminData(block.timestamp, msg.sender, true);
    }

    function addAdmin(address _Admin) public {
        require(mapAdminData[msg.sender].verify == true);
        mapAdminData[_Admin] = AdminData(block.timestamp, msg.sender, true);
    }

    function removeAdmin(address _Admin) public {
        require(mapAdminData[msg.sender].verify == true);
        mapAdminData[_Admin].verify = false;
    }
}
