// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ConstructionManagement {
    address public owner;
    uint public projectCount;

    struct Project {
        uint id;
        string name;
        uint budget;
        uint fundsAllocated;
        bool isCompleted;
        address owner;
    }

    struct Payment {
        uint projectId;
        uint amount;
        address recipient;
        bool isPaid;
    }

    mapping(uint => Project) public projects;
    mapping(uint => Payment[]) public projectPayments;

    event ProjectCreated(uint projectId, string name, uint budget, address owner);
    event PaymentMade(uint projectId, uint amount, address recipient);
    event ProjectCompleted(uint projectId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this.");
        _;
    }

    modifier onlyProjectOwner(uint projectId) {
        require(msg.sender == projects[projectId].owner, "Only the project owner can execute this.");
        _;
    }

    constructor() {
        owner = msg.sender;
        projectCount = 0;
    }

    // Create a new construction project
    function createProject(string memory _name, uint _budget) external onlyOwner {
        projectCount++;
        projects[projectCount] = Project({
            id: projectCount,
            name: _name,
            budget: _budget,
            fundsAllocated: 0,
            isCompleted: false,
            owner: msg.sender 
        });

        emit ProjectCreated(projectCount, _name, _budget, msg.sender);
    }

    // Allocate funds to a project
    function allocateFunds(uint _projectId) external payable onlyOwner {
        require(projects[_projectId].id != 0, "Project does not exist.");
        require(msg.value > 0, "You must send funds.");

        projects[_projectId].fundsAllocated += msg.value;
    }

    // Make a payment to a contractor or supplier for a specific project
    function makePayment(uint _projectId, address _recipient, uint _amount) external onlyProjectOwner(_projectId) {
        require(projects[_projectId].id != 0, "Project does not exist.");
        require(projects[_projectId].fundsAllocated >= _amount, "Insufficient funds allocated.");
        require(_amount > 0, "Amount must be greater than 0.");

        projects[_projectId].fundsAllocated -= _amount;

        Payment memory payment = Payment(_projectId, _amount, _recipient, true);
        projectPayments[_projectId].push(payment);

        payable(_recipient).transfer(_amount);

        emit PaymentMade(_projectId, _amount, _recipient);
    }

    // Mark a project as completed
    function markProjectAsCompleted(uint _projectId) external onlyProjectOwner(_projectId) {
        require(projects[_projectId].id != 0, "Project does not exist.");
        require(!projects[_projectId].isCompleted, "Project is already completed.");

        projects[_projectId].isCompleted = true;

        emit ProjectCompleted(_projectId);
    }

    // Get the details of a project
    function getProjectDetails(uint _projectId) external view returns (string memory, uint, uint, bool, address) {
        require(projects[_projectId].id != 0, "Project does not exist.");

        Project memory project = projects[_projectId];
        return (project.name, project.budget, project.fundsAllocated, project.isCompleted, project.owner);
    }

    // Get payment history for a project
    function getPaymentsForProject(uint _projectId) external view returns (Payment[] memory) {
        return projectPayments[_projectId];
    }
}
