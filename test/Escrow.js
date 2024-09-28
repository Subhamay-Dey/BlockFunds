const { expect } = require('chai');
const { ethers } = require('hardhat');

const tokens = (n) => {
    return ethers.utils.parseUnits(n.toString(), 'ether')
}

describe('Escrow', () => {
    it('saves the address', async() => {

        // Deploy Real Estate
        const RealEstate = await ethers.getContractFactory("RealEstate")
        const realEstate = await RealEstate.deploy()

        console.log(realEstate.address);

        //Mint
        let transaction = await realEstate.mint("https://ipfs.io/ipfs/QmQJc3tWrenPYqqHHWFVTTNxBww3Zagyr2udhPGCYn6mze?filename=1.json")
        
    })
})