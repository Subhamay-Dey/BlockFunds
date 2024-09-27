//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _id
    ) external;
}

contract Escrow {
    address public lender;
    address payable public sender;
    address public inspector;
    address public nftAddress;

    constructor(
            address _nftAddress, 
            address payable _seller, 
            address _inspector, 
            address _lender
        ) {
            sender = _seller;
            inspector = _inspector;
            lender = _lender;
            nftAddress = _nftAddress;
        }
}