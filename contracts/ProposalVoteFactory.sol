// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ProposalVote} from "./ProposalVote.sol";
import {IProposalVote} from "./IProposalVote.sol";

contract ProposalVoteFactory {
    struct DeployedContractInfo {
        address deployer;
        address deployedContract;
        uint256 timestamp;
    }

    event ProposalVoteDeployed(address indexed deployer, address indexed contractAddress);
    event ProposalCreated(address indexed contractAddress, string name, uint16 quorum);
    event VoteCast(address indexed contractAddress, address indexed voter, uint8 proposalIndex);

    DeployedContractInfo[] public allContracts;
    mapping(address => DeployedContractInfo[]) public userDeployedContracts;
    
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Invalid address");
        _;
    }

    modifier validContract(address _contractAddr) {
        bool isValid = false;
        for (uint i = 0; i < allContracts.length; i++) {
            if (allContracts[i].deployedContract == _contractAddr) {
                isValid = true;
                break;
            }
        }
        require(isValid, "Contract not found");
        _;
    }

    function deployProposalVote() external validAddress(msg.sender) returns (address) {
        ProposalVote newContract = new ProposalVote();
        address contractAddress = address(newContract);

        DeployedContractInfo memory contractInfo = DeployedContractInfo({
            deployer: msg.sender,
            deployedContract: contractAddress,
            timestamp: block.timestamp
        });

        allContracts.push(contractInfo);
        userDeployedContracts[msg.sender].push(contractInfo);

        emit ProposalVoteDeployed(msg.sender, contractAddress);
        return contractAddress;
    }

    function createProposal(
        address _contractAddr,
        string memory _name,
        string memory _desc,
        uint16 _quorum
    ) external validAddress(msg.sender) validContract(_contractAddr) {
        IProposalVote(_contractAddr).createProposal(_name, _desc, _quorum);
        emit ProposalCreated(_contractAddr, _name, _quorum);
    }

    function voteOnProposal(address _contractAddr, uint8 _index) 
        external 
        validAddress(msg.sender) 
        validContract(_contractAddr) 
    {
        IProposalVote(_contractAddr).voteOnProposal(_index);
        emit VoteCast(_contractAddr, msg.sender, _index);
    }

    function getProposalDetails(address _contractAddr, uint8 _index)
        external
        view
        validAddress(msg.sender)
        validContract(_contractAddr)
        returns (
            string memory name_,
            string memory desc_,
            uint16 count_,
            address[] memory voters_,
            uint16 quorum_,
            IProposalVote.PropsStatus status_
        )
    {
        return IProposalVote(_contractAddr).getAProposal(_index);
    }

    function getAllProposals(address _contractAddr)
        external
        view
        validAddress(msg.sender)
        validContract(_contractAddr)
        returns (IProposalVote.Proposal[] memory)
    {
        return IProposalVote(_contractAddr).getAllProposals();
    }

    function getAllDeployedContracts() external view returns (DeployedContractInfo[] memory) {
        return allContracts;
    }

    function getUserDeployedContracts(address _user) 
        external 
        view 
        validAddress(_user) 
        returns (DeployedContractInfo[] memory) 
    {
        return userDeployedContracts[_user];
    }

    function getContractCount() external view returns (uint256) {
        return allContracts.length;
    }
}
