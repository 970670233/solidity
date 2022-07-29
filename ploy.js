function main(){
    let a="!15.193.178.0";
    console.log("1");
    console.log(`${a.length}`);
    if(a.length<12||a.length>15){
        console.log("No");
        
    }
    let array=a.split(".");
    if(array.length!==4){
        console.log("No");
    }
    for(let i=0;i<array.length;i++){
        if(!Number.isInteger(parseInt(array[i]))){
            console.log(2);
        }
    }
}
main();