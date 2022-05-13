// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Aadhar.sol";

contract PAN is Aadhar {
    struct PANData {
        string PAN;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => PANData) private mapPANData;

    function setPAN(address _citizenID, string memory _PAN) public {
        // 567648000 = 18 years
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        require(mapAadharData[_citizenID].verify == true);
        require(
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        );
        mapPANData[_citizenID] = PANData(
            _PAN,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewPAN(address _citizenID)
        public
        view
        returns (
            string memory,
            uint256,
            address
        )
    {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            _citizenID == msg.sender ||
                mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0
        );
        return (
            mapPANData[_citizenID].PAN,
            mapPANData[_citizenID].issueDate,
            mapPANData[_citizenID].issuedBy
        );
    }

    function verifyPAN(address _citizenID) public view returns (bool) {
        return (mapPANData[_citizenID].verify);
    }
}
