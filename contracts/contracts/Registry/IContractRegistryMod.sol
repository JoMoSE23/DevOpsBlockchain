pragma solidity ^0.8.0;

interface IContractRegistryMod {
    

   /*
    *  @notice REQUIRED The event that is emitted when the contract gets added to the registry
    *  @param name the name of the contract
    *  @param contractAddress the address of the added contract
    *  @param isProxy whether the added contract is a proxy
    */
   event AddedContract(string name, address contractAddress);

   /**
    *  @notice REQUIRED The event that is emitted when the contract get removed from the registry
    *  @param name the name of the removed contract
    */
   event RemovedContract(string name);

   

   /**
    *  @notice REQUIRED The function that returns an associated contract by the name
    *  @param name the name of the contract
    *  @return the address of the contract
    */
   function getContract(string memory name) external view returns (address);

   /**
    *  @notice OPTIONAL The function that checks if a contract with a given name has been added
    *  @param name the name of the contract
    *  @return true if the contract is present in the registry
    */
   function hasContract(string memory name) external view returns (bool);

   /**
    *  @notice RECOMMENDED The function that returns the admin of the added proxy contracts
    *  @return the proxy admin address
    */
   function getUpgrader(string memory name) external view returns (address);

   /**
    *  @notice REQUIRED The function that upgrades added proxy contract with a new implementation
    *  @param name the name of the proxy contract
    *  @param newImplementation the new implementation the proxy will be upgraded to
    *
    *  It is the Owner's responsibility to ensure the compatibility between implementations
    */
   function upgradeContract(string memory name, address newImplementation) external;

   /**
    *  @notice REQUIRED The function that adds pure (non-proxy) contracts to the ContractsRegistry. The contracts MAY either be
    *  the ones the system does not have direct upgradeability control over or the ones that are not upgradeable by design
    *  @param name the name to associate the contract with
    *  @param contractAddress the address of the contract
    */
   function addContract(string memory name, address contractAddress) external;

   /**
    *  @notice REQUIRED The function to remove contracts from the ContractsRegistry
    *  @param name the associated name with the contract
    */
   function removeContract(string memory name) external;
}
