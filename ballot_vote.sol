// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 9.0;

//making a voting contract
//1.we want the ablity to accept proposal and store them
//proposal : their name,number

//2.voters & voting ablity
//keep track of voting 
//check voters are authenticated to vote

//3.chairman
//authenticate and deploy contract

contract Ballot{

    struct Voter{
        uint vote;
        bool voted;
        uint weight;
    }

    struct Proposal{
        //bytes are a basic unit measurement of informtion in computer processing
        bytes32 name; //the nae of each proposal
        uint voteCount; //number of accumulated votes
    }

    Proposal[] public proposals;
    //mapping allow for us to create a store value with keys and indexes
    mapping (address => Voter) public voters; //voters gets address as a key and Voter for value
    
    address public chairperson;

    constructor(bytes32[] memory proposalNames) {
        //memory defines a temp data location in solidity during runtime only of methods
        
        //msg,sender = is a global var that states the person who is currently connecting to the contract
        
        chairperson = msg.sender;
        //add 1 to chairperson weight
        voters[chairperson].weight = 1;
        //will add the proposal names to the smart contract upon deployment
         for (uint i= 0;i < proposalNames.length;i++ )
         {
             proposals.push(Proposal({
                 name : proposalNames[i],voteCount : 0 
             }));
         }
    }
    //function to authenticate voter

    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson,
            'Only the Chairperson can give accessto vote');
        //reqire that the voter hasn't voted yet
        require(!voters[voter].voted,
            'The voter has already voted');
        require(voters[voter].weight == 0);
        //ablity to vote
        voters[voter].weight = 1;
    }

    //function for voting
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, 'Has no right to vote');
        require(!sender.voted, 'Already voted');

        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount = proposals[proposal].voteCount + sender.weight;
    }
    //function for showing the results for this we create two function

    //1. function that shows the wining proposal by integer
    function winningProposal() public view returns (uint winningProposal_){
        
        uint winningVoteCount = 0;
        for(uint i = 0;i < proposals.length;i++)
        {
            if(proposals[i].voteCount > winningVoteCount)
            {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }
    //2. function that shows winner by the name
    function winningName() public view returns (bytes32 winningName_){
        winningName_ = proposals[winningProposal()].name;
    }
}