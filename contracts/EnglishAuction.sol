pragma solidity ^0.8.0;

contract EnglishAuction{
    address public owner;
    uint public startTime;
    uint public endtime;
    uint public startingPrice;
    address public highestBidder;
    uint public highestBid;
    event BidPlaced(address bidder, uint bid);
    event AuctionEnded(address bidder, uint bid);
    

    constructor(uint _startTime, uint _endTime, uint _startingPrice) public {
        owner = msg.sender;
        startTime = _startTime;
        endTime = _endTime;
        startingPrice = _startingPrice;
        highestBid = _startingPrice;
    }

    function bid(uint _bid) public payable {
        require(now >= startTime,  "Auction hasn't started yet");
        require(now >= endTime, "Auction has already ended");
        require(_bid > highestBid, "Bid must be higher than current bid");
        
        highestBidder.transfer(highestBid);
        highestBid = _bid;
        highestBidder = msg.sender;

        emit BidPlaced(highestBidder, highestBid);
    }

    function endAuction() public {
        require(now > endTime, "Auction has not ended yet");

        if (highestBid > startingPrice) {
            owner.transfer(highestBidder);
            emit AuctionEnded(true, highestBidder, highestBid);
        } else {
            emit AuctionEnded(false, 0, 0);
        }
    }

    event AuctionEnd(uint endTime);

    function triggerEndAuction(uint _endTime) public {
        require(msg.sender == owner, "Ending the auction can be only triggered by the owner");
        emit AuctionEnd(_endTime);
    }

    function onAuctionEnd(uint _endTime) public {
        require(_endTime == endTime, "Invalid end time");
        endAuction();
    }
}
