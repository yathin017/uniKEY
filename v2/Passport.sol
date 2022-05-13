// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Aadhar.sol";

contract Passport is Aadhar {
    enum PassportType {
        Regular,
        Official,
        Diplomatic
    }

    struct PassportData {
        string passportNumber;
        PassportType passportType;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    struct VisaOfficer {
        uint256 OfficerID;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    struct Visa {
        string countryName;
        uint256 countryID;
        string visaType;
        string description;
        uint256 issueDate;
        address issuedBy;
        uint256 expiry;
        bool verify;
    }

    mapping(address => PassportData) private mapPassportData;
    mapping(address => VisaOfficer) private mapVisaOfficer;
    mapping(address => Visa[]) private mapVisa;

    function setPassport(
        address _citizenID,
        string memory _passportNumber,
        PassportType _passportType
    ) public {
        // 315360000 = 10 years, 567648000 = 18 years
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        if (
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        ) {
            require(mapAadharData[_citizenID].verify == true);
        }
        mapPassportData[_citizenID] = PassportData(
            _passportNumber,
            _passportType,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewPassport(address _citizenID)
        public
        view
        returns (
            string memory,
            PassportType,
            uint256,
            address,
            bool
        )
    {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            _citizenID == msg.sender ||
                mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0
        );
        return (
            mapPassportData[_citizenID].passportNumber,
            mapPassportData[_citizenID].passportType,
            mapPassportData[_citizenID].issueDate,
            mapPassportData[_citizenID].issuedBy,
            verifyPassport(_citizenID)
        );
    }

    function verifyPassport(address _citizenID) public view returns (bool) {
        if (
            block.timestamp - mapPassportData[_citizenID].issueDate <= 315360000
        ) {
            return (mapPassportData[_citizenID].verify);
        } else {
            return (false);
        }
    }

    function addVisaOfficer(address _officerAddress, uint256 _officerID)
        public
    {
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0
        );
        require(mapBirthCertificate[_officerAddress].verify == true);
        mapVisaOfficer[_officerAddress] = VisaOfficer(
            _officerID,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function addVisa(
        address _citizenID,
        string memory _countryName,
        uint256 _countryID,
        string memory _visaType,
        string memory _description,
        uint256 _expiry
    ) public {
        require(mapVisaOfficer[msg.sender].verify == true);
        mapVisa[_citizenID].push(
            Visa({
                countryName: _countryName,
                countryID: _countryID,
                visaType: _visaType,
                description: _description,
                issueDate: block.timestamp,
                issuedBy: msg.sender,
                expiry: _expiry,
                verify: true
            })
        );
    }

    function viewVisa(address _citizenID) public view returns (Visa[] memory) {
        Visa[] memory data = new Visa[](mapVisa[_citizenID].length);
        for (uint256 index = 0; index < mapVisa[_citizenID].length; index++) {
            data[index] = mapVisa[_citizenID][index];
        }
        return (data);
    }

    function verifyVisa(address _citizenID, uint256 _index)
        public
        view
        returns (bool)
    {
        if (mapVisa[_citizenID][_index].expiry > block.timestamp) {
            return (false);
        } else {
            return (mapVisa[_citizenID][_index].verify);
        }
    }
}
