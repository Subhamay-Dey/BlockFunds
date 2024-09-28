const { expect } = require('chai');
const { ethers } = require('hardhat');

const tokens = (n) => {
    return ethers.utils.parseUnits(n.toString(), 'ether')
}

describe('Escrow', () => {
    let buyer, seller, inspector, lender
    let realEstate
    let escrow

    beforeEach(async () => {
        
    })

    describe("Deployment", () => {
        it("Returns NFT address", async() => {

        })
        it("Returns seller address", async() => {
            
        })
        it("Returns inspector address", async() => {
            
        })
        it("Returns lender address", async() => {
            
        })
    })


    it('saves the address', async() => {

        [buyer, seller, inspector, lender] = await ethers.getSigners()

        // Deploy Real Estate
        const RealEstate = await ethers.getContractFactory("RealEstate")
        realEstate = await RealEstate.deploy()

        //Mint
        let transaction = await realEstate.connect(seller).mint("https://ipfs.io/ipfs/QmQJc3tWrenPYqqHHWFVTTNxBww3Zagyr2udhPGCYn6mze?filename=1.json")
        await transaction.wait()

        const Escrow = await ethers.getContractFactory("Escrow")
        escrow = await Escrow.deploy(
            realEstate.address,
            seller.address,
            inspector.address,
            lender.address,
        )

        let result = await escrow.nftAddress()
        expect(result).to.equal(realEstate.address)

        result = await escrow.seller()
        expect(result).to.equal(seller.address)
    })
})