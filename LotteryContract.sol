// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract LotteryContract {
    address public manager;
    address payable[] public candidate;
    address payable public winner;

    constructor(){
        manager=msg.sender;
    }

    receive() external payable {
        require(msg.value==1000000000000 wei);
        candidate.push(payable(msg.sender));
    }

    function getdata() public view returns(uint){
        require(msg.sender==manager);
        return address(this).balance;
    }

    function getRandom() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,candidate.length)));
    }

    function PickWinner() public {
        require(msg.sender==manager);
        require(candidate.length>=3);
        uint r=getRandom();
        uint index=r%candidate.length;
        winner=candidate[index];
        winner.transfer(getdata());
        candidate=new address payable[](0);
    }

}
