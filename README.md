# DevOpsBlockchain

## General approach for replication:

   1. Start a private Ethereum network with geth. Further information about the setup can be found at https://geth.ethereum.org/docs/fundamentals/private-network
   2. Connect your MetaMask to this network
   3. Deploy a contract on the network. You can insert the contracts in this repository into the Remix IDE and deploy them via MetaMask.
   4. Run the BLF using the manifests in this repository. More information about the BLF can be found at https://github.com/TU-ADSP/Blockchain-Logging-Framework

## Additional information

   To start the network used during the experiments in the paper, copy the information below. 
   Please consider that updates to geth or other unpredictable effects may change the functionality of this setup, which is why it may be necessary to create a new network.
   As long as it is a functioning private network created with geth the experiments should be replicable.

## Information abozt the private Ethereum network stored in the repository:

   - **node1**:
   
      Public address of the key: `0x1fBf6FDBDbB9c8EE418DC78D9dA2C512Fcec4142
      Path of the secret key file: node1\keystore\UTC--2023-06-15T18-19-12.531401200Z--1fbf6fdbdbb9c8ee418dc78d9da2c512fcec4142`
      
      Command to start node1:
      `geth --datadir node1 --port 30306 --bootnodes {enode of bnode}  --networkid 233234 --unlock 0x1fBf6FDBDbB9c8EE418DC78D9dA2C512Fcec4142 --password node1/password.txt --ws --ws.port 8554 --http.corsdomain "*" --ipcdisable --allow-insecure-unlock --miner.etherbase 0x1fBf6FDBDbB9c8EE418DC78D9dA2C512Fcec4142 --mine --http.port 8554 --http  console`
   
   - **bnode**:
      `enode://c396a35d41614a1401eb9628d3b90c7b0540f74a4d75734ef47fb7969e1f9c60478e6dadd66d118d282b96bc722a951414a34a6e4bd643e8b8b057895ed943ab@127.0.0.1:0?discport=30301`
      
      Start bnode:
      `bootnode -nodekey boot.key`

