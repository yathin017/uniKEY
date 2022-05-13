// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract Business is Identity {
    struct BusinessData {
        string businessName;
        address Owner;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => BusinessData) internal mapBusinessData;

    function setBusiness(
        address _businessAddress,
        string memory _businessName,
        address _Owner
    ) public {
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapBusinessData[_businessAddress] = BusinessData(
            _businessName,
            _Owner,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewBusiness(address _businessAddress)
        external
        view
        returns (
            string memory,
            address,
            uint256,
            address
        )
    {
        return (
            mapBusinessData[_businessAddress].businessName,
            mapBusinessData[_businessAddress].Owner,
            mapBusinessData[_businessAddress].issueDate,
            mapBusinessData[_businessAddress].issuedBy
        );
    }

    function verifyBusiness(address _businessAddress)
        public
        view
        returns (bool)
    {
        return (mapBusinessData[_businessAddress].verify);
    }

    function loginBusiness(address _businessAddress)
        external
        view
        returns (bool)
    {
        require(
            msg.sender == _businessAddress &&
                mapBusinessData[msg.sender].verify == true
        );
        return (mapBusinessData[msg.sender].verify);
    }
}
