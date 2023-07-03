pragma solidity ^0.8.18;

import "./IDiamondCut.sol";
import "./DiamondStorage.sol";
import "./IDiamondLoupe.sol";

//[[0x3656206fCF23d4D2FBDFE5196509fDA2e05E2862, 0, [0x6ed28ed0]]], 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000
//[[0x5b991d64830e79968D2737770212C4341AE2F45a, 0, [0x6057361d]]], 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000
//0x6057361d0000000000000000000000000000000000000000000000000000000000000005
//0x6ed28ed000000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000004

contract Diamond is IDiamondCut, DiamondStorage, IDiamondLoupe{
    
    event callFailed(address _init, bytes _calldata);
    mapping(bytes4 => address) public selectorToAddress;
    bytes4[] public selectors;
    address[] public storedAddresses;
    

    function getNumber10() public view returns(uint256 num){
        MyStorage storage ms = myStorage();
        return ms.num10;
    }

    function getNumber100() public view returns(uint256 num){
        MyStorage storage ms = myStorage();
        return ms.num100;
    }


    fallback() external payable {
        // get facet from function selector
        address facet = selectorToAddress[msg.sig];
        require(facet != address(0));
        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 {revert(0, returndatasize())}
            default {return (0, returndatasize())}
        }
    }

    function diamondCut(FacetCut[] calldata _diamondCut, address _init, bytes calldata _calldata) external{
        for (uint i = 0; i < _diamondCut.length; i++){
            if(_diamondCut[i].action == FacetCutAction.Add){
                for(uint k = 0; k < _diamondCut[i].functionSelectors.length; k++){
                    if(selectorToAddress[_diamondCut[i].functionSelectors[k]] == address(0)){
                    selectorToAddress[_diamondCut[i].functionSelectors[k]] = _diamondCut[i].facetAddress;
                    selectors.push(_diamondCut[i].functionSelectors[k]);
                    }
                }
            }

            if(_diamondCut[i].action == FacetCutAction.Replace){
                for(uint k = 0; k < _diamondCut[i].functionSelectors.length; k++){
                    if(selectorToAddress[_diamondCut[i].functionSelectors[k]] != address(0)){
                    selectorToAddress[_diamondCut[i].functionSelectors[k]] = _diamondCut[i].facetAddress;
                    }
                }
            }

            if(_diamondCut[i].action == FacetCutAction.Remove){
                for(uint k = 0; k < _diamondCut[i].functionSelectors.length; k++){
                    selectorToAddress[_diamondCut[i].functionSelectors[k]] = address(0);
                    for(uint j = 0; j < selectors.length; j++){
                        if(selectors[j] == _diamondCut[i].functionSelectors[k]){
                            if(j < selectors.length - 1){
                                selectors[j] = selectors[selectors.length-1];
                                selectors.pop();
                            }
                        }
                    }
                }
            }
        }


        storedAddresses = facetAddressesSupport();
        emit DiamondCut(_diamondCut, _init, _calldata);
        if(_init != address(0)){
            (bool success, ) = _init.delegatecall(_calldata);
            if(!success){
                emit callFailed(_init, _calldata);
            }
        }
    }

    function facetFunctionSelectors(address _facet) external view returns (bytes4[] memory facetFunctionSelectors_){
        uint c = 0;
        for(uint i = 0; i < selectors.length; i++){
            if(selectorToAddress[selectors[i]] == _facet){
                c++;
            }
        }

        facetFunctionSelectors_ = new bytes4[](c);

        c = 0;

        for(uint i = 0; i < selectors.length; i++){
            if(selectorToAddress[selectors[i]] == _facet){
                facetFunctionSelectors_[c++] = selectors[i];
            }
        }

        return facetFunctionSelectors_;
    }

    function facetAddress(bytes4 _functionSelector) external view returns (address facetAddress_){
        return selectorToAddress[_functionSelector];
    }

    function facetAddressesSupport() internal returns (address[] memory facetAddresses_){

        address[] memory allAddresses = new address[](selectors.length);
        uint c = 0;
        for(uint i = 0; i < selectors.length; i++){
            
            bool duplicate;
            for(uint k = 0; k < c; k++){
                if(selectorToAddress[selectors[i]] == allAddresses[k]){
                    duplicate = true;
                    
                }
            }

            if(!duplicate){
                allAddresses[c++] = selectorToAddress[selectors[i]];
            }

            duplicate = false;
        }

        facetAddresses_ = new address[](c);
        
        for(uint i = 0; i < c; i++){
            facetAddresses_[i] = allAddresses[i];
        }
        return facetAddresses_;
    }

    function facetAddresses() external view returns (address[] memory facetAddresses_){

       return storedAddresses;
    }

    function facets() external view returns (Facet[] memory facets_){

        facets_ = new Facet[](this.facetAddresses().length);
        uint c = 0;
        for(uint i = 0; i < this.facetAddresses().length; i++){
            Facet memory curr = Facet(this.facetAddresses()[i], this.facetFunctionSelectors(this.facetAddresses()[i]));
            facets_[c++] = curr;
        }

        return facets_;
    }

}