// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Identity{
    address public contractAdmin;
    mapping(address=>bool) public citizenID;
    mapping(address=>bool) public governmentID;

    enum Vehicle{Two, Four, Six}
    enum EntityPower{A, B, C, D}

    struct BirthCertificate{
        string name;
        string gender;
        string DOB;
        string PlaceOfBirth;
        string FatherName;
        string MotherName;
        uint issueDate;
        address issuedBy;
    }

    struct Aadhar{
        uint enrolmentNumber;
        uint aadharNumber;
        uint VID;
        string gender;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct PAN{
        string PAN;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct DrivingLicense{
        Vehicle wheeler;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct VoterID{
        string referenceNumber;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct ContactDetails{
        uint contactNumber;
        string homeAddress;
        uint pinCode;
        bool verify;
    }

    struct GovernmentEntity{
        string name;
        uint issueDate;
        string gender;
        string adminNumber;
        string designation;
        EntityPower power;
    }

    mapping(address=>BirthCertificate) private mapBirthCertificate;
    mapping(address=>Aadhar) private mapAadhar;
    mapping(address=>PAN) private mapPAN;
    mapping(address=>DrivingLicense[3]) private mapDrivingLicense;
    mapping(address=>VoterID) private mapVoterID;
    mapping(address=>ContactDetails) private mapContactDetails;
    mapping(address=>GovernmentEntity) public mapGovernmentEntity;

    // Constructor
    constructor(){
        contractAdmin = msg.sender;
    }

    // Setters

    // Government Entity Setters
    function setGovernmentEntityA(address _governmentID, string memory _name, string memory _gender, string memory _adminNumber, string memory _designation) public{
        require(contractAdmin==msg.sender,"Only Contract Owner can set Government Entity A");
        require(citizenID[_governmentID]==true,"Not a Citizen");
        require(mapAadhar[_governmentID].verify==true,"Must have Aadhar");
        require(mapPAN[_governmentID].verify==true,"Must have PAN");
        mapGovernmentEntity[_governmentID] = GovernmentEntity(_name, block.timestamp, _gender, _adminNumber, _designation, EntityPower.A);
        governmentID[_governmentID]==true;
    }

    function setGovernmentEntityB(address _governmentID, string memory _name, string memory _gender, string memory _adminNumber, string memory _designation) public{
        require(governmentID[_governmentID]==false,"Already a Government Entity");
        require(citizenID[_governmentID]==true,"Not a Citizen");
        require(mapAadhar[_governmentID].verify==true,"Must have Aadhar");
        require(mapPAN[_governmentID].verify==true,"Must have PAN");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0,"Only Contract Owner and A can set Government Entity B");
        mapGovernmentEntity[_governmentID] = GovernmentEntity(_name, block.timestamp, _gender, _adminNumber, _designation, EntityPower.B);
        governmentID[_governmentID]==true;
    }

    function setGovernmentEntityC(address _governmentID, string memory _name, string memory _gender, string memory _adminNumber, string memory _designation) public{
        require(governmentID[_governmentID]==false,"Already a Government Entity");
        require(citizenID[_governmentID]==true,"Not a Citizen");
        require(mapAadhar[_governmentID].verify==true,"Must have Aadhar");
        require(mapPAN[_governmentID].verify==true,"Must have PAN");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1,"Only Contract Owner, A and B can set Government Entity C");
        mapGovernmentEntity[_governmentID] = GovernmentEntity(_name, block.timestamp, _gender, _adminNumber, _designation, EntityPower.C);
        governmentID[_governmentID]==true;
    }

    function setGovernmentEntityD(address _governmentID, string memory _name, string memory _gender, string memory _adminNumber, string memory _designation) public{
        require(governmentID[_governmentID]==false,"Already a Government Entity");
        require(citizenID[_governmentID]==true,"Not a Citizen");
        require(mapAadhar[_governmentID].verify==true,"Must have Aadhar");
        require(mapPAN[_governmentID].verify==true,"Must have PAN");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2,"Only Contract Owner, A, B and C can set Government Entity D");
        mapGovernmentEntity[_governmentID] = GovernmentEntity(_name, block.timestamp, _gender, _adminNumber, _designation, EntityPower.D);
        governmentID[_governmentID]==true;
    }

    // Public Details Setters
    function setBirthCertificate(address _citizenID, string memory _name, string memory _gender, string memory _DOB, string memory _PlaceOfBirth, string memory _FatherName, string memory _MotherName) public {
        require(citizenID[_citizenID]==false,"This  address already exists");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2 || uint((mapGovernmentEntity[msg.sender].power))==3,"Only Contract Owner, A, B, C and D Government Entities can set Birth Certificate");
        mapBirthCertificate[_citizenID] = BirthCertificate(_name, _gender, _DOB, _PlaceOfBirth, _FatherName, _MotherName, block.timestamp, msg.sender);
        citizenID[_citizenID]=true;
    }

    function setAadhar(address _citizenID, uint _enrolmentNumber, uint _aadharNumber, uint _VID, string memory _gender) public {
        require(citizenID[_citizenID]==true,"Must have Birth Certificate");
        require(mapContactDetails[_citizenID].verify==true,"First add your contact details");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2 || uint((mapGovernmentEntity[msg.sender].power))==3,"Only Contract Owner, A, B, C and D Government Entities can set Aadhar");
        mapAadhar[_citizenID] = Aadhar(_enrolmentNumber, _aadharNumber, _VID, _gender, block.timestamp, msg.sender, true);
    }

    function setPAN(address _citizenID, string memory _PAN) public {
        require(citizenID[_citizenID]==true,"Must have Birth Certificate");
        require(mapAadhar[_citizenID].verify==true,"Must have Aadhar");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2 || uint((mapGovernmentEntity[msg.sender].power))==3,"Only Contract Owner, A, B, C and D Government Entities can set Aadhar");
        mapPAN[_citizenID] = PAN(_PAN, block.timestamp, msg.sender, true);
    }

    function set2WheelerLicense(address _citizenID) public {
        require(citizenID[_citizenID]==true,"Must have Birth Certificate");
        require(mapAadhar[_citizenID].verify==true,"Must have Aadhar");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2 || uint((mapGovernmentEntity[msg.sender].power))==3,"Only Contract Owner, A, B, C and D Government Entities can set Aadhar");
        mapDrivingLicense[_citizenID][0]=(DrivingLicense({
            wheeler:Vehicle.Two,
            issueDate:block.timestamp,
            issuedBy:msg.sender,
            verify:true
        }));
    }

    function set4WheelerLicense(address _citizenID) public {
        require(citizenID[_citizenID]==true,"Must have Birth Certificate");
        require(mapAadhar[_citizenID].verify==true,"Must have Aadhar");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2 || uint((mapGovernmentEntity[msg.sender].power))==3,"Only Contract Owner, A, B, C and D Government Entities can set Aadhar");
        mapDrivingLicense[_citizenID][1]=(DrivingLicense({
            wheeler:Vehicle.Four,
            issueDate:block.timestamp,
            issuedBy:msg.sender,
            verify:true
        }));
    }

    function set6WheelerLicense(address _citizenID) public {
        require(citizenID[_citizenID]==true,"Must have Birth Certificate");
        require(mapAadhar[_citizenID].verify==true,"Must have Aadhar");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2 || uint((mapGovernmentEntity[msg.sender].power))==3,"Only Contract Owner, A, B, C and D Government Entities can set Aadhar");
        mapDrivingLicense[_citizenID][2]=(DrivingLicense({
            wheeler:Vehicle.Six,
            issueDate:block.timestamp,
            issuedBy:msg.sender,
            verify:true
        }));
    }

    function setVoterID(address _citizenID, string memory _referenceNumber) public {
        require(citizenID[_citizenID]==true,"Must have Birth Certificate");
        require(mapAadhar[_citizenID].verify==true,"Must have Aadhar");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2 || uint((mapGovernmentEntity[msg.sender].power))==3,"Only Contract Owner, A, B, C and D Government Entities can set Aadhar");
        mapVoterID[_citizenID] = VoterID(_referenceNumber, block.timestamp, msg.sender, true);
    }

    function setContactDetails(address _citizenID, uint _contactNumber, string memory _homeAddress, uint _pinCode) public {
        require(citizenID[_citizenID]==true,"Must have Birth Certificate");
        require(contractAdmin==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2 || uint((mapGovernmentEntity[msg.sender].power))==3,"Only Contract Owner, A, B, C and D Government Entities can set Aadhar");
        mapContactDetails[_citizenID] = ContactDetails(_contactNumber, _homeAddress, _pinCode, true);
    }

    // Getters

    // Government view
    function viewDetails(address _citizenID) public view returns(string memory, string memory, string memory, string memory, string memory, string memory){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        require(contractAdmin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2,"You must be a Government Entity or Owner of _citizenID");
        return(mapBirthCertificate[_citizenID].name, mapBirthCertificate[_citizenID].gender, mapBirthCertificate[_citizenID].DOB, mapBirthCertificate[_citizenID].PlaceOfBirth, mapBirthCertificate[_citizenID].FatherName, mapBirthCertificate[_citizenID].MotherName);
    }

    function viewAadhar(address _citizenID) public view returns(uint, uint, uint, string memory, uint, address){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        require(contractAdmin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2,"You must be a Government Entity or Owner of _citizenID");
        return(mapAadhar[_citizenID].enrolmentNumber, mapAadhar[_citizenID].aadharNumber, mapAadhar[_citizenID].VID, mapAadhar[_citizenID].gender, mapAadhar[_citizenID].issueDate, mapAadhar[_citizenID].issuedBy);
    }

    function viewPAN(address _citizenID) public view returns(string memory, uint, address){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        require(contractAdmin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2,"You must be a Government Entity or Owner of _citizenID");
        return(mapPAN[_citizenID].PAN, mapPAN[_citizenID].issueDate, mapPAN[_citizenID].issuedBy);
    }

    function viewDrivingLicense(address _citizenID) public view returns(DrivingLicense[] memory){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        require(contractAdmin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2,"You must be a Government Entity or Owner of _citizenID");
        DrivingLicense[] memory data = new DrivingLicense[](mapDrivingLicense[_citizenID].length);
        for(uint index=0; index<mapDrivingLicense[_citizenID].length; index++){
            data[index] = mapDrivingLicense[_citizenID][index];
        }
        return(data);
    }

    function viewVoterID(address _citizenID) public view returns(string memory, uint, address){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        require(contractAdmin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2,"You must be a Government Entity or Owner of _citizenID");
        return(mapVoterID[_citizenID].referenceNumber, mapVoterID[_citizenID].issueDate, mapVoterID[_citizenID].issuedBy);
    }

    function viewContactDetails(address _citizenID) public view returns(uint, string memory, uint){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        require(contractAdmin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentEntity[msg.sender].power))==0 || uint((mapGovernmentEntity[msg.sender].power))==1 || uint((mapGovernmentEntity[msg.sender].power))==2,"You must be a Government Entity or Owner of _citizenID");
        return(mapContactDetails[_citizenID].contactNumber, mapContactDetails[_citizenID].homeAddress, mapContactDetails[_citizenID].pinCode);
    }

    // Public view
    function verifyDetails(address _citizenID) public view returns(string memory, string memory, string memory, string memory, string memory){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        return(mapBirthCertificate[_citizenID].name, mapBirthCertificate[_citizenID].gender, mapBirthCertificate[_citizenID].DOB, mapBirthCertificate[_citizenID].FatherName, mapBirthCertificate[_citizenID].MotherName);
    }

    function verifyAadhar(address _citizenID) public view returns(bool){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        return(mapAadhar[_citizenID].verify);
    }

    function verifyPAN(address _citizenID) public view returns(bool){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        return(mapPAN[_citizenID].verify);
    }

    function verify2WheelerLicense(address _citizenID) public view returns(bool){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        return(mapDrivingLicense[_citizenID][0].verify);
    }

    function verify4WheelerLicense(address _citizenID) public view returns(bool){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        return(mapDrivingLicense[_citizenID][1].verify);
    }

    function verify6WheelerLicense(address _citizenID) public view returns(bool){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        return(mapDrivingLicense[_citizenID][2].verify);
    }

    function verifyVoterID(address _citizenID) public view returns(bool){
        require(citizenID[_citizenID]==true,"Not a Citizen");
        return(mapVoterID[_citizenID].verify);
    }

}
