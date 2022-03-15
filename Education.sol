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
        uint courseCredits;
        string courseResult;
    }

    mapping(address=>collegeAdminDetails) private mapCollegeAdminDetails;
    mapping(address=>interviewerDetails) private mapInterviewerDetails;
    mapping(address=>studentDetails) private mapStudentDetails;
    mapping(address=>uint) private mapStudentCredits;
    mapping(address=>mapping(uint=>courseDetails[])) private mapStudentCourse;

    modifier onlyDean(){
        require(msg.sender==Dean,"Only Dean can call this function");
        _;
    }

    modifier onlyCollegeAdmins(){
        require(msg.sender==Dean || mapCollegeAdminDetails[msg.sender].verify==true,"Only Dean and Admins can call this function");
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
    function setCollegeAdmin(address _collegeAdmin, string memory _name, uint _id) public onlyCollegeAdmins{
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
    function setInterviewer(address _interviewer, string memory _name, uint _id, string memory _companyName) public onlyCollegeAdmins{
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
    function setStudent(address _student, string memory _name, uint _id, string memory _dept) public onlyCollegeAdmins{
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
    function addCompletedCourses(address _student, uint _sem, string memory _courseName, uint _courseGrade, uint _courseCredits, string memory _courseResult) public onlyCollegeAdmins{
        mapStudentCourse[_student][_sem].push(courseDetails({
            courseName:_courseName,
            courseGrade:_courseGrade,
            courseCredits:_courseCredits,
            courseResult:_courseResult
        }));
        mapStudentCredits[_student]+=_courseCredits;
    }
    // Get
    function viewCompletedCourses(address _student, uint _sem) public view restrictedAccess returns(courseDetails[] memory){
        courseDetails[] memory sem = new courseDetails[](mapStudentCourse[_student][_sem].length);
        
            for(uint index=0; index<mapStudentCourse[_student][_sem].length; index++){
                sem[index] = mapStudentCourse[_student][_sem][index];
            }
        return sem;
    }

    // Degree
    function viewDegree(address _student) public view returns(address, string memory, uint, string memory){
        require(mapStudentCredits[_student]>=200);
        return(_student, mapStudentDetails[_student].name, mapStudentDetails[_student].id, mapStudentDetails[_student].dept);
    }
    
}
