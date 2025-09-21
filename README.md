# 🧠 DutchAuction — Foundry Project

Welcome to the **Dutch Auction NFT DApp** built using [Foundry](https://book.getfoundry.sh/)! This project includes:

- 🎯 A customizable **DutchAuction** contract
- 🖼️ An ERC-721 token (**MyToken**) using OpenZeppelin
- 🧪 Full test suite with Foundry
- 🛠️ Deployment scripts for local Anvil network

---

## What is Dutch auction?
A Dutch auction, also known as the open-descending auction, is a type of auction where the seller first sets a starting price, duration, and a discount rate. As time passes, the item's price keeps decreasing until the preset duration time has ended. For example, suppose there is a really good bag you want to get but it is out of your budget. In that case, as time goes on the bag will get cheaper; first a 10% discount, then 30%, then 50%, until the bag is cheap enough for you to purchase. This is the concept of Dutch auctions. To make this work on Ethereum we will need to create and deploy both an ERC721 contract and a dutch auction smart contract.

---

## 🚀 Features

- ⏱️ **Dutch Auction** with linear price decay over 7 days
- 🧾 **ERC-721** compliant NFT (`MyToken`)
- 🔒 Ownership control using `Ownable`
- 💸 Refund overpayment on purchase
- 💻 Local development using **Anvil**

---

## 🧱 Contracts

### 🔹 `MyToken.sol`
Standard ERC-721 with `safeMint` function, owned by the deployer.

### 🔹 `DutchAuction.sol`
Auction contract for NFTs:
- Auction lasts 7 days
- Price decreases over time at a constant `discountRate`
- NFT is transferred when the auction is won
- Refunds any excess ETH

---

## 📦 Project Structure

```

.
├── src/
│   ├── DutchAuction.sol        # Dutch Auction contract
│   └── MyToken.sol             # ERC-721 NFT contract
│
├── script/
│   ├── DeployMyToken.s.sol     # Deploys MyToken and mints token
│   └── DeployDutchAuction.s.sol # Deploys DutchAuction using MyToken
│
├── test/
│   └── DutchAuction.t.sol      # Test suite for DutchAuction
│
├── foundry.toml                # Foundry config
└── README.md                   # This file!

````

## 🚦 Getting Started

### 📥 Installation

1. Clone the repository
   ```bash
   git clone https://github.com/mishraji874/Dutch-Auction-Smart-Contract.git
   cd Dutch-Auction-Smart-Contract
   ```
2. Install dependencies:
   ```bash
   forge install OpenZeppelin/openzeppelin-contracts
   ```
3. Build the project:
   ```bash
   forge build
   ```

---

## 🧪 Run Locally

### 1️⃣ Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
````

### 2️⃣ Start Local Blockchain

```bash
anvil
```

Anvil will start with test accounts. Save the private key from Account #0.

### 3️⃣ Compile the Contracts

```bash
forge build
```

### 4️⃣ Deploy Contracts

#### ✅ Deploy `MyToken` and Mint

```bash
forge script script/DeployMyToken.s.sol --broadcast --rpc-url http://localhost:8545
```

> 📝 This deploys `MyToken` and mints token ID `1` to the deployer.

#### ✅ Deploy `DutchAuction`

Edit `DeployDutchAuction.s.sol` to use the `MyToken` contract address, then run:

```bash
forge script script/DeployDutchAuction.s.sol --broadcast --rpc-url http://localhost:8545
```

---

## 🧪 Run Tests

```bash
forge test -vv
```

> ✅ All tests are written using the latest Foundry style with `vm.expectRevert`.

---

## 🛠️ Developer Info

* Language: Solidity `^0.8.20`
* Test Framework: [Foundry](https://book.getfoundry.sh/)
* OpenZeppelin: [ERC-721](https://docs.openzeppelin.com/contracts/4.x/api/token/erc721)

---

## 🧑‍💻 Example Auction Parameters

| Param          | Value                   |
| -------------- | ----------------------- |
| Duration       | 7 days                  |
| Starting Price | `1 ether`               |
| Discount Rate  | `1157407407407 wei/sec` |
| Token ID       | `1`                     |

---

## 📜 License

MIT © 2025 — Use freely for learning, modification, and deployment.

---

## 🤝 Contributions

Want to improve this project? PRs welcome! 🚀
Have questions? Open an issue or reach out!
