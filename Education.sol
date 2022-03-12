// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Education{
    address public Dean;
    mapping(address=>bool) public collegeAdminID;
    mapping(address=>bool) public interviewerID;
    mapping(address=>bool) public studentID;

    struct collegeAdminsDetails{
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
    }

    mapping(address=>courseDetails[]) private mapStudentCourse;

    modifier onlyDean(){
        require(msg.sender==Dean,"Only owner can calll this function");
        _;
    }

    modifier onlyCollegeAdmins(){
        require(collegeAdminID[msg.sender]==true,"Only owner can calll this function");
        _;
    }

    modifier restrictedAccess(){
        require(msg.sender==Dean || collegeAdminID[msg.sender]==true || interviewerID[msg.sender]==true || studentID[msg.sender]==true,"Only Dean, College Admins and Students can calll this function");
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

    }
    // Get
    function getCollegeAdmin(address _collegeAdmin) public returns(string memory, uint){
        
    }
    // Remove
    function removeCollegeAdmin(address _collegeAdmin) public onlyDean{

    }

    // Interviewer Details
    // Set
    function setInterviewer(address _interviewer, string memory _name, uint _id, string memory _companyName) public onlyCollegeAdmins onlyDean{

    }
    // Get
    function getInterviewer(address _interviewer) public returns(string memory, uint, string memory){
        
    }
    // Remove
    function removeInterviewer(address _interviewer) public onlyDean{
        
    }

    // Student Details
    // Set
    function setStudent(address _student, string memory _name, uint _id, string memory _dept) public onlyCollegeAdmins onlyDean{

    }
    // Get
    function getStudent(address _student) public returns(string memory, uint, string memory){

    }
    // Remove
    function removeStudent(address _interviewer) public onlyDean{
        
    }

    // Course and Grades
    // Set
    function addCompletedCourses(address _student) public onlyCollegeAdmins{

    }
    // Get
    function viewCompletedCourses(address _student) public view restrictedAccess returns(courseDetails[] memory){

    }

    // Degree
    function viewDegree(address _student) public view returns(address, string memory, uint, string memory){
        
    }
}
