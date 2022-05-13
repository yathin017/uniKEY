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

    mapping(address => BusinessData) private mapBusinessData;

    function setBusiness(
        address _businessAddress,
        string memory _businessName,
        address _Owner
    ) public {
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
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
        public
        view
        returns (string memory, address)
    {
        return (
            mapBusinessData[_businessAddress].businessName,
            mapBusinessData[_businessAddress].Owner
        );
    }

    function verifyBusiness(address _businessAddress)
        public
        view
        returns (bool)
    {
        return (mapBusinessData[_businessAddress].verify);
    }

    function setterBusiness(address _businessAddress)
        public
        view
        returns (uint256, address)
    {
        return (
            mapBusinessData[_businessAddress].issueDate,
            mapBusinessData[_businessAddress].issuedBy
        );
    }

    function loginBusiness(address _businessAddress)
        public
        view
        returns (bool)
    {
        require(_businessAddress == msg.sender);
        return (mapBusinessData[msg.sender].verify);
    }
}
