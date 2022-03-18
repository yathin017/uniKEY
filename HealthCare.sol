// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract HealthCare{
    address public contractAdmin;
    mapping(address=>bool) public patientID;
    mapping(address=>bool) public hospitalID;

    struct patientInfo{
        string patientName;
        string DOB;
        string bloodGroup;
        string gender;
    }

    struct hospitalInfo{
        string hospitalName;
        string DOR;
        string regNo;
    }

    struct patientRecord{
        string hospitalName;
        string doctorName;
        uint issueDate;
        string healthIssue;
        string medicines;
        string reportAnalysis;
        string diagnosys;
    }

    struct Viewer{
        mapping(address=>bool) viewerID;
    }

    mapping(address=>patientInfo) public viewPatientInfo;
    mapping(address=>hospitalInfo) public viewHospitalInfo;
    mapping(address=>patientRecord[]) private viewPatientRecord;
    mapping(address=>Viewer) private viewers;

    constructor(){
        contractAdmin = msg.sender;
    }

    function setPatientInfo(address _patientID, string memory _patientName, string memory _DOB, string memory _bloodGroup, string memory _gender) public{
        require(patientID[_patientID]==false,"You are already an existing user");
        require(_patientID==msg.sender,"Use your account to add details");
        require(viewPatientRecord[_patientID].length==0,"This account is removed from services... Please try with different account");
        viewPatientInfo[_patientID] = patientInfo(_patientName, _DOB, _bloodGroup, _gender);
        patientID[_patientID] = true;
    }

    function setHospitalInfo(address _hospitalID, string memory _hospitalName, string memory _DOR, string memory _regNo) public{
        require(contractAdmin==msg.sender);
        viewHospitalInfo[_hospitalID] = hospitalInfo(_hospitalName, _DOR, _regNo);
        hospitalID[_hospitalID] = true;
    }

    function setPatientRecord(address _patientID, string memory _hospitalName, string memory _doctorName, string memory _healthIssue, string memory _medicines, string memory _reportAnalysis, string memory _diagnosys) public{
        require(patientID[_patientID]==true,"Set Patient Information First");
        require(hospitalID[msg.sender]==true,"You cannot set Patient's Record");
        viewPatientRecord[_patientID].push(patientRecord({
            hospitalName:_hospitalName,
            doctorName:_doctorName,
            issueDate:block.timestamp,
            healthIssue:_healthIssue,
            medicines:_medicines,
            reportAnalysis:_reportAnalysis,
            diagnosys:_diagnosys
        }));
        viewers[_patientID].viewerID[msg.sender]=true;
    }

    function recentPatientRecord(address _patientID) public view returns(patientRecord memory){
        require(patientID[_patientID]==true,"Set Patient Information First");
        require(viewPatientRecord[_patientID].length>0,"No Patient Record");
        require(_patientID==msg.sender || viewers[_patientID].viewerID[msg.sender]==true,"You cannot view this information");
        uint index = viewPatientRecord[_patientID].length-1;
        return (viewPatientRecord[_patientID][index]);
    }

    function AllPatientRecord(address _patientID) public view returns(patientRecord[] memory){
        require(patientID[_patientID]==true,"Set Patient Information First");
        require(viewPatientRecord[_patientID].length>0,"No Patient Record");
        require(_patientID==msg.sender || viewers[_patientID].viewerID[msg.sender]==true,"You cannot view this information");
        patientRecord[] memory data = new patientRecord[](viewPatientRecord[_patientID].length);
        for(uint index=0; index<viewPatientRecord[_patientID].length; index++){
            data[index] = viewPatientRecord[_patientID][index];
        }
        return (data);
    }

    function removeHospital(address _hospitalID) public{
        require(contractAdmin==msg.sender);
        require(hospitalID[_hospitalID]==true,"Hospital does not exist");
        hospitalID[_hospitalID] = false;
    }

    function removePatient(address _patientID) public{
        require(contractAdmin==msg.sender || _patientID==msg.sender);
        patientID[_patientID] = false;
    }

    function removeViewer(address _viewerID) public{
        require(patientID[msg.sender]==true,"Set Patient Information First");
        viewers[msg.sender].viewerID[_viewerID]=false;
    }
    
}
