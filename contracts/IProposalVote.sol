// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

interface IProposalVote {
    enum PropsStatus {
        None,
        Created,
        Pending,
        Accepted
    }

    struct Proposal {
        string name;
        string description;
        uint16 voteCount;
        address[] voters;
        uint16 quorum;
        PropsStatus status;
    }

    function createProposal(
        string memory _name,
        string memory _desc,
        uint16 _quorum
    ) external;

    function voteOnProposal(uint8 _index) external;

    function getAllProposals() external view returns (Proposal[] memory);

    function getAProposal(uint8 _index)
        external
        view
        returns (
            string memory name_,
            string memory desc_,
            uint16 count_,
            address[] memory voters_,
            uint16 quorum_,
            PropsStatus status_
        );
}