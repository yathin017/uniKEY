// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Contact.sol";

contract Biometrics is Identity {
    struct Face {
        string hash;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    struct Iris {
        uint256 rightIris;
        uint256 leftIris;
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    struct RightHand {
        uint256 rightFinger1;
        uint256 rightFinger2;
        uint256 rightFinger3;
        uint256 rightFinger4;
        uint256 rightFinger5;
    }

    struct LeftHand {
        uint256 leftFinger1;
        uint256 leftFinger2;
        uint256 leftFinger3;
        uint256 leftFinger4;
        uint256 leftFinger5;
    }

    struct verifyHand {
        uint256 issueDate;
        address issuedBy;
        bool verify;
    }

    mapping(address => Face) private mapFace;
    mapping(address => Iris) private mapIris;
    mapping(address => RightHand) private mapRightHand;
    mapping(address => LeftHand) private mapLeftHand;
    mapping(address => verifyHand) private mapverifyHand;

    function setBiometricsFace(address _citizenID, string memory _hash) public {
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
        );
        require(verifyBirthCertificate(_citizenID) == true);
        mapFace[_citizenID].hash = _hash;
        mapFace[_citizenID].issueDate = block.timestamp;
        mapFace[_citizenID].issuedBy = msg.sender;
        mapIris[_citizenID].verify = true;
    }

    function setBiometricsIris(
        address _citizenID,
        uint256 _RightIris,
        uint256 _LeftIris
    ) public {
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
        );
        require(verifyBirthCertificate(_citizenID) == true);
        mapIris[_citizenID].rightIris = uint256(
            sha256(abi.encodePacked(_RightIris))
        );
        mapIris[_citizenID].leftIris = uint256(
            sha256(abi.encodePacked(_LeftIris))
        );
        mapIris[_citizenID].issueDate = block.timestamp;
        mapIris[_citizenID].issuedBy = msg.sender;
        mapIris[_citizenID].verify = true;
    }

    function setBiometricsFingerPrint(
        address _citizenID,
        uint256 _RightFinger1,
        uint256 _RightFinger2,
        uint256 _RightFinger3,
        uint256 _RightFinger4,
        uint256 _RightFinger5,
        uint256 _LeftFinger1,
        uint256 _LeftFinger2,
        uint256 _LeftFinger3,
        uint256 _LeftFinger4,
        uint256 _LeftFinger5
    ) public {
        require(
            verifyAdmin(msg.sender) == true ||
                uint256(powerGovernmentWorker(msg.sender)) == 0 ||
                uint256(powerGovernmentWorker(msg.sender)) == 1
        );
        require(verifyBirthCertificate(_citizenID) == true);
        mapRightHand[_citizenID].rightFinger1 = uint256(
            sha256(abi.encodePacked(_RightFinger1))
        );
        mapRightHand[_citizenID].rightFinger2 = uint256(
            sha256(abi.encodePacked(_RightFinger2))
        );
        mapRightHand[_citizenID].rightFinger3 = uint256(
            sha256(abi.encodePacked(_RightFinger3))
        );
        mapRightHand[_citizenID].rightFinger4 = uint256(
            sha256(abi.encodePacked(_RightFinger4))
        );
        mapRightHand[_citizenID].rightFinger5 = uint256(
            sha256(abi.encodePacked(_RightFinger5))
        );
        mapLeftHand[_citizenID].leftFinger1 = uint256(
            sha256(abi.encodePacked(_LeftFinger1))
        );
        mapLeftHand[_citizenID].leftFinger2 = uint256(
            sha256(abi.encodePacked(_LeftFinger2))
        );
        mapLeftHand[_citizenID].leftFinger3 = uint256(
            sha256(abi.encodePacked(_LeftFinger3))
        );
        mapLeftHand[_citizenID].leftFinger4 = uint256(
            sha256(abi.encodePacked(_LeftFinger4))
        );
        mapLeftHand[_citizenID].leftFinger5 = uint256(
            sha256(abi.encodePacked(_LeftFinger5))
        );
        mapverifyHand[_citizenID].issueDate = block.timestamp;
        mapverifyHand[_citizenID].issuedBy = msg.sender;
        mapverifyHand[_citizenID].verify = true;
    }

    function viewFace(address _citizenID) public view returns (string memory) {
        return mapFace[_citizenID].hash;
    }

    function verifyBiometricsIris(
        address _citizenID,
        uint256 _RightIris,
        uint256 _LeftIris
    ) public view returns (bool) {
        if (
            mapIris[_citizenID].rightIris == _RightIris ||
            mapIris[_citizenID].leftIris == _LeftIris
        ) {
            return true;
        } else {
            return false;
        }
    }

    function verifyBiometricsFingerPrint(
        address _citizenID,
        uint256 _RightFinger1,
        uint256 _RightFinger2,
        uint256 _RightFinger3,
        uint256 _RightFinger4,
        uint256 _RightFinger5,
        uint256 _LeftFinger1,
        uint256 _LeftFinger2,
        uint256 _LeftFinger3,
        uint256 _LeftFinger4,
        uint256 _LeftFinger5
    ) public view returns (bool) {
        if (
            mapRightHand[_citizenID].rightFinger1 == _RightFinger1 ||
            mapRightHand[_citizenID].rightFinger2 == _RightFinger2 ||
            mapRightHand[_citizenID].rightFinger3 == _RightFinger3 ||
            mapRightHand[_citizenID].rightFinger4 == _RightFinger4 ||
            mapRightHand[_citizenID].rightFinger5 == _RightFinger5 ||
            mapLeftHand[_citizenID].leftFinger1 == _LeftFinger1 ||
            mapLeftHand[_citizenID].leftFinger2 == _LeftFinger2 ||
            mapLeftHand[_citizenID].leftFinger3 == _LeftFinger3 ||
            mapLeftHand[_citizenID].leftFinger4 == _LeftFinger4 ||
            mapLeftHand[_citizenID].leftFinger5 == _LeftFinger5
        ) {
            return true;
        } else {
            return false;
        }
    }

    function verifyBiometrics(address _citizenID) public view returns (bool) {
        // 315569260 = 10 years
        if (
            block.timestamp - mapIris[_citizenID].issueDate <= 315569260 &&
            mapIris[_citizenID].verify == true
        ) {
            if (
                block.timestamp - mapverifyHand[_citizenID].issueDate <=
                315569260 &&
                mapverifyHand[_citizenID].verify == true
            ) {
                if (
                    block.timestamp - mapFace[_citizenID].issueDate <=
                    315569260 &&
                    mapFace[_citizenID].verify == true
                ) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
}
