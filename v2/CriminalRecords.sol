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

    mapping(address => CriminalRecord[]) private mapCriminalRecord;

    function addCriminalRecord(
        address _citizenID,
        string memory _charges,
        uint256 _fine
    ) public {
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        require(mapBirthCertificate[_citizenID].verify == true);
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
        public
        view
        returns (CriminalRecord memory)
    {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(mapCriminalRecord[_citizenID].length > 0);
        return (
            mapCriminalRecord[_citizenID][
                mapCriminalRecord[_citizenID].length - 1
            ]
        );
    }

    function AllCriminalRecord(address _citizenID)
        public
        view
        returns (CriminalRecord[] memory)
    {
        require(mapCriminalRecord[_citizenID].length > 0);
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
