// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract CriminalRecords is Identity {
    struct CriminalRecord {
        string charges;
        uint256 fine;
        uint256 issueDate;
        address issuedBy;
    }

    mapping(address => CriminalRecord[]) internal mapCriminalRecord;

    function addCriminalRecord(
        address _citizenID,
        string memory _charges,
        uint256 _fine
    ) external {
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        require(mapBirthCertificate[msg.sender].verify == true);
        mapCriminalRecord[_citizenID].push(
            CriminalRecord({
                charges: _charges,
                fine: _fine,
                issueDate: block.timestamp,
                issuedBy: msg.sender
            })
        );
    }

    function viewRecentCriminalRecord(address _citizenID)
        external
        view
        returns (CriminalRecord memory)
    {
        return (
            mapCriminalRecord[_citizenID][
                mapCriminalRecord[_citizenID].length - 1
            ]
        );
    }

    function AllCriminalRecord(address _citizenID)
        external
        view
        returns (CriminalRecord[] memory)
    {
        CriminalRecord[] memory data = new CriminalRecord[](
            mapCriminalRecord[_citizenID].length
        );
        for (
            uint256 index = 0;
            index < mapCriminalRecord[_citizenID].length;
            index++
        ) {
            data[index] = mapCriminalRecord[_citizenID][index];
        }
        return (data);
    }
}
