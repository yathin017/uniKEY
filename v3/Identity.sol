// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./GovernmentAdmin.sol";

contract Identity is GovernmentAdmin {
    enum EntityPower {
        A,
        B
    }

    struct GovernmentWorkerData {
        string name;
        string adminNumber;
        string designation;
        EntityPower power;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    struct BirthCertificate {
        string name;
        string gender;
        uint256 DOB;
        string bloodGroup;
        string PlaceOfBirth;
        address FatherID;
        address MotherID;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => GovernmentWorkerData) private mapGovernmentWorker;
    mapping(address => BirthCertificate) private mapBirthCertificate;

    // Government Workers
    function hireGovernmentWorkerA(
        address _governmentID,
        string memory _name,
        string memory _adminNumber,
        string memory _designation
    ) public {
        require(verifyAdmin(msg.sender) == true);
        require(
            mapBirthCertificate[_governmentID].verify == true &&
                block.timestamp - mapBirthCertificate[_governmentID].DOB >=
                567648000
        );
        mapGovernmentWorker[_governmentID] = GovernmentWorkerData(
            _name,
            _adminNumber,
            _designation,
            EntityPower.A,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function hireGovernmentWorkerB(
        address _governmentID,
        string memory _name,
        string memory _adminNumber,
        string memory _designation
    ) public {
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(mapGovernmentWorker[msg.sender].power) == 0
        );
        require(
            mapBirthCertificate[_governmentID].verify == true &&
                block.timestamp - mapBirthCertificate[_governmentID].DOB >=
                567648000
        );
        mapGovernmentWorker[_governmentID] = GovernmentWorkerData(
            _name,
            _adminNumber,
            _designation,
            EntityPower.B,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewGovernmentWorker(address _governmentID)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            EntityPower
        )
    {
        return (
            mapGovernmentWorker[_governmentID].name,
            mapGovernmentWorker[_governmentID].adminNumber,
            mapGovernmentWorker[_governmentID].designation,
            mapGovernmentWorker[_governmentID].power
        );
    }

    function verifyGovernmentWorker(address _governmentID)
        public
        view
        returns (bool)
    {
        return (mapGovernmentWorker[_governmentID].verify);
    }

    function setterGovernmentWorker(address _governmentID)
        public
        view
        returns (uint256, address)
    {
        return (
            mapGovernmentWorker[_governmentID].issueDate,
            mapGovernmentWorker[_governmentID].issuedBy
        );
    }

    function removeGovernmentWorker(address _governmentID) public {
        require(mapGovernmentWorker[_governmentID].verify == true);
        require(verifyAdmin(msg.sender) == true);
        mapGovernmentWorker[_governmentID].verify = false;
    }

    function powerGovernmentWorker(address _governmentID)
        public
        view
        returns (EntityPower)
    {
        return (mapGovernmentWorker[_governmentID].power);
    }

    // Birth Certificate
    function setBirthCertificate(
        address _citizenID,
        string memory _name,
        string memory _gender,
        uint256 _DOB,
        string memory _bloodGroup,
        string memory _PlaceOfBirth,
        address _FatherID,
        address _MotherID
    ) public {
        require(uint256(mapGovernmentWorker[msg.sender].power) == 0);
        require(mapBirthCertificate[_citizenID].verify == false);
        mapBirthCertificate[_citizenID] = BirthCertificate(
            _name,
            _gender,
            _DOB,
            _bloodGroup,
            _PlaceOfBirth,
            _FatherID,
            _MotherID,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewBirthCertificate(address _citizenID)
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            string memory,
            string memory,
            address,
            address
        )
    {
        return (
            mapBirthCertificate[_citizenID].name,
            mapBirthCertificate[_citizenID].gender,
            mapBirthCertificate[_citizenID].DOB,
            mapBirthCertificate[_citizenID].bloodGroup,
            mapBirthCertificate[_citizenID].PlaceOfBirth,
            mapBirthCertificate[_citizenID].FatherID,
            mapBirthCertificate[_citizenID].MotherID
        );
    }

    function verifyBirthCertificate(address _citizenID)
        public
        view
        returns (bool)
    {
        return (mapBirthCertificate[_citizenID].verify);
    }

    function setterBirthCertificate(address _citizenID)
        public
        view
        returns (uint256, address)
    {
        return (
            mapBirthCertificate[_citizenID].issueDate,
            mapBirthCertificate[_citizenID].issuedBy
        );
    }

    function removeBirthCertificate(address _citizenID) public {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(mapGovernmentWorker[msg.sender].verify == true);
        mapBirthCertificate[_citizenID].verify = false;
    }

    function ageBirthCertificate(address _citizenID)
        public
        view
        returns (uint256)
    {
        return (mapBirthCertificate[_citizenID].DOB);
    }

    function loginBirthcertificate(address _citizenID)
        public
        view
        returns (bool)
    {
        require(_citizenID == msg.sender);
        return (mapBirthCertificate[_citizenID].verify);
    }
}
