// SPDX-License-Identifier: NONE
pragma solidity ^0.8.4;

contract uniKEY {
    // GovernmentAdmin.sol

    struct AdminData {
        string name;
        string adminNumber;
        string designation;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => AdminData) internal mapAdminData;

    struct BirthCertificate {
        string name;
        string gender;
        uint DOB;
        address FatherID;
        address MotherID;
        string Country;
        uint issueDate;
        address issuedBy;
        bool verify;
        uint password;
    }

    mapping(address => BirthCertificate) internal mapBirthCertificate;

    constructor(
        string memory _name,
        string memory _gender,
        uint _DOB,
        address _FatherID,
        address _MotherID,
        string memory _country,
        string memory _password,
        string memory _adminNumber,
        string memory _designation
    ) {
        require(block.timestamp - _DOB >= 567648000);
        mapAdminData[msg.sender] = AdminData(
            _name,
            _adminNumber,
            _designation,
            block.timestamp,
            msg.sender,
            true
        );
        mapBirthCertificate[msg.sender] = BirthCertificate(
            _name,
            _gender,
            _DOB,
            _FatherID,
            _MotherID,
            _country,
            block.timestamp,
            msg.sender,
            true,
            uint(sha256(abi.encodePacked(_name, _DOB, _password)))
        );
    }

    function addAdmin(
        address _Admin,
        string memory _name,
        string memory _adminNumber,
        string memory _designation
    ) external {
        require(mapAdminData[msg.sender].verify == true);
        mapAdminData[_Admin] = AdminData(
            _name,
            _adminNumber,
            _designation,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function removeAdmin(address _Admin) external {
        require(mapAdminData[msg.sender].verify == true);
        mapAdminData[_Admin].verify = false;
    }

    function viewAdmin(address _Admin)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint,
            address,
            bool
        )
    {
        return (
            mapAdminData[_Admin].name,
            mapAdminData[_Admin].adminNumber,
            mapAdminData[_Admin].designation,
            mapAdminData[_Admin].issueDate,
            mapAdminData[_Admin].issuedBy,
            mapAdminData[_Admin].verify
        );
    }

    function loginAdmin(address _Admin) external view returns (bool) {
        require(
            msg.sender == _Admin && mapAdminData[msg.sender].verify == true
        );
        return (mapAdminData[msg.sender].verify);
    }

    // Identity.sol

    enum EntityPower {
        A,
        B
    }

    struct GovernmentWorkerData {
        string name;
        string adminNumber;
        string designation;
        EntityPower power;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => GovernmentWorkerData) internal mapGovernmentWorker;

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

    function removeGovernmentWorker(address _governmentID) external {
        require(mapAdminData[msg.sender].verify == true);
        mapGovernmentWorker[_governmentID].verify = false;
    }

    function viewGovernmentWorker(address _governmentID)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            uint,
            address,
            bool
        )
    {
        if (uint(mapGovernmentWorker[_governmentID].power) == 0) {
            return (
                mapGovernmentWorker[_governmentID].name,
                mapGovernmentWorker[_governmentID].adminNumber,
                mapGovernmentWorker[_governmentID].designation,
                "A",
                mapGovernmentWorker[_governmentID].issueDate,
                mapGovernmentWorker[_governmentID].issuedBy,
                mapGovernmentWorker[_governmentID].verify
            );
        } else if (uint(mapGovernmentWorker[_governmentID].power) == 1) {
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
        uint _DOB,
        address _FatherID,
        address _MotherID,
        string memory _country,
        string memory _password
    ) external {
        require(mapBirthCertificate[_citizenID].verify == false);
        require(
            mapAdminData[msg.sender].verify == true ||
                uint(mapGovernmentWorker[msg.sender].power) == 0
        );
        mapBirthCertificate[_citizenID] = BirthCertificate(
            _name,
            _gender,
            _DOB,
            _FatherID,
            _MotherID,
            _country,
            block.timestamp,
            msg.sender,
            true,
            uint(sha256(abi.encodePacked(_name, _DOB, _password)))
        );
    }

    function removeBirthCertificate(address _citizenID) external {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                uint(mapGovernmentWorker[msg.sender].power) == 0
        );
        mapBirthCertificate[_citizenID].verify = false;
    }

    function changePassword(string memory _newPassword) external {
        require(mapBirthCertificate[msg.sender].verify == true);
        mapBirthCertificate[msg.sender].password = uint(
            sha256(
                abi.encodePacked(
                    mapBirthCertificate[msg.sender].name,
                    mapBirthCertificate[msg.sender].DOB,
                    _newPassword
                )
            )
        );
    }

    function viewBirthCertificate(address _citizenID)
        external
        view
        returns (
            string memory,
            string memory,
            uint,
            address,
            address,
            uint,
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

    function verifyAuthenticity(address _citizenID, string memory _password)
        external
        view
        returns (bool)
    {
        return (mapBirthCertificate[_citizenID].password ==
            uint(
                sha256(
                    abi.encodePacked(
                        mapBirthCertificate[_citizenID].name,
                        mapBirthCertificate[_citizenID].DOB,
                        _password
                    )
                )
            ));
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

    // Contact.sol

    struct ContactData {
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => ContactData) internal mapContactData;

    function setContactData(address _citizenID) external {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapContactData[_citizenID] = ContactData(
            block.timestamp,
            msg.sender,
            true
        );
    }

    function removeContactData(address _citizenID) public {
        require(mapContactData[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapContactData[_citizenID].verify = false;
    }

    function viewContactData(address _citizenID)
        external
        view
        returns (
            uint,
            address,
            bool
        )
    {
        return (
            mapContactData[_citizenID].issueDate,
            mapContactData[_citizenID].issuedBy,
            mapContactData[_citizenID].verify
        );
    }

    function verifyContactData(address _citizenID) public view returns (bool) {
        return (mapContactData[_citizenID].verify);
    }

    function loginContact(address _citizenID) external view returns (bool) {
        require(
            msg.sender == _citizenID &&
                mapContactData[_citizenID].verify == true
        );
        return (mapContactData[_citizenID].verify);
    }

    // Biometrics.sol

    struct Face {
        string hash;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct Iris {
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct Fingerprint {
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => Face) internal mapFace;
    mapping(address => Iris) internal mapIris;
    mapping(address => Fingerprint) internal mapFingerprint;

    function setBiometricsFace(address _citizenID, string memory _hash)
        external
    {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapFace[_citizenID].hash = _hash;
        mapFace[_citizenID].issueDate = block.timestamp;
        mapFace[_citizenID].issuedBy = msg.sender;
        mapIris[_citizenID].verify = true;
    }

    function setBiometricsIris(address _citizenID) external {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapIris[_citizenID].issueDate = block.timestamp;
        mapIris[_citizenID].issuedBy = msg.sender;
        mapIris[_citizenID].verify = true;
    }

    function setBiometricsFingerPrint(address _citizenID) external {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapFingerprint[_citizenID].issueDate = block.timestamp;
        mapFingerprint[_citizenID].issuedBy = msg.sender;
        mapFingerprint[_citizenID].verify = true;
    }

    function viewFace(address _citizenID)
        external
        view
        returns (string memory)
    {
        return mapFace[_citizenID].hash;
    }

    function verifyBiometrics(address _citizenID) public view returns (bool) {
        // 315569260 = 10 years
        if (
            block.timestamp - mapIris[_citizenID].issueDate <= 315569260 &&
            mapIris[_citizenID].verify == true &&
            block.timestamp - mapFingerprint[_citizenID].issueDate <=
            315569260 &&
            mapFingerprint[_citizenID].verify == true &&
            block.timestamp - mapFace[_citizenID].issueDate <= 315569260 &&
            mapFace[_citizenID].verify == true
        ) {
            return true;
        } else {
            return false;
        }
    }

    // Aadhar.sol

    struct AadharData {
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => AadharData) internal mapAadharData;

    function setAadhar(address _citizenID) external {
        require(mapBirthCertificate[_citizenID].verify == true);
        require(mapContactData[_citizenID].verify == true);
        require(verifyBiometrics(_citizenID) == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapAadharData[_citizenID] = AadharData(
            block.timestamp,
            msg.sender,
            true
        );
    }

    function removeAadharData(address _citizenID) external {
        require(mapAadharData[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapAadharData[_citizenID].verify = false;
    }

    function viewAadharData(address _citizenID)
        external
        view
        returns (
            uint,
            address,
            bool
        )
    {
        return (
            mapAadharData[_citizenID].issueDate,
            mapAadharData[_citizenID].issuedBy,
            mapAadharData[_citizenID].verify
        );
    }

    function verifyAadharData(address _citizenID) public view returns (bool) {
        return (mapAadharData[_citizenID].verify);
    }

    function loginAadhar(address _citizenID) external view returns (bool) {
        require(
            msg.sender == _citizenID && mapAadharData[msg.sender].verify == true
        );
        return (mapAadharData[_citizenID].verify);
    }

    // PAN.sol

    struct PANData {
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => PANData) internal mapPANData;

    function setPAN(address _citizenID) external {
        // 567648000 = 18 years
        require(mapAadharData[msg.sender].verify == true);
        require(
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        );
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapPANData[_citizenID] = PANData(block.timestamp, msg.sender, true);
    }

    function removePANData(address _citizenID) external {
        require(mapPANData[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapPANData[_citizenID].verify = false;
    }

    function viewPANData(address _citizenID)
        external
        view
        returns (
            uint,
            address,
            bool
        )
    {
        return (
            mapPANData[_citizenID].issueDate,
            mapPANData[_citizenID].issuedBy,
            mapPANData[_citizenID].verify
        );
    }

    function verifyPANData(address _citizenID) public view returns (bool) {
        return (mapPANData[_citizenID].verify);
    }

    function loginPAN(address _citizenID) external view returns (bool) {
        require(
            msg.sender == _citizenID && mapPANData[msg.sender].verify == true
        );
        return (mapPANData[_citizenID].verify);
    }

    // DrivingLicense.sol

    enum Vehicle {
        Two,
        Four
    }

    struct DrivingLicenseData {
        Vehicle wheeler;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => DrivingLicenseData[2]) internal mapDrivingLicenseData;

    function set2WheelerLicense(address _citizenID) external {
        // 567648000 = 18 years
        require(verifyAadharData(_citizenID) == true);
        require(
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        );
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapDrivingLicenseData[_citizenID][0] = (
            DrivingLicenseData({
                wheeler: Vehicle.Two,
                issueDate: block.timestamp,
                issuedBy: msg.sender,
                verify: true
            })
        );
    }

    function set4WheelerLicense(address _citizenID) external {
        // 567648000 = 18 years
        require(verifyAadharData(_citizenID) == true);
        require(
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        );
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapDrivingLicenseData[_citizenID][1] = (
            DrivingLicenseData({
                wheeler: Vehicle.Two,
                issueDate: block.timestamp,
                issuedBy: msg.sender,
                verify: true
            })
        );
    }

    function remove2WheelerLicense(address _citizenID) external {
        require(mapDrivingLicenseData[_citizenID][0].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapDrivingLicenseData[_citizenID][0].verify = false;
    }

    function remove4WheelerLicense(address _citizenID) external {
        require(mapDrivingLicenseData[_citizenID][1].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapDrivingLicenseData[_citizenID][1].verify = false;
    }

    function viewDrivingLicense(address _citizenID)
        external
        view
        returns (DrivingLicenseData[] memory)
    {
        DrivingLicenseData[] memory data = new DrivingLicenseData[](
            mapDrivingLicenseData[_citizenID].length
        );
        for (
            uint index = 0;
            index < mapDrivingLicenseData[_citizenID].length;
            index++
        ) {
            data[index] = mapDrivingLicenseData[_citizenID][index];
        }
        return (data);
    }

    function view2WheelerLicense(address _citizenID)
        external
        view
        returns (
            uint,
            address,
            bool
        )
    {
        return (
            mapDrivingLicenseData[_citizenID][0].issueDate,
            mapDrivingLicenseData[_citizenID][0].issuedBy,
            mapDrivingLicenseData[_citizenID][0].verify
        );
    }

    function view4WheelerLicense(address _citizenID)
        external
        view
        returns (
            uint,
            address,
            bool
        )
    {
        return (
            mapDrivingLicenseData[_citizenID][1].issueDate,
            mapDrivingLicenseData[_citizenID][1].issuedBy,
            mapDrivingLicenseData[_citizenID][1].verify
        );
    }

    function verify2WheelerLicense(address _citizenID)
        public
        view
        returns (bool)
    {
        return (mapDrivingLicenseData[_citizenID][0].verify);
    }

    function verify4WheelerLicense(address _citizenID)
        public
        view
        returns (bool)
    {
        return (mapDrivingLicenseData[_citizenID][1].verify);
    }

    // Voter.sol

    struct VoterData {
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => VoterData) internal mapVoterData;

    function setVoterID(address _citizenID) external {
        require(verifyAadharData(_citizenID) == true);
        require(
            block.timestamp - mapBirthCertificate[msg.sender].DOB >= 567648000
        );
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapVoterData[_citizenID] = VoterData(block.timestamp, msg.sender, true);
    }

    function removeVoterData(address _citizenID) external {
        require(mapVoterData[_citizenID].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapVoterData[_citizenID].verify = false;
    }

    function viewVoterData(address _citizenID)
        external
        view
        returns (
            uint,
            address,
            bool
        )
    {
        return (
            mapVoterData[_citizenID].issueDate,
            mapVoterData[_citizenID].issuedBy,
            mapVoterData[_citizenID].verify
        );
    }

    function verifyVoterData(address _citizenID) public view returns (bool) {
        return (mapVoterData[_citizenID].verify);
    }

    // Passport.sol

    enum PassportType {
        Regular,
        Official,
        Diplomatic
    }

    struct PassportData {
        PassportType passportType;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct VisaOfficer {
        uint OfficerID;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct Visa {
        string countryName;
        uint countryID;
        string visaType;
        string description;
        uint issueDate;
        address issuedBy;
        uint expiry;
        bool verify;
    }

    mapping(address => PassportData) internal mapPassportData;
    mapping(address => VisaOfficer) internal mapVisaOfficer;
    mapping(address => Visa[]) internal mapVisa;

    function setPassport(address _citizenID, PassportType _passportType)
        external
    {
        // 315360000 = 10 years, 567648000 = 18 years
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        if (
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        ) {
            require(mapAadharData[_citizenID].verify == true);
        }
        mapPassportData[_citizenID] = PassportData(
            _passportType,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function addVisaOfficer(address _officerAddress, uint _officerID)
        external
    {
        require(verifyBirthCertificate(_officerAddress) == true);
        require(
            block.timestamp - mapBirthCertificate[_officerAddress].DOB >=
                567648000
        );
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
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
        uint _countryID,
        string memory _visaType,
        string memory _description,
        uint _expiry
    ) external {
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

    function removePassport(address _citizenID) external {
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapPassportData[_citizenID].verify = false;
    }

    function removeVisaOfficer(address _officerAddress) external {
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapVisaOfficer[_officerAddress].verify = false;
    }

    function removeVisa(address _citizenID, uint _index) external {
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true ||
                mapVisaOfficer[msg.sender].verify == true
        );
        mapVisa[_citizenID][_index].verify = false;
    }

    function viewPassport(address _citizenID)
        external
        view
        returns (
            string memory,
            uint,
            address,
            bool
        )
    {
        if (uint(mapPassportData[_citizenID].passportType) == 0) {
            return (
                "Regular",
                mapPassportData[_citizenID].issueDate,
                mapPassportData[_citizenID].issuedBy,
                verifyPassport(_citizenID)
            );
        } else if (uint(mapPassportData[_citizenID].passportType) == 1) {
            return (
                "Official",
                mapPassportData[_citizenID].issueDate,
                mapPassportData[_citizenID].issuedBy,
                verifyPassport(_citizenID)
            );
        } else if (uint(mapPassportData[_citizenID].passportType) == 2) {
            return (
                "Diplomatic",
                mapPassportData[_citizenID].issueDate,
                mapPassportData[_citizenID].issuedBy,
                verifyPassport(_citizenID)
            );
        } else {
            return ("Null", 0, address(0), false);
        }
    }

    function viewVisaOfficer(address _officerAddress)
        external
        view
        returns (
            uint,
            uint,
            address,
            bool
        )
    {
        return (
            mapVisaOfficer[_officerAddress].OfficerID,
            mapVisaOfficer[_officerAddress].issueDate,
            mapVisaOfficer[_officerAddress].issuedBy,
            mapVisaOfficer[_officerAddress].verify
        );
    }

    function viewVisa(address _citizenID)
        external
        view
        returns (Visa[] memory)
    {
        Visa[] memory data = new Visa[](mapVisa[_citizenID].length);
        for (uint index = 0; index < mapVisa[_citizenID].length; index++) {
            data[index] = mapVisa[_citizenID][index];
        }
        return (data);
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

    function verifyVisaOfficer(address _officerAddress)
        public
        view
        returns (bool)
    {
        return (mapVisaOfficer[_officerAddress].verify);
    }

    function verifyVisa(address _citizenID, uint _index)
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

    // Caste.sol

    enum CasteType {
        General,
        SC,
        ST,
        OBCA,
        OBCB
    }

    struct CasteData {
        CasteType casteType;
        uint issueDate;
        address issuedBy;
    }

    mapping(address => CasteData) internal mapCasteData;

    function setCaste(address _citizenID, CasteType _casteType) external {
        require(uint(mapGovernmentWorker[msg.sender].power) == 1);
        mapCasteData[_citizenID] = CasteData(
            _casteType,
            block.timestamp,
            msg.sender
        );
    }

    function viewCaste(address _citizenID)
        external
        view
        returns (string memory)
    {
        require(verifyBirthCertificate(_citizenID) == true);
        if (uint(mapCasteData[_citizenID].casteType) == 1) {
            return "SC";
        } else if (uint(mapCasteData[_citizenID].casteType) == 2) {
            return "ST";
        } else if (uint(mapCasteData[_citizenID].casteType) == 3) {
            return "OBC-A";
        } else if (uint(mapCasteData[_citizenID].casteType) == 4) {
            return "OBC-B";
        } else {
            return "General";
        }
    }

    function setterCaste(address _citizenID)
        external
        view
        returns (uint, address)
    {
        return (
            mapCasteData[_citizenID].issueDate,
            mapCasteData[_citizenID].issuedBy
        );
    }

    // CriminalRecord.sol

    struct CriminalRecord {
        string charges;
        uint fine;
        uint issueDate;
        address issuedBy;
    }

    mapping(address => CriminalRecord[]) internal mapCriminalRecord;

    function addCriminalRecord(
        address _citizenID,
        string memory _charges,
        uint _fine
    ) external {
        require(mapBirthCertificate[msg.sender].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
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
            uint index = 0;
            index < mapCriminalRecord[_citizenID].length;
            index++
        ) {
            data[index] = mapCriminalRecord[_citizenID][index];
        }
        return (data);
    }

    // Business.sol

    struct BusinessData {
        string businessName;
        address Owner;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => BusinessData) internal mapBusinessData;

    function setBusiness(
        address _businessAddress,
        string memory _businessName,
        address _Owner
    ) external {
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapBusinessData[_businessAddress] = BusinessData(
            _businessName,
            _Owner,
            block.timestamp,
            msg.sender,
            true
        );
    }

    function removeBusiness(address _businessAddress) external {
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapBusinessData[_businessAddress].verify = false;
    }

    function viewBusiness(address _businessAddress)
        external
        view
        returns (
            string memory,
            address,
            uint,
            address
        )
    {
        return (
            mapBusinessData[_businessAddress].businessName,
            mapBusinessData[_businessAddress].Owner,
            mapBusinessData[_businessAddress].issueDate,
            mapBusinessData[_businessAddress].issuedBy
        );
    }

    function verifyBusiness(address _businessAddress)
        public
        view
        returns (bool)
    {
        return (mapBusinessData[_businessAddress].verify);
    }

    function loginBusiness(address _businessAddress)
        external
        view
        returns (bool)
    {
        require(
            msg.sender == _businessAddress &&
                mapBusinessData[msg.sender].verify == true
        );
        return (mapBusinessData[msg.sender].verify);
    }
}
