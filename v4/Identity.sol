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
        address FatherID;
        address MotherID;
        string Country;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => GovernmentWorkerData) internal mapGovernmentWorker;
    mapping(address => BirthCertificate) internal mapBirthCertificate;

    // Government Workers
    function addGovernmentWorkerA(
        address _governmentID,
        string memory _name,
        string memory _adminNumber,
        string memory _designation
    ) external {
        require(mapAdminData[msg.sender].verify == true);
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

    function addGovernmentWorkerB(
        address _governmentID,
        string memory _name,
        string memory _adminNumber,
        string memory _designation
    ) external {
        require(mapAdminData[msg.sender].verify == true);
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
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            uint256,
            address,
            bool
        )
    {
        if (uint256(mapGovernmentWorker[_governmentID].power) == 0) {
            return (
                mapGovernmentWorker[_governmentID].name,
                mapGovernmentWorker[_governmentID].adminNumber,
                mapGovernmentWorker[_governmentID].designation,
                "A",
                mapGovernmentWorker[_governmentID].issueDate,
                mapGovernmentWorker[_governmentID].issuedBy,
                mapGovernmentWorker[_governmentID].verify
            );
        } else if (uint256(mapGovernmentWorker[_governmentID].power) == 1) {
            return (
                mapGovernmentWorker[_governmentID].name,
                mapGovernmentWorker[_governmentID].adminNumber,
                mapGovernmentWorker[_governmentID].designation,
                "B",
                mapGovernmentWorker[_governmentID].issueDate,
                mapGovernmentWorker[_governmentID].issuedBy,
                mapGovernmentWorker[_governmentID].verify
            );
        } else {
            return ("Null", "Null", "Null", "Null", 0, address(0), false);
        }
    }

    function verifyGovernmentWorker(address _governmentID)
        public
        view
        returns (bool)
    {
        return (mapGovernmentWorker[_governmentID].verify);
    }

    function removeGovernmentWorker(address _governmentID) external {
        require(mapAdminData[msg.sender].verify == true);
        mapGovernmentWorker[_governmentID].verify = false;
    }

    function loginGovernmentWorker(address _governmentID)
        external
        view
        returns (bool)
    {
        require(
            msg.sender == _governmentID &&
                mapGovernmentWorker[msg.sender].verify == true
        );
        return (mapGovernmentWorker[msg.sender].verify);
    }

    // Birth Certificate
    function setBirthCertificate(
        address _citizenID,
        string memory _name,
        string memory _gender,
        uint256 _DOB,
        address _FatherID,
        address _MotherID,
        string memory _country
    ) external {
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256(mapGovernmentWorker[msg.sender].power) == 0
        );
        require(mapBirthCertificate[_citizenID].verify == false);
        mapBirthCertificate[_citizenID] = BirthCertificate(
            _name,
            _gender,
            _DOB,
            _FatherID,
            _MotherID,
            _country,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function viewBirthCertificate(address _citizenID)
        external
        view
        returns (
            string memory,
            string memory,
            uint256,
            address,
            address,
            uint256,
            address
        )
    {
        return (
            mapBirthCertificate[_citizenID].name,
            mapBirthCertificate[_citizenID].gender,
            mapBirthCertificate[_citizenID].DOB,
            mapBirthCertificate[_citizenID].FatherID,
            mapBirthCertificate[_citizenID].MotherID,
            mapBirthCertificate[_citizenID].issueDate,
            mapBirthCertificate[_citizenID].issuedBy
        );
    }

    function verifyBirthCertificate(address _citizenID)
        public
        view
        returns (bool)
    {
        return (mapBirthCertificate[_citizenID].verify);
    }

    function removeBirthCertificate(address _citizenID) external {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            verifyAdmin(msg.sender) == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapBirthCertificate[_citizenID].verify = false;
    }

    function loginBirthcertificate(address _citizenID)
        external
        view
        returns (bool)
    {
        require(
            msg.sender == _citizenID &&
                mapBirthCertificate[_citizenID].verify == true
        );
        return (mapBirthCertificate[_citizenID].verify);
    }
}
