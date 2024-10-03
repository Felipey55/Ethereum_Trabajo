// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    // Estructura de una propuesta
    struct Proposal {
        string name;
        uint voteCount;
    }

    address public admin;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public hasVoted;
    Proposal[] public proposals;
    uint public endTime;

    constructor() {
        admin = msg.sender; // Admin es la cuenta que despliega el contrato
        endTime = block.timestamp + 3 days; // Tiempo límite para votar
    }

    // Solo el admin puede añadir propuestas
    modifier onlyAdmin() {
        require(msg.sender == admin, "Solo el admin puede agregar propuestas.");
        _;
    }

    // Solo las direcciones en la whitelist pueden votar
    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "No estas en la whitelist.");
        _;
    }

    // Validar que el tiempo de votación no haya terminado
    modifier withinVotingPeriod() {
        require(block.timestamp <= endTime, "El tiempo de votacion ha terminado.");
        _;
    }

    // Añadir una dirección a la whitelist
    function addToWhitelist(address voter) external onlyAdmin {
        whitelist[voter] = true;
    }

    // Añadir una propuesta
    function addProposal(string memory name) external onlyAdmin {
        proposals.push(Proposal({
            name: name,
            voteCount: 0
        }));
    }

    // Votar por una propuesta
    function vote(uint proposalIndex) external onlyWhitelisted withinVotingPeriod {
        require(!hasVoted[msg.sender], "Ya has votado.");
        proposals[proposalIndex].voteCount += 1;
        hasVoted[msg.sender] = true;
    }

    // Obtener el número total de propuestas
    function getProposalCount() public view returns (uint) {
        return proposals.length;
    }

    // Obtener el nombre de una propuesta
    function getProposalName(uint index) public view returns (string memory) {
        require(index < proposals.length, "Propuesta invalida.");
        return proposals[index].name;
    } 

    // Obtener la cuenta de votos de una propuesta
    function getProposalVoteCount(uint index) public view returns (uint) {
        require(index < proposals.length, "Propuesta invalida.");
        return proposals[index].voteCount;
    }
}
