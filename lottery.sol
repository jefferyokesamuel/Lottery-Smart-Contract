pragma solidity 0.6.12;

contract lottery {
    address public manager;
    address payable [] public players;
    // Constructor - Set the Manager

    constructor () public {
        manager = msg.sender;
    }
    modifier onlyManager () {
        require(msg.sender == manager,"only manager can call this function");
        _;
    }
    //event to the frotend
    event playerInvested (address player, uint amount);
    event winnerSelected(address winner, uint amount) ;
    // Invest Money by players - send money
    function transfer () public payable {
        require(msg.sender != manager, "Manager Cannot invest");
        require(msg.value  > 0.1 ether, "Invest minimum of 0.1 ether");
    //Keeping track of all transfers
        players.push(msg.sender);
        emit playerInvested(msg.sender, msg.value);
    }
    // get balance - current balance
    function balance() public view onlyManager returns(uint) {
        
        return address(this).balance; 
    }
    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,players.length)));
    }
    // Manager clicks a function, it should
    function selectWinner() public onlyManager {
        // Select a random number 
        uint r = random();
        //modulo it with number of players
        uint index = r % players.length;
        // Map the remainder to an index in the array
        address payable winner = players[index];
        emit winnerSelected (winner,address(this).balance);
        //Transfer all the money in the contract to the address in the array
        winner.transfer(address(this).balance);
        //Then make the array empty
         players = new address payable[](0);
         
    }
}
