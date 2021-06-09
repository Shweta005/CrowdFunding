pragma solidity 0.8.0;

contract Crowdfunding{
    
    //governance -owner constructor
    //proposal for campaign - one of the owner can post proposal
    //Owner - can give vote to proposal
    //Users - can raise funds
    
    address public Governance;
    
    constructor(){
             Governance = msg.sender;
         }
         
         struct Owner{
             string  name;
             string  campaignFor;
             address add;
             bool    proposal;
             uint256 votes;
             bool    proposalwins;
             bool    isVoted;
         }
         
         //counter & mapping
         uint256 public ocounter;
         uint256 public totalvotes;
         mapping(address => uint256) public owners;
         mapping(uint256 => Owner) public ownerId;
         
         //Events
          event OwnerRegistered(address sender, address owner);
          event ProposalAdded(address sender,address powner);
          event Voted(address voter, address powner);
         
         //Modifiers
        modifier onlyOwner(address _add){
             uint id = owners[_add];
             require(msg.sender == ownerId[id].add,"You are not Owner");
             _;
         }
        modifier onlyGovernance(){
            require(msg.sender == Governance,"not Governance address");
            _;
        }
         
        
         //Functions
        function RegisterOwner(string memory _name,string memory _camp,address _add) onlyGovernance public {
             require( _add != Governance ,"Governance Address");
             ocounter++;
             Owner memory owner = Owner(_name,_camp,_add,false,0,false,false);
             owners[_add] = ocounter;
             ownerId[ocounter] = owner;
             emit OwnerRegistered(Governance, _add);
         }
         
        function addProposal(address _add) onlyGovernance public {
             uint id = owners[_add];
             ownerId[id].proposal = true;
             emit ProposalAdded(Governance,_add);
             }
             
        function viewPropsal(address _add) onlyOwner(_add) public view returns(string memory,string memory,bool,uint256,bool){
            uint id = owners[_add];
            return (
                     ownerId[id].name,
                     ownerId[id].campaignFor,
                     ownerId[id].proposal,
                     ownerId[id].votes,
                     ownerId[id].isVoted);
        }
        
        function VoteProposal(address _add) onlyOwner(msg.sender) public {
            totalvotes++;
            uint id = owners[_add];
            ownerId[id].isVoted = true;
            ownerId[id].votes += 1;
            emit Voted(msg.sender,_add);
        }
        
        
        
         
         
         
         
}