//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Merge{
    uint[] public arr;

    constructor(uint[] memory _arr){
        require(_arr.length>2,"error");
        arr=_arr;
    }
    function merge1(uint num) external returns(bool)
    {
        uint L=0;
        uint R=arr.length-1;
        while(L<=R){
            uint mid=L+((R-L)>>1);
            if (arr[mid]==num){
                return true;
            }else if (arr[mid]>num){
                R=mid-1;
            }else {
                L=mid+1;
            }
        }
                return arr[L]==num;
    }
    function merge2(uint num) external returns(bool)
    {
        uint L=0;
        uint R=arr.length-1;
        uint flag=0;
        while(L<=R){
            uint mid=L+((R-L)>>1);
            if (arr[mid]>=num){
                flag=mid;
                R=mid-1;
            }
            L=mid+1;
        }
         return flag==0;
        }
               
    

    function merge3(uint num) external returns(bool)
    {
        uint L=0;
        uint R=arr.length-1;
        uint flag=0;
        while(L<=R){
            uint mid=L+((R-L)>>1);
            if (arr[mid]<=num){
                flag=mid;
                L=mid+1;
            }else {
                R=mid-1;
            }
        }
            return flag==0;
    }
}