pragma solidity 0.5.0;

import "./Owned.sol";

//                                                                                  c=====e
//                                           GALATIONS 3:28                            H
//     ____________                                                                _,,_H__
//    (__((__((___()                                                              //|     |
//   (__((__((___()()____________________________________________________________// |ACME |
//  (__((__((___()()()-----------------------------------------------------------'  |_____|

// ----------------------------------------------------------------------------
// DAO contract
// ----------------------------------------------------------------------------

contract DAO is Owned {
    
    struct Proposal {
// the index in the requests mapping
        uint ID;
        string description;
        uint value;
        uint compFactor;
        address payable recipient;
        bool passedDeadline;
        bool approved;
        address[] upVotes;
        address[] downVotes;
        mapping(address => bool) votes;
    }

    struct Member{
        address member;
        string name;
        string bio;
        mapping(uint => bool) voted;
    }

    address public manager;
    mapping (address => Member) public members;
    Proposal[] proposals;
    uint proposalCount;
    uint public tokenRate;
    uint public membersCount;
    string public entityName;
    string public missionDescription;  
    Token public token;
   
    constructor(string memory name, string memory mission, address creator, string memory tokenName,
                string memory tokenSymbol, uint rate) public {
        manager = creator;
        entityName = name;
        missionDescription = mission;
        tokenRate = rate;
        transferOwnership(manager);
        members[manager] = true;
        membersCount ++;
        token = new Token( tokenName, tokenSymbol, msg.sender);
    }

    modifier onlyMembers() {
        require(
            members[msg.sender],
            "Only members can call this function."
        );
        _;
    }

    function verify(address member) public Owned {
       require(!members[member]);
        members[member] = true;
        membersCount ++;
    }
    
    function unverify(address member) public Owned {
       require(members[member]);
        members[member] = false;
        membersCount --;
    }

    function createProposal(string memory  description, uint value, uint compFactor, 
                            address payable recipient) public  {
        require(members[msg.sender]);
        uint id = proposalCount + 1;
        Proposal memory newProposal = Proposal({
            ID: id,
            description: description,
            value: value,
            compFactor: compFactor,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        requests.push(new);
        proposals[ID].vote[msg.sender] = true;
        proposalCount ++;
    }
    
    function approveRequest(uint index) public {
        Proposal storage proposal = requests[index];
        require(members[msg.sender]);
        require(!proposal.approvals[msg.sender]);
        proposals[index].approvals[msg.sender] = true;
        request.approvalCount ++;
    }

    function finalizeRequest(uint index) public Owned {
        Request storage request = requests[index];
        require(request.approvalCount > (membersCount / 2));
        require(!request.complete);
//        token.mint(request.recipient, request.value * request.compFactor);
        request.complete = true;
    }
      
    function contribute() public payable {  
        uint256 value = msg.value * tokenRate;
        token.mint(msg.sender, value);
    }
    
    function sellTokens(address payable member,  uint amount) public onlyMembers {
       token.burnFrom(member, amount);
       member.transfer(amount / tokenRate);
    }

    function getSummary() public view returns (
       uint, uint, uint, address, string memory, string memory) {
        return (address(this).balance, proposals.length, membersCount, manager, entityName, missionDescription);
    }

    function vote(bool _vote, uint index) public{
        Member storage voter = members[msg.sender];
        Proposal storage proposal = proposals[index];
        require(proposal.passedDeadline == false);
        require(proposal.votes[] == false);
        if(_vote == true && voter.voted[proposal.ID] == false){
            proposal.upVote.push(msg.sender);
            proposal.votes[msg.sender] = true;
            voter.voted[proposal.ID] = true;
        } if(_vote == false && voter.voted[proposal.ID] == false){
            proposal.downVote.push(msg.sender);
            proposal.votes[msg.sender] = false;
            voter.voted[proposal.ID] = true;
        }
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }

          
}

// ----------------------------------------------------------------------------
// Roles contract
// ----------------------------------------------------------------------------

library Roles {

  struct Role {
    mapping (address => bool) bearer;
  }

  /**
   * @dev give an address access to this role
   */
  function add(Role storage role, address addr)internal
  {
    role.bearer[addr] = true;
  }

  /**
   * @dev remove an address' access to this role
   */
  function remove(Role storage role, address addr) internal{
    role.bearer[addr] = false;
  }

  /**
   * @dev check if an address has this role
   * // reverts
   */
  function check(Role storage role, address addr) view internal{
    require(has(role, addr));
  }

  /**
   * @dev check if an address has this role
   * @return bool
   */
  function has(Role storage role, address addr) view internal returns (bool){
    return role.bearer[addr];
  }
}
