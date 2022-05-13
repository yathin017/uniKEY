// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract GovernmentAdmin {
    struct AdminData {
        string name;
        string adminNumber;
        string designation;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => AdminData) internal mapAdminData;

    constructor() {
        mapAdminData[msg.sender] = AdminData(
            "Yathin",
            "201000060",
            "Admin",
            block.timestamp,
            msg.sender,
            true
        );
    }

    function addAdmin(
        address _Admin,
        string memory _name,
        string memory _adminNumber,
        string memory _designation
    ) external {
        require(mapAdminData[msg.sender].verify == true);
        mapAdminData[_Admin] = AdminData(
            _name,
            _adminNumber,
            _designation,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewAdmin(address _Admin)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint256,
            address,
            bool
        )
    {
        return (
            mapAdminData[_Admin].name,
            mapAdminData[_Admin].adminNumber,
            mapAdminData[_Admin].designation,
            mapAdminData[_Admin].issueDate,
            mapAdminData[_Admin].issuedBy,
            mapAdminData[_Admin].verify
        );
    }

    function verifyAdmin(address _Admin) public view returns (bool) {
        return (mapAdminData[_Admin].verify);
    }

    function removeAdmin(address _Admin) external {
        require(mapAdminData[msg.sender].verify == true);
        mapAdminData[_Admin].verify = false;
    }

    function loginAdmin(address _Admin) external view returns (bool) {
        require(
            msg.sender == _Admin && mapAdminData[msg.sender].verify == true
        );
        return (mapAdminData[msg.sender].verify);
    }
}
