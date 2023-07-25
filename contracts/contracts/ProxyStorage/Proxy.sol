
pragma solidity ^0.8.18;

//This is the implementation of the normal proxy pattern
//Used delegate is the Contract 1_Storage.sol provided upfront by remix.ethereum.org
// calldata: 0x6057361d0000000000000000000000000000000000000000000000000000000000000006
contract Proxy{

    
    //event numberUpdated(uint256 numberOld, uint256 numberNew);

    constructor(address _delegate){
        bytes32 position = keccak256("delegate");
            assembly {
            sstore(position, _delegate)}
    }

    //variable is accessed via unstructured storage
    function getNumber() public view returns(uint256 num){
        bytes32 position = keccak256("number");
        assembly {
        num := sload(position)
      }
    }

    //variable is accessed via unstructured storage
    function getDelegate() public view returns(address delegate){
        bytes32 position = keccak256("delegate");
        assembly {
        delegate := sload(position)
      }
    }

     function updateDelegate(address _delegate) public{
        bytes32 position = keccak256("delegate");
            assembly {
            sstore(position, _delegate)}
      
    }

    //fallback function
    fallback() external payable{
        // get facet from function selector
        address _delegate = getDelegate();
        require(_delegate != address(0));
        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            
            calldatacopy(0x0, 0x0, calldatasize())
            
            // execute function call using the facet
            let result := delegatecall(gas(), _delegate, 0x0, calldatasize(), 0x0, 0x0)
            // get any return value
            returndatacopy(0x0, 0x0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 {revert(0x0, returndatasize())}
            default {return (0x0, returndatasize())}
        }
    }
}