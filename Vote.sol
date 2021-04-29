// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
/**
 * @title Vote
 * @dev A Vote Contract for Votes
 */
contract vote {

    address private owner;
    mapping (address => bool) private addressOfVoters;
    uint256 private positiveVotes;
    uint256 private votes;
    string private vtitle;
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    // modifier to check if caller is owner
    modifier isOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    function uadd(uint256 a, uint256 b) internal returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Fail in Add");
        return c;
    }

    function beIOwner() public view returns (bool){
        return (msg.sender == owner);
    }

    /**
     * @dev Call to Vote
     * @param vote Your Voice
     */
    function voteNow(bool vote) public returns (bool) {
        if(addressOfVoters[msg.sender]){
            return false;
        }else{
            if(vote){
                positiveVotes=uadd(positiveVotes, 1);
            }
            votes = uadd(votes, 1);
            addressOfVoters[msg.sender]=true;
            return true;
        }
    }
    
    /**
     * @dev Outputs how many people voted
     * @param onlypositive If true, fetch how many people vote positive, else fetch all votes
     * @return A number
     */
    function gVotes (bool onlypositive) public view returns (uint256){
        if(onlypositive){
            return positiveVotes;
        }else{
            return votes;
        }
    }
    
    /**
     * @dev Outputs if you voted
     * @return If you voted
     */
    function haveIVoted () public view returns (bool){
        return addressOfVoters[msg.sender];
    }
    
    /**
     * @dev Set contract deployer as owner
     * @param titleOfVote Title of the vote (a question or something else)
     */
    constructor(string memory titleOfVote) {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        vtitle = titleOfVote;
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Destroy this Vote
     * @param objTOGetMoney address of your wallet
     */
    function killThisVote(address payable objTOGetMoney) public isOwner {
        selfdestruct(objTOGetMoney);
    }

    /**
     * @dev Return owner address 
     * @return address of owner
     */
    function getOwner() external view returns (address) {
        return owner;
    }
    /**
     * @dev Get title of vote
     * @return the title
     */
    function getTitle() external view returns (string memory) {
        return vtitle;
    }
}