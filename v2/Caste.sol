// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract Caste is Identity {
    enum CasteType {
        General,
        SC,
        ST,
        OBCA,
        OBCB
    }

    struct CasteData {
        CasteType casteType;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => CasteData) public mapCasteData;

    function setCaste(address _citizenID, CasteType _casteType) public {
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        mapCasteData[_citizenID] = CasteData(
            _casteType,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewCaste(address _citizenID) public view returns (string memory) {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(mapCasteData[_citizenID].verify == true);
        if (uint256(mapCasteData[_citizenID].casteType) == 1) {
            return "SC";
        } else if (uint256(mapCasteData[_citizenID].casteType) == 2) {
            return "ST";
        } else if (uint256(mapCasteData[_citizenID].casteType) == 3) {
            return "OBC-A";
        } else if (uint256(mapCasteData[_citizenID].casteType) == 4) {
            return "OBC-B";
        } else {
            return "General";
        }
    }
}
