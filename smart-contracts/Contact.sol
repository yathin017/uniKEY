// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract Contact is Identity{

    struct ContactData{
        uint contactNumber;
        string homeAddress;
        uint pinCode;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address=>ContactData) private mapContactData;

    function setContactData(address _citizenID, uint _contactNumber, string memory _homeAddress, uint _pinCode) public{
        require(mapBirthCertificate[_citizenID].verify==true,"Must have Birth Certificate");
        require(mapGovernmentWorker[msg.sender].verify==true);
        mapContactData[_citizenID] = ContactData(_contactNumber, _homeAddress, _pinCode, block.timestamp, msg.sender, true);
    }

    function removeContactData(address _citizenID) public{
        require(mapContactData[_citizenID].verify==true);
        require(mapGovernmentWorker[msg.sender].verify==true);
        mapContactData[_citizenID].verify=false;
    }

    function viewContactData(address _citizenID) public view returns(uint, string memory, uint, uint, address){
        require(mapBirthCertificate[_citizenID].verify==true,"Not a Citizen");
        require(_citizenID==msg.sender || uint((mapGovernmentWorker[msg.sender].power))==0,"You must be a Government Entity or Owner of _citizenID");
        return(mapContactData[_citizenID].contactNumber, mapContactData[_citizenID].homeAddress, mapContactData[_citizenID].pinCode, mapContactData[_citizenID].issueDate, mapContactData[_citizenID].issuedBy);
    }
}
