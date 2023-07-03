// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {

    uint256 public number;
    event numberUpdated(uint256 numberOld, uint256 numberNew);
    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) external returns (uint256) {
        uint256 tmpNum = number;
        number = num;
        emit numberUpdated(tmpNum, number);
        return num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
}