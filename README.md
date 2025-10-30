# NFT Rental Protocol

## 📘 Project Description
The **NFT Rental Protocol** enables NFT owners to list their NFTs for rent, allowing renters to temporarily access NFTs for a fixed daily rate and duration.  
It promotes NFT utility and liquidity by creating a decentralized, trustless rental marketplace.

---

## 🌍 Project Vision
To make NFTs more functional by introducing a decentralized rental ecosystem — enabling ownership flexibility, shared utility, and passive income for NFT holders.

---

## ⚙️ Key Features
- **NFT Listing:** Owners can list NFTs with a chosen daily rental rate.
- **Secure Renting:** Renters pay upfront for a specific duration in ETH.
- **Automatic Return:** NFTs can be returned by the renter or reclaimed by the owner after the rental duration.
- **Event Logging:** Every major transaction is recorded on-chain.
- **Reentrancy Protection:** Built with OpenZeppelin’s `ReentrancyGuard`.

---

## 🧩 Tech Stack
- **Solidity (v0.8.x)** — Smart contract logic  
- **Remix IDE** — Compilation and deployment  
- **MetaMask** — Wallet connection on Core Testnet  
- **OpenZeppelin Contracts** — Secure base libraries

---

## 🪙 Core Functions

| Function | Description |
|-----------|--------------|
| `listNFTForRent(address _nftContract, uint256 _tokenId, uint256 _dailyRate)` | List your NFT for rent at a given daily rate. |
| `rentNFT(bytes32 _rentalId, uint256 _durationInDays)` | Rent an NFT for a specified number of days. |
| `returnNFT(bytes32 _rentalId)` | Return the rented NFT after the rental period or manually. |
| `getRentalDetails(bytes32 _rentalId)` | Retrieve complete details about a rental. |

---

## 🔒 Security
- **ReentrancyGuard** prevents reentrancy attacks.  
- Checks for **NFT ownership** and **contract approval** before listing.  
- Ensures **safe payments and refunds** during rental operations.

---

## 🔮 Future Scope
- Add ERC20 token-based rental payments.  
- Introduce auto-return mechanisms via Chainlink Automation.  
- Develop a front-end DApp with Ethers.js and React.  
- Enable fractional NFT rentals and revenue sharing.  

---

## 📜 Deployment Details
**Network:** Core Testnet  
**Compiler Version:** Solidity ^0.8.0  
**Deployed Contract Address:** `0xd9145CCE52D386f254917e481eB44e9943F39138`  

---

## 🖼️ Screenshot
![Transaction Screenshot](<img width="1380" height="892" alt="transaction_screenshot" src="https://github.com/user-attachments/assets/d3597c00-8d3b-4545-8576-f3342bd047ad" />
)

---

## 🧠 Project Summary
This project demonstrates practical understanding of:
- Smart contract architecture and events  
- Web3 deployment using MetaMask  
- OpenZeppelin security standards  
- Blockchain-based digital asset management  

