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
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
        );
        if (block.timestamp - ageBirthCertificate(_citizenID) >= 567648000) {
            require(verifyAadharData(msg.sender) == true);
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
        returns (string memory, PassportType)
    {
        require(verifyBirthCertificate(msg.sender) == true);
        require(
            _citizenID == msg.sender ||
                verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0
        );
        return (
            mapPassportData[_citizenID].passportNumber,
            mapPassportData[_citizenID].passportType
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

    function setterPassportData(address _citizenID)
        public
        view
        returns (uint256, address)
    {
        return (
            mapPassportData[_citizenID].issueDate,
            mapPassportData[_citizenID].issuedBy
        );
    }

    function addVisaOfficer(address _officerAddress, uint256 _officerID)
        public
    {
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0
        );
        require(verifyBirthCertificate(_officerAddress) == true);
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

    function loginPassport(address _citizenID) public view returns (bool) {
        require(_citizenID == msg.sender);
        return (mapPassportData[_citizenID].verify);
    }
}
