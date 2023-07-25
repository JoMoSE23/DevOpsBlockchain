// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


import "./DiamondStorage.sol";
/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage is DiamondStorage{

    uint256 public number;
    event numberUpdated(uint256 _numberOld, uint256 _numberNew);
    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 _num) external returns (uint256) {
        MyStorage storage ms = myStorage();
        uint256 tmpNum = ms.num10;
        ms.num10 = _num;
        emit numberUpdated(tmpNum, ms.num10);
        return _num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        MyStorage storage ms = myStorage();
        return ms.num10;
    }
}