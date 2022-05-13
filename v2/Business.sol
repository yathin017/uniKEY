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

    mapping(address => BusinessData) public mapBusinessData;

    function setBusiness(
        address _businessAddress,
        string memory _businessName,
        address _Owner
    ) public {
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        mapBusinessData[_businessAddress] = BusinessData(
            _businessName,
            _Owner,
            block.timestamp,
            msg.sender,
            true
        );
    }
}
