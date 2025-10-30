// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTRentalProtocol is ReentrancyGuard {
    
    struct Rental {
        address owner;
        address renter;
        uint256 tokenId;
        address nftContract;
        uint256 dailyRate;
        uint256 startTime;
        uint256 endTime;
        bool isActive;
    }
    
    mapping(bytes32 => Rental) public rentals;
    mapping(address => mapping(uint256 => bytes32)) public activeRentals;
    
    event NFTListed(
        bytes32 indexed rentalId,
        address indexed owner,
        address indexed nftContract,
        uint256 tokenId,
        uint256 dailyRate
    );
    
    event NFTRented(
        bytes32 indexed rentalId,
        address indexed renter,
        uint256 startTime,
        uint256 endTime,
        uint256 totalCost
    );
    
    event NFTReturned(
        bytes32 indexed rentalId,
        address indexed owner,
        address indexed renter
    );
    
    /**
     * @dev List an NFT for rental
     * @param _nftContract Address of the NFT contract
     * @param _tokenId Token ID to list
     * @param _dailyRate Rental rate per day in wei
     */
    function listNFTForRent(
        address _nftContract,
        uint256 _tokenId,
        uint256 _dailyRate
    ) external nonReentrant {
        require(_nftContract != address(0), "Invalid NFT contract");
        require(_dailyRate > 0, "Daily rate must be greater than 0");
        
        IERC721 nft = IERC721(_nftContract);
        require(nft.ownerOf(_tokenId) == msg.sender, "Not the NFT owner");
        require(
            nft.getApproved(_tokenId) == address(this) || 
            nft.isApprovedForAll(msg.sender, address(this)),
            "Contract not approved"
        );
        
        bytes32 rentalId = keccak256(
            abi.encodePacked(_nftContract, _tokenId, msg.sender, block.timestamp)
        );
        
        require(activeRentals[_nftContract][_tokenId] == bytes32(0), "NFT already listed");
        
        rentals[rentalId] = Rental({
            owner: msg.sender,
            renter: address(0),
            tokenId: _tokenId,
            nftContract: _nftContract,
            dailyRate: _dailyRate,
            startTime: 0,
            endTime: 0,
            isActive: false
        });
        
        activeRentals[_nftContract][_tokenId] = rentalId;
        
        emit NFTListed(rentalId, msg.sender, _nftContract, _tokenId, _dailyRate);
    }
    
    /**
     * @dev Rent an NFT for a specified duration
     * @param _rentalId The rental ID
     * @param _durationInDays Number of days to rent
     */
    function rentNFT(bytes32 _rentalId, uint256 _durationInDays) 
        external 
        payable 
        nonReentrant 
    {
        Rental storage rental = rentals[_rentalId];
        
        require(rental.owner != address(0), "Rental does not exist");
        require(!rental.isActive, "NFT is already rented");
        require(_durationInDays > 0, "Duration must be at least 1 day");
        require(msg.sender != rental.owner, "Owner cannot rent their own NFT");
        
        uint256 totalCost = rental.dailyRate * _durationInDays;
        require(msg.value >= totalCost, "Insufficient payment");
        
        rental.renter = msg.sender;
        rental.startTime = block.timestamp;
        rental.endTime = block.timestamp + (_durationInDays * 1 days);
        rental.isActive = true;
        
        IERC721(rental.nftContract).transferFrom(
            rental.owner,
            msg.sender,
            rental.tokenId
        );
        
        payable(rental.owner).transfer(totalCost);
        
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
        
        emit NFTRented(_rentalId, msg.sender, rental.startTime, rental.endTime, totalCost);
    }
    
    /**
     * @dev Return the rented NFT back to the owner
     * @param _rentalId The rental ID
     */
    function returnNFT(bytes32 _rentalId) external nonReentrant {
        Rental storage rental = rentals[_rentalId];
        
        require(rental.isActive, "Rental is not active");
        require(
            msg.sender == rental.renter || 
            msg.sender == rental.owner || 
            block.timestamp >= rental.endTime,
            "Not authorized or rental period not ended"
        );
        
        IERC721(rental.nftContract).transferFrom(
            rental.renter,
            rental.owner,
            rental.tokenId
        );
        
        rental.isActive = false;
        delete activeRentals[rental.nftContract][rental.tokenId];
        
        emit NFTReturned(_rentalId, rental.owner, rental.renter);
    }
    
    /**
     * @dev Get rental details
     * @param _rentalId The rental ID
     */
    function getRentalDetails(bytes32 _rentalId) 
        external 
        view 
        returns (
            address owner,
            address renter,
            uint256 tokenId,
            address nftContract,
            uint256 dailyRate,
            uint256 startTime,
            uint256 endTime,
            bool isActive
        ) 
    {
        Rental memory rental = rentals[_rentalId];
        return (
            rental.owner,
            rental.renter,
            rental.tokenId,
            rental.nftContract,
            rental.dailyRate,
            rental.startTime,
            rental.endTime,
            rental.isActive
        );
    }
}
