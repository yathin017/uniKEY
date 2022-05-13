// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Aadhar.sol";

contract DrivingLicense is Aadhar {
    enum Vehicle {
        Two,
        Four
    }

    struct DrivingLicenseData {
        Vehicle wheeler;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => DrivingLicenseData[2]) internal mapDrivingLicenseData;

    function set2WheelerLicense(address _citizenID) external {
        // 567648000 = 18 years
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        require(
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        );
        require(verifyAadharData(_citizenID) == true);
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
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        require(
            block.timestamp - mapBirthCertificate[_citizenID].DOB >= 567648000
        );
        require(verifyAadharData(_citizenID) == true);
        mapDrivingLicenseData[_citizenID][1] = (
            DrivingLicenseData({
                wheeler: Vehicle.Two,
                issueDate: block.timestamp,
                issuedBy: msg.sender,
                verify: true
            })
        );
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
            uint256 index = 0;
            index < mapDrivingLicenseData[_citizenID].length;
            index++
        ) {
            data[index] = mapDrivingLicenseData[_citizenID][index];
        }
        return (data);
    }

    function verify2WheelerLicense(address _citizenID)
        public
        view
        returns (bool)
    {
        return (mapDrivingLicenseData[_citizenID][0].verify);
    }

    function view2WheelerLicense(address _citizenID)
        external
        view
        returns (
            uint256,
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

    function remove2WheelerLicense(address _citizenID) external {
        require(mapDrivingLicenseData[_citizenID][0].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapDrivingLicenseData[_citizenID][0].verify = false;
    }

    function verify4WheelerLicense(address _citizenID)
        public
        view
        returns (bool)
    {
        return (mapDrivingLicenseData[_citizenID][1].verify);
    }

    function view4WheelerLicense(address _citizenID)
        external
        view
        returns (
            uint256,
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

    function remove4WheelerLicense(address _citizenID) external {
        require(mapDrivingLicenseData[_citizenID][1].verify == true);
        require(
            mapAdminData[msg.sender].verify == true ||
                verifyGovernmentWorker(msg.sender) == true
        );
        mapDrivingLicenseData[_citizenID][1].verify = false;
    }
}
