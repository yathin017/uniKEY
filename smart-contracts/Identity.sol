// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./GovernmentAdmin.sol";

contract Identity is GovernmentAdmin {

    enum EntityPower {
        A,
        B
    }
    address[] private accessAddress;

    struct GovernmentWorkerData {
        string name;
        uint256 issueDate;
        string gender;
        string adminNumber;
        string designation;
        bool verify;
        EntityPower power;
    }

    struct BirthCertificate {
        string name;
        string gender;
        uint256 DOB;
        string PlaceOfBirth;
        address FatherID;
        address MotherID;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    struct Access {
        string name;
        address user;
        uint256 issueDate;
        bool verify;
    }

    mapping(address => GovernmentWorkerData) public mapGovernmentWorker;
    mapping(address => BirthCertificate) private mapBirthCertificate;
    mapping(address => mapping(address => Access)) public mapAccess;

    // Government Workers
    function hireGovernmentWorkerA(
        address _governmentID,
        string memory _name,
        string memory _gender,
        string memory _adminNumber,
        string memory _designation
    ) public {
        require(
            mapAdminData[msg.sender].verify == true,
            "Only Contract Owner can set Government Entity A"
        );
        require(
            mapBirthCertificate[_governmentID].verify == true &&
                block.timestamp - mapBirthCertificate[_governmentID].DOB >=
                567648000
        );
        mapGovernmentWorker[_governmentID] = GovernmentWorkerData(
            _name,
            block.timestamp,
            _gender,
            _adminNumber,
            _designation,
            true,
            EntityPower.A
        );
    }

    function hireGovernmentWorkerB(
        address _governmentID,
        string memory _name,
        string memory _gender,
        string memory _adminNumber,
        string memory _designation
    ) public {
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0,
            "Only Contract Owner and A can set Government Entity B"
        );
        require(
            mapBirthCertificate[_governmentID].verify == true &&
                block.timestamp - mapBirthCertificate[_governmentID].DOB >=
                567648000
        );
        mapGovernmentWorker[_governmentID] = GovernmentWorkerData(
            _name,
            block.timestamp,
            _gender,
            _adminNumber,
            _designation,
            true,
            EntityPower.B
        );
    }

    function removeGovernmentWorker(address _governmentID) public {
        require(mapAdminData[msg.sender].verify == true);
        mapGovernmentWorker[_governmentID].verify = false;
    }

    // Birth Certificate
    function setBirthCertificate(
        address _citizenID,
        string memory _name,
        string memory _gender,
        uint256 _DOB,
        string memory _PlaceOfBirth,
        address _FatherID,
        address _MotherID
    ) public {
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0,
            "Only Contract Owner and A can set Government Entity B"
        );
        require(
            mapBirthCertificate[_citizenID].verify == false,
            "This address already exists"
        );
        mapBirthCertificate[_citizenID] = BirthCertificate(
            _name,
            _gender,
            _DOB,
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
            address,
            address
        )
    {
        require(
            mapBirthCertificate[_citizenID].verify == true,
            "Not a Citizen"
        );
        require(
            mapAdminData[msg.sender].verify == true ||
                _citizenID == msg.sender ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                mapAccess[_citizenID][msg.sender].verify == true,
            "You must be a Government Entity or Owner of _citizenID"
        );
        return (
            mapBirthCertificate[_citizenID].name,
            mapBirthCertificate[_citizenID].gender,
            mapBirthCertificate[_citizenID].DOB,
            mapBirthCertificate[_citizenID].PlaceOfBirth,
            mapBirthCertificate[_citizenID].FatherID,
            mapBirthCertificate[_citizenID].MotherID
        );
    }

    function verifyBirthCertificate(address _citizenID)
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            address,
            address
        )
    {
        return (
            mapBirthCertificate[_citizenID].name,
            mapBirthCertificate[_citizenID].gender,
            mapBirthCertificate[_citizenID].DOB,
            mapBirthCertificate[_citizenID].FatherID,
            mapBirthCertificate[_citizenID].MotherID
        );
    }

    // Accessibility
    function giveAccess(string memory _name, address _user) public {
        require(
            mapBirthCertificate[msg.sender].verify == true,
            "Not a Citizen"
        );
        mapAccess[msg.sender][_user] = Access(
            _name,
            _user,
            block.timestamp,
            true
        );
        accessAddress.push(_user);
    }

    function removeAccess(address _user) public {
        require(
            mapBirthCertificate[msg.sender].verify == true,
            "Not a Citizen"
        );
        mapAccess[msg.sender][_user].verify = false;
        for (uint256 i = 0; i < accessAddress.length; i++) {
            if (accessAddress[i] == _user) {
                delete accessAddress[i];
            }
        }
    }

    function removeAllAccess() public {
        require(
            mapBirthCertificate[msg.sender].verify == true,
            "Not a Citizen"
        );
        address userAddress;
        for (uint256 i = 0; i < accessAddress.length; i++) {
            userAddress = accessAddress[i];
            mapAccess[msg.sender][userAddress].verify = false;
        }
        delete accessAddress;
    }
    
}
