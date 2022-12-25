/*
Q1. Don't we need a keepers contract to automatically keep our functions operational?
*/

pragma solidity ^0.8.0;

contract DutchAuction {
    address public owner;
    uint public startTime;
    uint public endTime;
    uint public startingPrice;
    uint public currentPrice;
    uint public minPrice;
    uint public timespent;
    uint public timespan;
    address public highestBidder;
    uint public highestBid;
    event BidPlaced(address bidder, uint bid);
    event AuctionEnded(bool sold address bidder, uint bid);

    // input: timespan
    constructor(uint _startTime, uint _timespan, uint _endTime, uint _startingPrice, uint _minPrice) public {
        owner = msg.sender;
        startTime = _startTime;
        // timespan that will periodically check auction status
        timespan = _timespan;
        // timespent set to 0 to check time passed
        timestamp = now;
        endTime = _endTime;
        startingPrice = _startingPrice;
        currentPrice = _startingPrice;
        minPrice = _minPrice;
    }

    // bid function for bidders
    function bid(uint _bid) public payable {
        require(_bid > highestBid, "Bid must be higher than current bid");
        require(_bid >= currentPrice, "Bid must be equal to or higher than the current price");
        require(_bid <= startingPrice, "Bid must be lower than or equal to the starting price");
        require(now >= startTime, "Auction hasn't started yet");
        require(now <= endTime, "Auction has already ended");

        highestBidder.transfer(highestBid);
        currentPrice = _bid;
        highestBid = _bid;
        highestBidder = msg.sender;
        timestamp = now;

        emit BidPlaced(msg.sender, _bid);
    }

    // ends auction
    function endAuction() internal {
        require(now > endTime, "Auction hasn't ended yet");
        if (highestBid > 0) { owner.transfer(highestBidder); emit AuctionEnded(true, 0, 0); } 
        else { emit AuctionEnded(false, 0, 0)  }
    }

    // Function to check & update auction's current status
    function updateAuction() public {
        timespent = (now - timestamp)
        // should update be restricted to the owner or for others too?
        require(msg.sender == owner, "Only the owner can update contract status");
        // before ending + elapsed enough time to reduce price
        if (now >= endTime) { return endAuction() } 
        else if (now < endTime && timespent >= timespan) { currentPrice = currentPrice.sub(currentPrice.div(10)); timestamp = now; }
        // if the price is too low, than we raise it back up to the minPrice
        if (currentPrice < minPrice) { currentPrice = minPrice  };
    }
}
