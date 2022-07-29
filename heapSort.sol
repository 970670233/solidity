//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

library arryaUtil{

    function swap(uint[] storage _arr,uint i,uint j)internal{
        uint temp=_arr[i];
        _arr[i]=_arr[j];
        _arr[j]=temp;
    }
      function heapInsert(uint[] storage _arr,uint index) internal{
        while(_arr[index]>_arr[(index-1)/2]){
                uint i=(index-1)/2;
                uint temp=_arr[i];
                _arr[i]=_arr[index];
                _arr[index]=temp;
                index=(index-1)/2;
        }
    }
    function heapIfy(uint[]storage _arr,uint index,uint heapSize) internal{
         uint left=index*2+1;
        while(left<heapSize){
            uint largest=left+1<heapSize&&_arr[left]<_arr[left+1]?left+1:left;
            largest=_arr[index]>_arr[largest]?index:largest;
            if (largest==index){
                return;
            }
             uint i=largest;
            uint temp=_arr[i];
            _arr[i]=_arr[index];
            _arr[index]=temp;
            index=largest;
            left=index*2+1;
        }
    }
   
}
contract HeapSort{
    uint[]  public arr;
    using arryaUtil for uint[];
    constructor(uint[] memory _arr){
        require(_arr.length>2,"error");
        arr=_arr;
    }
 
    function heapSort() external{
          for (uint i = 0; i < arr.length; i++) {
            arr.heapInsert(i);
        }
        uint heapSize=arr.length;
        arr.swap(0,--heapSize);
        while(heapSize>0){
            arr.heapIfy(0,--heapSize);
            heapSize=heapSize-1;
            arr.swap(0,--heapSize);
        }
        
    }
}