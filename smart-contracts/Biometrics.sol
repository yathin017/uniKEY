// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Identity.sol";

contract Biometrics is Identity{

    struct Face{
        string hash;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct Iris{
        uint rightIris;
        uint leftIris;
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    struct RightHand{
        uint rightFinger1;
        uint rightFinger2;
        uint rightFinger3;
        uint rightFinger4;
        uint rightFinger5;
    }

    struct LeftHand{
        uint leftFinger1;
        uint leftFinger2;
        uint leftFinger3;
        uint leftFinger4;
        uint leftFinger5;
    }

    struct verifyHand{
        uint issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address=>Face) public mapFace;
    mapping(address=>Iris) public mapIris;
    mapping(address=>RightHand) public mapRightHand;
    mapping(address=>LeftHand) public mapLeftHand;
    mapping(address=>verifyHand) public mapverifyHand;

    function setBiometricsFace(address _citizenID, string memory _hash) public{
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        mapFace[_citizenID].hash = _hash;
        mapFace[_citizenID].issueDate = block.timestamp;
        mapFace[_citizenID].issuedBy = msg.sender;
        mapIris[_citizenID].verify = true;
    }

    function setBiometricsIris(address _citizenID, uint _RightIris, uint _LeftIris) public{
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        mapIris[_citizenID].rightIris = uint(sha256(abi.encodePacked(_RightIris)));
        mapIris[_citizenID].leftIris = uint(sha256(abi.encodePacked(_LeftIris)));
        mapIris[_citizenID].issueDate = block.timestamp;
        mapIris[_citizenID].issuedBy = msg.sender;
        mapIris[_citizenID].verify = true;
    }

    function setBiometricsFingerPrint(address _citizenID, uint _RightFinger1, uint _RightFinger2, uint _RightFinger3, uint _RightFinger4, uint _RightFinger5, uint _LeftFinger1, uint _LeftFinger2, uint _LeftFinger3, uint _LeftFinger4, uint _LeftFinger5) public{
        require(
            mapAdminData[msg.sender].verify == true ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 0 ||
                uint256((mapGovernmentWorker[msg.sender].power)) == 1
        );
        mapRightHand[_citizenID].rightFinger1 = uint(sha256(abi.encodePacked(_RightFinger1)));
        mapRightHand[_citizenID].rightFinger2 = uint(sha256(abi.encodePacked(_RightFinger2)));
        mapRightHand[_citizenID].rightFinger3 = uint(sha256(abi.encodePacked(_RightFinger3)));
        mapRightHand[_citizenID].rightFinger4 = uint(sha256(abi.encodePacked(_RightFinger4)));
        mapRightHand[_citizenID].rightFinger5 = uint(sha256(abi.encodePacked(_RightFinger5)));
        mapLeftHand[_citizenID].leftFinger1 = uint(sha256(abi.encodePacked(_LeftFinger1)));
        mapLeftHand[_citizenID].leftFinger2 = uint(sha256(abi.encodePacked(_LeftFinger2)));
        mapLeftHand[_citizenID].leftFinger3 = uint(sha256(abi.encodePacked(_LeftFinger3)));
        mapLeftHand[_citizenID].leftFinger4 = uint(sha256(abi.encodePacked(_LeftFinger4)));
        mapLeftHand[_citizenID].leftFinger5 = uint(sha256(abi.encodePacked(_LeftFinger5)));
        mapverifyHand[_citizenID].issueDate = block.timestamp;
        mapverifyHand[_citizenID].issuedBy = msg.sender;
        mapverifyHand[_citizenID].verify = true;
    }

    function viewFace(address _citizenID) public view returns(string memory){
        return mapFace[_citizenID].hash;
    }

    function verifyBiometricsIris(address _citizenID, uint _RightIris, uint _LeftIris) public view returns(bool){
        if(mapIris[_citizenID].rightIris==_RightIris || mapIris[_citizenID].leftIris==_LeftIris){
            return true;
        }
        else{
            return false;
        }
    }

    function verifyBiometricsFingerPrint(address _citizenID, uint _RightFinger1, uint _RightFinger2, uint _RightFinger3, uint _RightFinger4, uint _RightFinger5, uint _LeftFinger1, uint _LeftFinger2, uint _LeftFinger3, uint _LeftFinger4, uint _LeftFinger5) public view returns(bool){
        if(mapRightHand[_citizenID].rightFinger1==_RightFinger1 || mapRightHand[_citizenID].rightFinger2==_RightFinger2 || mapRightHand[_citizenID].rightFinger3==_RightFinger3 || mapRightHand[_citizenID].rightFinger4==_RightFinger4 || mapRightHand[_citizenID].rightFinger5==_RightFinger5 || mapLeftHand[_citizenID].leftFinger1==_LeftFinger1 || mapLeftHand[_citizenID].leftFinger2==_LeftFinger2 || mapLeftHand[_citizenID].leftFinger3==_LeftFinger3 || mapLeftHand[_citizenID].leftFinger4==_LeftFinger4 || mapLeftHand[_citizenID].leftFinger5==_LeftFinger5){
            return true;
        }
        else{
            return false;
        }
    }

    function verifyBiometrics(address _citizenID) public view returns(bool){
        // 315569260 = 10 years
        if(block.timestamp-mapIris[_citizenID].issueDate<=315569260 && mapIris[_citizenID].verify==true){
            if(block.timestamp-mapverifyHand[_citizenID].issueDate<=315569260 && mapverifyHand[_citizenID].verify==true){
                if(block.timestamp-mapFace[_citizenID].issueDate<=315569260 && mapFace[_citizenID].verify==true){
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
        else{
            return false;
        }
    }

}
