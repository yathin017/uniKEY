// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract Biometrics is Identity{

    struct verifyHandBiometrics{
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct verifyIrisBiometrics{
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct RightHand{
        uint Finger1;
        uint Finger2;
        uint Finger3;
        uint Finger4;
        uint Finger5;
    }

    struct LeftHand{
        uint Finger1;
        uint Finger2;
        uint Finger3;
        uint Finger4;
        uint Finger5;
    }

    struct RightIris{
        uint Iris;
    }

    struct LeftIris{
        uint Iris;
    }

    mapping(address=>RightHand) mapRightHand;
    mapping(address=>LeftHand) mapLeftHand;
    mapping(address=>RightIris) mapRightIris;
    mapping(address=>LeftIris) mapLeftIris;
    mapping(address=>verifyHandBiometrics) mapverifyHandBiometrics;
    mapping(address=>verifyHandBiometrics) mapverifyIrisBiometrics;

    function addBiometrics(address _citizenID, uint _RightFinger1, uint _RightFinger2, uint _RightFinger3, uint _RightFinger4, uint _RightFinger5, uint _LeftFinger1, uint _LeftFinger2, uint _LeftFinger3, uint _LeftFinger4, uint _LeftFinger5) public{
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        mapRightHand[_citizenID].Finger1 = uint(sha256(abi.encodePacked(_RightFinger1)));
        mapRightHand[_citizenID].Finger2 = uint(sha256(abi.encodePacked(_RightFinger2)));
        mapRightHand[_citizenID].Finger3 = uint(sha256(abi.encodePacked(_RightFinger3)));
        mapRightHand[_citizenID].Finger4 = uint(sha256(abi.encodePacked(_RightFinger4)));
        mapRightHand[_citizenID].Finger5 = uint(sha256(abi.encodePacked(_RightFinger5)));
        mapLeftHand[_citizenID].Finger1 = uint(sha256(abi.encodePacked(_LeftFinger1)));
        mapLeftHand[_citizenID].Finger2 = uint(sha256(abi.encodePacked(_LeftFinger2)));
        mapLeftHand[_citizenID].Finger3 = uint(sha256(abi.encodePacked(_LeftFinger3)));
        mapLeftHand[_citizenID].Finger4 = uint(sha256(abi.encodePacked(_LeftFinger4)));
        mapLeftHand[_citizenID].Finger5 = uint(sha256(abi.encodePacked(_LeftFinger5)));
        mapverifyHandBiometrics[_citizenID].issueDate = block.timestamp;
        mapverifyHandBiometrics[_citizenID].issuedBy = msg.sender;
        mapverifyHandBiometrics[_citizenID].verify = true;
    }

    function addBiometrics(address _citizenID, uint _RightIris, uint _LeftIris) public{
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        mapRightIris[_citizenID].Iris = uint(sha256(abi.encodePacked(_RightIris)));
        mapLeftIris[_citizenID].Iris = uint(sha256(abi.encodePacked(_LeftIris)));
        mapverifyIrisBiometrics[_citizenID].issueDate = block.timestamp;
        mapverifyIrisBiometrics[_citizenID].issuedBy = msg.sender;
        mapverifyIrisBiometrics[_citizenID].verify = true;
    }

    function verifyBiometrics(address _citizenID) public view returns(bool){
        if(block.timestamp-mapverifyHandBiometrics[_citizenID].issueDate<=315569260 && mapverifyHandBiometrics[_citizenID].verify==true){
            if(block.timestamp-mapverifyIrisBiometrics[_citizenID].issueDate<=315569260 && mapverifyIrisBiometrics[_citizenID].verify==true){
                return true;
            }
            else{
                return false;
            }
        }
        else{
            return false;
        }
    }
    
}
