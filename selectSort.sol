//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

library arryaUtil{

    function swap(uint[] storage _arr,uint i,uint j)internal{
        uint temp=_arr[i];
        _arr[i]=_arr[j];
        _arr[j]=temp;
    }
   
}
contract SelectSort{
    uint[]  public arr;
    using arryaUtil for uint[];
    constructor(uint[] memory _arr){
        require(_arr.length>2,"error");
        arr=_arr;
    }
    function sort() external returns(uint[] memory _arr){
        for(uint i=0;i<arr.length;i++){
            uint min=i;
            for(uint j=i+1;j<arr.length-1;j++){
                if(arr[min]>arr[j]){
                        min=j;
                }

            }
            arr.swap(min,i);
        }
        _arr=arr;
    }
}