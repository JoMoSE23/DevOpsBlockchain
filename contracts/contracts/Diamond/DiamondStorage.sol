pragma solidity ^0.8.18;

contract DiamondStorage {
// The state variables we care about.
  struct MyStorage {
    uint256 num10;
    uint256 num100;
  } 
  // Creates and returns the storage pointer to the struct.
  function myStorage() internal pure returns(MyStorage storage ms) {
    bytes32 ms_slot = keccak256("nums");
    assembly {ms.slot := ms_slot}
  }
}