// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Crowd {
    struct Campaign {
        address payable owner;
        uint goal;
        uint deadline;
        uint amountRaised;
        bool isWithdrawn;
        mapping(address => uint) contributors;
    }

    uint public campaignCount;
    mapping(uint => Campaign) public campaigns;

    event CampaignCreated(uint campaignId, address owner, uint goal, uint deadline);
    event ContributionMade(uint campaignId, address contributor, uint amount);
    event FundsWithdrawn(uint campaignId, uint amount);
    event RefundIssued(uint campaignId, address contributor, uint amount);

    modifier onlyOwner(uint _campaignId) {
        require(msg.sender == campaigns[_campaignId].owner, "Only campaign owner can call this.");
        _;
    }

    modifier campaignExists(uint _campaignId) {
        require(_campaignId < campaignCount, "Campaign does not exist.");
        _;
    }

    modifier beforeDeadline(uint _campaignId) {
        require(block.timestamp < campaigns[_campaignId].deadline, "Deadline has passed.");
        _;
    }

    modifier afterDeadline(uint _campaignId) {
        require(block.timestamp >= campaigns[_campaignId].deadline, "Deadline has not passed yet.");
        _;
    }

    modifier goalNotReached(uint _campaignId) {
        require(campaigns[_campaignId].amountRaised < campaigns[_campaignId].goal, "Funding goal has been reached.");
        _;
    }

    function createCampaign(uint _goal, uint _duration) external {
        require(_goal > 0, "Goal must be greater than 0.");
        require(_duration > 0, "Duration must be greater than 0.");

        Campaign storage newCampaign = campaigns[campaignCount++];
        newCampaign.owner = payable(msg.sender);
        newCampaign.goal = _goal;
        newCampaign.deadline = block.timestamp + _duration;

        emit CampaignCreated(campaignCount - 1, msg.sender, _goal, newCampaign.deadline);
    }

    function contribute(uint _campaignId) external payable campaignExists(_campaignId) beforeDeadline(_campaignId) {
        require(msg.value > 0, "Contribution must be greater than 0.");

        Campaign storage campaign = campaigns[_campaignId];
        campaign.contributors[msg.sender] += msg.value;
        campaign.amountRaised += msg.value;

        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    function withdrawFunds(uint _campaignId) external onlyOwner(_campaignId) afterDeadline(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.amountRaised >= campaign.goal, "Campaign has not reached its goal.");
        require(!campaign.isWithdrawn, "Funds already withdrawn.");

        campaign.isWithdrawn = true;
        campaign.owner.transfer(campaign.amountRaised);

        emit FundsWithdrawn(_campaignId, campaign.amountRaised);
    }

    function refund(uint _campaignId) external campaignExists(_campaignId) afterDeadline(_campaignId) goalNotReached(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        uint amount = campaign.contributors[msg.sender];
        require(amount > 0, "No contributions to refund.");

        campaign.contributors[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit RefundIssued(_campaignId, msg.sender, amount);
    }

    function getCampaignDetails(uint _campaignId) external view campaignExists(_campaignId) returns (address, uint, uint, uint, bool) {
        Campaign storage campaign = campaigns[_campaignId];
        return (campaign.owner, campaign.goal, campaign.deadline, campaign.amountRaised, campaign.isWithdrawn);
    }
}
