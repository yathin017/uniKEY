// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract Healthcare is Identity {
    struct hospitalInfo {
        string hospitalName;
        uint256 DOR;
        string regNo;
        uint256 issueDate;
        address issuedBy;
        bool verify;
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

    mapping(address => bool) private hospitalID;
    mapping(address => hospitalInfo) private viewHospitalInfo;
    mapping(address => patientRecord[]) private viewPatientRecord;
    mapping(address => Viewer) private viewers;
    mapping(address => address[]) private allViewers;

    function setHospitalInfo(
        address _hospitalID,
        string memory _hospitalName,
        uint256 _DOR,
        string memory _regNo
    ) public {
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
        );
        viewHospitalInfo[_hospitalID] = hospitalInfo(
            _hospitalName,
            _DOR,
            _regNo,
            block.timestamp,
            msg.sender,
            true
        );
        hospitalID[_hospitalID] = true;
    }

    function viewHospital(address _hospitalID)
        public
        view
        returns (
            string memory,
            uint256,
            string memory
        )
    {
        return (
            viewHospitalInfo[_hospitalID].hospitalName,
            viewHospitalInfo[_hospitalID].DOR,
            viewHospitalInfo[_hospitalID].regNo
        );
    }

    function verifyHospital(address _hospitalID) public view returns (bool) {
        return (viewHospitalInfo[_hospitalID].verify);
    }

    function setterHospital(address _hospitalID)
        public
        view
        returns (uint256, address)
    {
        return (
            viewHospitalInfo[_hospitalID].issueDate,
            viewHospitalInfo[_hospitalID].issuedBy
        );
    }

    function removeHospital(address _hospitalID) public {
        require(verifyAdmin(msg.sender) == true);
        require(hospitalID[_hospitalID] == true);
        hospitalID[_hospitalID] = false;
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
        require(verifyBirthCertificate(_patientID) == true);
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
        require(verifyBirthCertificate(_patientID) == true);
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

    function addViewer(address _viewerID) public {
        require(verifyBirthCertificate(msg.sender) == true);
        require(viewers[msg.sender].viewerID[_viewerID] == false);
        viewers[msg.sender].viewerID[_viewerID] = true;
        allViewers[msg.sender].push(_viewerID);
    }

    function removeViewer(address _viewerID) public {
        require(verifyBirthCertificate(msg.sender) == true);
        require(viewers[msg.sender].viewerID[_viewerID] == true);
        viewers[msg.sender].viewerID[_viewerID] = false;
    }

    function removeAllViewers() public {
        require(verifyBirthCertificate(msg.sender) == true);
        for (uint256 i = 0; i < allViewers[msg.sender].length; i++) {
            viewers[msg.sender].viewerID[allViewers[msg.sender][i]] = false;
        }
        delete allViewers[msg.sender];
    }
}
