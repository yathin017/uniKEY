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
    }

    mapping(address => CasteData) private mapCasteData;

    function setCaste(address _citizenID, CasteType _casteType) public {
        require(uint256(powerGovernmentWorker(msg.sender)) == 1);
        mapCasteData[_citizenID] = CasteData(
            _casteType,
            block.timestamp,
            msg.sender
        );
    }

    function viewCaste(address _citizenID) public view returns (string memory) {
        require(verifyBirthCertificate(_citizenID) == true);
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

    function setterCaste(address _citizenID)
        public
        view
        returns (uint256, address)
    {
        return (
            mapCasteData[_citizenID].issueDate,
            mapCasteData[_citizenID].issuedBy
        );
    }
}
