// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {

    uint256 public number;
    event numberUpdated(uint256 _numberOld, uint256 _numberNew);
    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 _num) external returns (uint256) {
        uint256 tmpNum = number;
        number = _num;
        emit numberUpdated(tmpNum, number);
        bytes32 position = keccak256("number");
            assembly {
            sstore(position, _num)}
        return _num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
}