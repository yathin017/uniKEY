// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Identity2{
    address public Admin;

    enum Vehicle{Two, Four}
    enum EntityPower{A, B}

    struct BirthCertificate{
        string name;
        string gender;
        string DOB;
        string PlaceOfBirth;
        address FatherID;
        address MotherID;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct Aadhar{
        uint enrollmentNumber;
        uint aadharNumber;
        uint VID;
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
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct GovernmentServant{
        string name;
        uint issueDate;
        string gender;
        string adminNumber;
        string designation;
        bool verify;
        EntityPower power;
    }

    mapping(address=>BirthCertificate) private mapBirthCertificate;
    mapping(address=>Aadhar) private mapAadhar;
    mapping(address=>PAN) private mapPAN;
    mapping(address=>DrivingLicense[2]) private mapDrivingLicense;
    mapping(address=>VoterID) private mapVoterID;
    mapping(address=>ContactDetails) private mapContactDetails;
    mapping(address=>GovernmentServant) public mapGovernmentServant;

    // Modifiers
    modifier onlyGovernment(){
        require(Admin==msg.sender || uint(mapGovernmentServant[msg.sender].power)==0 || uint(mapGovernmentServant[msg.sender].power)==1,"Only Admin, A and B Government Servants can use this function");
        _;
    }

    // Constructor
    constructor(){
        Admin = msg.sender;
    }

    // Hiring Government Servants
    function hireGovernmentServantA(address _governmentID, string memory _name, string memory _gender, string memory _adminNumber, string memory _designation) public{
        require(Admin==msg.sender,"Only Contract Owner can set Government Entity A");
        require(mapAadhar[_governmentID].verify==true,"Must have Aadhar");
        require(mapPAN[_governmentID].verify==true,"Must have PAN");
        mapGovernmentServant[_governmentID] = GovernmentServant(_name, block.timestamp, _gender, _adminNumber, _designation, true, EntityPower.A);
    }

    function hireGovernmentServantB(address _governmentID, string memory _name, string memory _gender, string memory _adminNumber, string memory _designation) public{
        require(mapAadhar[_governmentID].verify==true,"Must have Aadhar");
        require(mapPAN[_governmentID].verify==true,"Must have PAN");
        require(Admin==msg.sender || uint((mapGovernmentServant[msg.sender].power))==0,"Only Contract Owner and A can set Government Entity B");
        mapGovernmentServant[_governmentID] = GovernmentServant(_name, block.timestamp, _gender, _adminNumber, _designation, true, EntityPower.B);
    }

    function removeGovernmentServant(address _governmentID) public{
        require(Admin==msg.sender);
        mapGovernmentServant[_governmentID].verify=false;
    }

    // Add Public Details
    function setBirthCertificate(address _citizenID, string memory _name, string memory _gender, string memory _DOB, string memory _PlaceOfBirth, address _FatherID, address _MotherID) public onlyGovernment{
        require(mapBirthCertificate[_citizenID].verify==false,"This  address already exists");
        require(mapPAN[_FatherID].verify==true);
        require(mapPAN[_MotherID].verify==true);
        mapBirthCertificate[_citizenID] = BirthCertificate(_name, _gender, _DOB, _PlaceOfBirth, _FatherID, _MotherID, block.timestamp, msg.sender, true);
    }

    function setAadhar(address _citizenID, uint _enrolmentNumber, uint _aadharNumber, uint _VID) public onlyGovernment{
        require(mapBirthCertificate[_citizenID].verify==true,"Must have Birth Certificate");
        require(mapContactDetails[_citizenID].verify==true,"First add your contact details");
        mapAadhar[_citizenID] = Aadhar(_enrolmentNumber, _aadharNumber, _VID, block.timestamp, msg.sender, true);
    }

    function setPAN(address _citizenID, string memory _PAN) public onlyGovernment{
        require(mapBirthCertificate[_citizenID].verify==true,"Must have Birth Certificate");
        require(mapAadhar[_citizenID].verify==true,"Must have Aadhar");
        mapPAN[_citizenID] = PAN(_PAN, block.timestamp, msg.sender, true);
    }

    function set2WheelerLicense(address _citizenID) public onlyGovernment{
        require(mapAadhar[_citizenID].verify==true,"Must have Aadhar");
        mapDrivingLicense[_citizenID][0]=(DrivingLicense({
            wheeler:Vehicle.Two,
            issueDate:block.timestamp,
            issuedBy:msg.sender,
            verify:true
        }));
    }

    function set4WheelerLicense(address _citizenID) public onlyGovernment{
        require(mapAadhar[_citizenID].verify==true,"Must have Aadhar");
        mapDrivingLicense[_citizenID][1]=(DrivingLicense({
            wheeler:Vehicle.Two,
            issueDate:block.timestamp,
            issuedBy:msg.sender,
            verify:true
        }));
    }

    function setVoterID(address _citizenID, string memory _referenceNumber) public onlyGovernment{
        require(mapAadhar[_citizenID].verify==true,"Must have Aadhar");
        mapVoterID[_citizenID] = VoterID(_referenceNumber, block.timestamp, msg.sender, true);
    }

    function setContactDetails(address _citizenID, uint _contactNumber, string memory _homeAddress, uint _pinCode) public onlyGovernment{
        require(mapBirthCertificate[_citizenID].verify==true,"Must have Birth Certificate");
        mapContactDetails[_citizenID] = ContactDetails(_contactNumber, _homeAddress, _pinCode, block.timestamp, msg.sender, true);
    }

    // View Public Details -> Government and Owner
    function viewDetails(address _citizenID) public view returns(string memory, string memory, string memory, string memory, address, address){
        require(mapBirthCertificate[_citizenID].verify==true,"Not a Citizen");
        require(Admin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentServant[msg.sender].power))==0,"You must be a Government Entity or Owner of _citizenID");
        return(mapBirthCertificate[_citizenID].name, mapBirthCertificate[_citizenID].gender, mapBirthCertificate[_citizenID].DOB, mapBirthCertificate[_citizenID].PlaceOfBirth, mapBirthCertificate[_citizenID].FatherID, mapBirthCertificate[_citizenID].MotherID);
    }

    function viewAadhar(address _citizenID) public view returns(uint, uint, uint, uint, address){
        require(mapBirthCertificate[_citizenID].verify==true,"Not a Citizen");
        require(Admin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentServant[msg.sender].power))==0,"You must be a Government Entity or Owner of _citizenID");
        return(mapAadhar[_citizenID].enrollmentNumber, mapAadhar[_citizenID].aadharNumber, mapAadhar[_citizenID].VID, mapAadhar[_citizenID].issueDate, mapAadhar[_citizenID].issuedBy);
    }

    function viewPAN(address _citizenID) public view returns(string memory, uint, address){
        require(mapBirthCertificate[_citizenID].verify==true,"Not a Citizen");
        require(Admin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentServant[msg.sender].power))==0,"You must be a Government Entity or Owner of _citizenID");
        return(mapPAN[_citizenID].PAN, mapPAN[_citizenID].issueDate, mapPAN[_citizenID].issuedBy);
    }

    function viewDrivingLicense(address _citizenID) public view returns(DrivingLicense[] memory){
        require(mapBirthCertificate[_citizenID].verify==true,"Not a Citizen");
        require(Admin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentServant[msg.sender].power))==0,"You must be a Government Entity or Owner of _citizenID");
        DrivingLicense[] memory data = new DrivingLicense[](mapDrivingLicense[_citizenID].length);
        for(uint index=0; index<mapDrivingLicense[_citizenID].length; index++){
            data[index] = mapDrivingLicense[_citizenID][index];
        }
        return(data);
    }

    function viewVoterID(address _citizenID) public view returns(string memory, uint, address){
        require(mapBirthCertificate[_citizenID].verify==true,"Not a Citizen");
        require(Admin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentServant[msg.sender].power))==0,"You must be a Government Entity or Owner of _citizenID");
        return(mapVoterID[_citizenID].referenceNumber, mapVoterID[_citizenID].issueDate, mapVoterID[_citizenID].issuedBy);
    }

    function viewContactDetails(address _citizenID) public view returns(uint, string memory, uint, uint, address){
        require(mapBirthCertificate[_citizenID].verify==true,"Not a Citizen");
        require(Admin==msg.sender || _citizenID==msg.sender || uint((mapGovernmentServant[msg.sender].power))==0,"You must be a Government Entity or Owner of _citizenID");
        return(mapContactDetails[_citizenID].contactNumber, mapContactDetails[_citizenID].homeAddress, mapContactDetails[_citizenID].pinCode, mapContactDetails[_citizenID].issueDate, mapContactDetails[_citizenID].issuedBy);
    }

    // View Public Details -> Citizens
    function verifyDetails(address _citizenID) public view returns(string memory, string memory, string memory, address, address){
        return(mapBirthCertificate[_citizenID].name, mapBirthCertificate[_citizenID].gender, mapBirthCertificate[_citizenID].DOB, mapBirthCertificate[_citizenID].FatherID, mapBirthCertificate[_citizenID].MotherID);
    }

    function verifyAadhar(address _citizenID) public view returns(bool){
        return(mapAadhar[_citizenID].verify);
    }

    function verifyPAN(address _citizenID) public view returns(bool){
        return(mapPAN[_citizenID].verify);
    }

    function verify2WheelerLicense(address _citizenID) public view returns(bool){
        return(mapDrivingLicense[_citizenID][0].verify);
    }

    function verify4WheelerLicense(address _citizenID) public view returns(bool){
        return(mapDrivingLicense[_citizenID][1].verify);
    }

    function verifyVoterID(address _citizenID) public view returns(bool){
        return(mapVoterID[_citizenID].verify);
    }
}
