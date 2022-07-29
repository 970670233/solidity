//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
//创建排序库函数
library arraySort{
    function swap(uint[] storage arr,uint i,uint j) internal{
            uint temp=arr[i];
            arr[i]=arr[j];
            arr[j]=temp;
            
    }
}
contract Sort{
    using arraySort for uint[];
    uint[] public array=[1,3,5];
    function bubblesort() external  returns(uint[] memory){
            for(uint i=0;i<array.length-1;i++){
                for(uint j=0;j<array.length-1-i;j++){
                    if(array[j]>array[j+1]){
                    array.swap(j,j+1);
                    }
                }
            }
            return array;
    }
}