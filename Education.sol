// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Education{
    address public Dean;

    struct collegeAdminDetails{
        string name;
        uint id;
        bool verify;
    }

    struct interviewerDetails{
        string name;
        uint id;
        string companyName;
        bool verify;
    }

    struct studentDetails{
        string name;
        uint id;
        string dept;
        bool verify;
    }

    struct courseDetails{
        string courseName;
        uint courseGrade;
        string courseResult;
    }

    mapping(address=>collegeAdminDetails) private mapCollegeAdminDetails;
    mapping(address=>interviewerDetails) private mapInterviewerDetails;
    mapping(address=>studentDetails) private mapStudentDetails;
    mapping(address=>mapping(uint=>courseDetails[])) private mapStudentCourse;

    modifier onlyDean(){
        require(msg.sender==Dean,"Only owner can calll this function");
        _;
    }

    modifier onlyCollegeAdmins(){
        require(mapCollegeAdminDetails[msg.sender].verify==true,"Only owner can calll this function");
        _;
    }

    modifier restrictedAccess(){
        require(msg.sender==Dean || mapCollegeAdminDetails[msg.sender].verify==true || mapCollegeAdminDetails[msg.sender].verify==true || mapStudentDetails[msg.sender].verify==true,"Only Dean, College Admins and Students can calll this function");
        _;
    }

    // Constructor
    constructor(){
        Dean = msg.sender;
    }

    // Functions

    // Change Dean
    function changeDean(address _newDean) public onlyDean{
        Dean = _newDean;
    }

    // College Admin Details
    // Set
    function setCollegeAdmin(address _collegeAdmin, string memory _name, uint _id) public onlyCollegeAdmins onlyDean{
        mapCollegeAdminDetails[_collegeAdmin] = collegeAdminDetails(_name, _id, true);
    }
    // Get
    function getCollegeAdmin(address _collegeAdmin) public view returns(string memory, uint, bool){
        return(mapCollegeAdminDetails[_collegeAdmin].name, mapCollegeAdminDetails[_collegeAdmin].id, mapCollegeAdminDetails[_collegeAdmin].verify);
    }
    // Remove
    function removeCollegeAdmin(address _collegeAdmin) public onlyDean{
        mapCollegeAdminDetails[_collegeAdmin].verify = false;
    }

    // Interviewer Details
    // Set
    function setInterviewer(address _interviewer, string memory _name, uint _id, string memory _companyName) public onlyCollegeAdmins onlyDean{
        mapInterviewerDetails[_interviewer] = interviewerDetails(_name, _id, _companyName, true);
    }
    // Get
    function getInterviewer(address _interviewer) public view returns(string memory, uint, string memory, bool){
        return(mapInterviewerDetails[_interviewer].name, mapInterviewerDetails[_interviewer].id, mapInterviewerDetails[_interviewer].companyName, mapInterviewerDetails[_interviewer].verify);
    }
    // Remove
    function removeInterviewer(address _interviewer) public onlyDean{
        mapInterviewerDetails[_interviewer].verify = false;
    }

    // Student Details
    // Set
    function setStudent(address _student, string memory _name, uint _id, string memory _dept) public onlyCollegeAdmins onlyDean{
        mapStudentDetails[_student] = studentDetails(_name, _id, _dept, true);
    }
    // Get
    function getStudent(address _student) public view returns(string memory, uint, string memory, bool){
        return (mapStudentDetails[_student].name, mapStudentDetails[_student].id, mapStudentDetails[_student].dept, mapStudentDetails[_student].verify);
    }
    // Remove
    function removeStudent(address _student) public onlyDean{
        mapStudentDetails[_student].verify = false;
    }

    // Course and Grades
    // Set
    function addCompletedCourses(address _student, uint _sem, string memory _courseName, uint _courseGrade, string memory _courseResult) public onlyCollegeAdmins{
        mapStudentCourse[_student][_sem].push(courseDetails({
            courseName:_courseName,
            courseGrade:_courseGrade,
            courseResult:_courseResult
        }));
    }
    // Get
    function viewCompletedCourses(address _student) public view restrictedAccess returns(courseDetails[] memory){
        uint _semNo;
        courseDetails[] memory sem = new courseDetails[](mapStudentCourse[_student][_semNo].length);
        
        for(_semNo=1; _semNo<mapStudentCourse[_student][_semNo].length; _semNo++){
            for(uint index=0; index<mapStudentCourse[_student][_semNo].length; index++){
                sem[index] = mapStudentCourse[_student][_semNo][index];
            }
        }
        return sem;
    }

    // Degree
    function viewDegree(address _student) public view returns(address, string memory, uint, string memory){
        return(_student, mapStudentDetails[_student].name, mapStudentDetails[_student].id, mapStudentDetails[_student].dept);
    }
}
