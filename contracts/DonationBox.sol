// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DonationBox {
    address public immutable admin;
    struct Donation {
        address donor;
        uint256 amount;
        uint256 donationDate;
    }



    constructor() {
        admin = msg.sender;
    }


    mapping(address => Donation) public donations;
    uint public totalDonations;

    function _getDonor() private view returns (Donation memory )  {
        address donor = donations[msg.sender].donor;
        if(donor != address(0)){
            return donations[msg.sender];
        }
        return Donation(msg.sender, 0, 0);
    }

    function donate () public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        require(admin != msg.sender, "Admin cannot donate");
        Donation memory donation = _getDonor();
        donation.amount += msg.value;
        donation.donationDate = block.timestamp;
        totalDonations += msg.value;
        donations[msg.sender] = donation;
    }

    function getDonor() public view returns (Donation memory) {
        return  donations[msg.sender];
    }

    function withdraw() public{
        require(msg.sender == admin, "Only admin can withdraw");
        uint256 amount = address(this).balance;
        payable(admin).transfer(amount);
    }
    
}