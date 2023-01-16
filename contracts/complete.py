// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./extensions/ERC20Epochs.sol";

// question: is Epoch okay?
// maybe prefix-type naming is better?


// why not just mint everything to DecipherDAO and let the DAO distribute?
contract DPOCTokenContract is ERC20Epochs {
        // current admins passes contracts
        address tokenManager = 0x2dbbaB8dcF8Ca0DB41FDa35Cd04Cb4257697585F;
        address auctionContract = 0x1F6a860Ec8F152558a6e4EfD0880D22EF3Ea1EF0;

    constructor() ERC20Epochs("DecipherPOC", "POC") {
    }

    function mint(address account, uint amount) public {
                require(msg.sender == tokenManager, "Not Authorized!");
                _mint(account, amount);

    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
                require(msg.sender == tokenManager, "Not Authorized!");
                _transfer(msg.sender, to, amount);
                return true;

    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
                require(spender == auctionContract, "This Auction Contract is Not Authorized!");
                address owner = msg.sender;
                _approve(owner, spender, amount);
                return true;

    }

    function createEpoch() public virtual override returns (uint256) {
                require(msg.sender == tokenManager);
                return super.createEpoch();

    }


    function changeAuctionAddress(address newAuction) public returns (bool) {
                require(msg.sender == tokenManager);
                auctionContract = newAuction;
                return true;

    }

    function changeTokenManager(address newManager) public returns (bool) {
                require(msg.sender == tokenManager);
                tokenManager = newManager;
                return true;

    }

}

