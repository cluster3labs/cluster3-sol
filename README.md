### cluster-sol

cluster solidity version

### how to develop
1. use remixd connect localfile to https://remix.ethereum.org/
   1. install remixd 
       ```shell
       npm install -g @remix-project/remixd
       # check install
       remixd -v
       # connect
       remixd -s /doc/cyber/cluster-sol --remix-ide https://remix.ethereum.org/\#optimize\=false\&runs\=200\&evmVersion\=null\&version\=soljson-v0.8.7+commit.e28d00a7.js
       ```

### all contract
1. BadgeNft contract【[描述](https://github.com/cluster3labs/cluster3-sol/blob/master/contract/contracts/BadgeNft.md)】


### deploy to god woken
1. run in hardhat.js path 
       ```shell
       PRIVATE_KEY=<YOUR_PK> npx hardhat run scripts/deploy.js --network godwoken-testnet
       ```