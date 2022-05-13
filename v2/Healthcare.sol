// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract CriminalRecords is Identity {
    struct hospitalInfo {
        string hospitalName;
        string DOR;
        string regNo;
    }

    struct patientRecord {
        string hospitalName;
        string doctorName;
        uint256 issueDate;
        string healthIssue;
        string medicines;
        string reportAnalysis;
        string diagnosys;
        address issuedBy;
    }

    struct Viewer {
        mapping(address => bool) viewerID;
    }

    mapping(address => bool) public hospitalID;
    mapping(address => hospitalInfo) public viewHospitalInfo;
    mapping(address => patientRecord[]) private viewPatientRecord;
    mapping(address => Viewer) private viewers;
    mapping(address => address[]) private allViewers;

    function setHospitalInfo(
        address _hospitalID,
        string memory _hospitalName,
        string memory _DOR,
        string memory _regNo
    ) public {
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        viewHospitalInfo[_hospitalID] = hospitalInfo(
            _hospitalName,
            _DOR,
            _regNo
        );
        hospitalID[_hospitalID] = true;
    }

    function setPatientRecord(
        address _patientID,
        string memory _hospitalName,
        string memory _doctorName,
        string memory _healthIssue,
        string memory _medicines,
        string memory _reportAnalysis,
        string memory _diagnosys,
        address _issuedBy
    ) public {
        require(mapBirthCertificate[_patientID].verify == true);
        require(hospitalID[msg.sender] == true);
        viewPatientRecord[_patientID].push(
            patientRecord({
                hospitalName: _hospitalName,
                doctorName: _doctorName,
                issueDate: block.timestamp,
                healthIssue: _healthIssue,
                medicines: _medicines,
                reportAnalysis: _reportAnalysis,
                diagnosys: _diagnosys,
                issuedBy: _issuedBy
            })
        );
        viewers[_patientID].viewerID[msg.sender] = true;
        allViewers[_patientID].push(msg.sender);
    }

    function recentPatientRecord(address _patientID)
        public
        view
        returns (patientRecord memory)
    {
        require(mapBirthCertificate[_patientID].verify == true);
        require(viewPatientRecord[_patientID].length > 0);
        require(
            _patientID == msg.sender ||
                viewers[_patientID].viewerID[msg.sender] == true
        );
        uint256 index = viewPatientRecord[_patientID].length - 1;
        return (viewPatientRecord[_patientID][index]);
    }

    function AllPatientRecord(address _patientID)
        public
        view
        returns (patientRecord[] memory)
    {
        require(viewPatientRecord[_patientID].length > 0);
        require(
            _patientID == msg.sender ||
                viewers[_patientID].viewerID[msg.sender] == true
        );
        patientRecord[] memory data = new patientRecord[](
            viewPatientRecord[_patientID].length
        );
        for (
            uint256 index = 0;
            index < viewPatientRecord[_patientID].length;
            index++
        ) {
            data[index] = viewPatientRecord[_patientID][index];
        }
        return (data);
    }

    function removeHospital(address _hospitalID) public {
        require(mapAdminData[msg.sender].verify == true);
        require(hospitalID[_hospitalID] == true);
        hospitalID[_hospitalID] = false;
    }

    function addViewer(address _viewerID) public {
        require(mapBirthCertificate[msg.sender].verify == true);
        require(viewers[msg.sender].viewerID[_viewerID] == false);
        viewers[msg.sender].viewerID[_viewerID] = true;
        allViewers[msg.sender].push(_viewerID);
    }

    function removeViewer(address _viewerID) public {
        require(mapBirthCertificate[msg.sender].verify == true);
        require(viewers[msg.sender].viewerID[_viewerID] == true);
        viewers[msg.sender].viewerID[_viewerID] = false;
    }

    function removeAllViewers() public {
        require(mapBirthCertificate[msg.sender].verify == true);
        for (uint256 i = 0; i < allViewers[msg.sender].length; i++) {
            viewers[msg.sender].viewerID[allViewers[msg.sender][i]] = false;
        }
        delete allViewers[msg.sender];
    }
}
