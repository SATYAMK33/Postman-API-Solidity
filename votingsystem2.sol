// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Votingsystem {

   uint256 public numberofCandidates;
    struct Candidates {
        string name;
        uint256 votes;
    }

    Candidates[] public candidate;
    address public owner;
    mapping (address=>bool) public voters;
   
    IERC20 public votingToken;

    constructor(address _votingToken, string[] memory _candidateNames) {
    owner = msg.sender;
    votingToken = IERC20(_votingToken);
    numberofCandidates = _candidateNames.length;
    
    for (uint256 i = 0; i < numberofCandidates; i++) {
        candidate[i] = Candidates({
            name: _candidateNames[i],
            votes: 0
        });
    }
}


    function addcandidate(string memory _name) public {
        candidate.push(Candidates({
            name:_name,
            votes: 0
        }));

    }
    
    function vote(uint256 _candidateindex) public {
        require(!voters[msg.sender],"Already Voted");
        require(_candidateindex < candidate.length, "Invalid");

       votingToken.transferFrom(msg.sender, address(this), 1);

        candidate[_candidateindex].votes++;
        voters[msg.sender]=true; 

    }
 
    function electionresults() public view returns (Candidates[] memory){
     return candidate;

    }
    
    function winner() public view returns (string memory ){
     
     require(candidate.length>0, "No Candidates");
     
     uint256 wvotes = 0;
     string memory winner = candidate[0].name;

     for(uint256 i=0; i < candidate.length; i++){
         if(candidate[i].votes > wvotes){
             wvotes = candidate[i].votes;
             winner = candidate[i].name;
         }
        else if (candidate[i].votes==wvotes){
             wvotes = candidate[i].votes;
             winner = "Tie";
         }
    
     }
     
     return winner;

    }
 

}
