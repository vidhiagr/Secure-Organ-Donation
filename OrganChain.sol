pragma solidity ^0.4.25;

contract OrganChain {
    
    address public manager;
    uint public minAmt;
    address[] public approvers;
    
    constructor(uint minimum) public {
        manager = msg.sender;
        minAmt = minimum;
    }
    
    function donate() public payable {
        require(msg.value > minAmt);
        approvers.push(msg.sender);
    }
    
    //structures
    struct recipient{
        address patientid;
        uint age;
        string organ;
        string bloodgroup;
        string rhfactor;
        bool matchfound;
        bool exist;
    }
    
    struct donor{
        address donorid;
        uint age;
        string organ;
        string bloodgroup;
        string rhfactor;
        bool matchfound;
        bool exist;
    }
    
    struct transplant{
        address recipient;
        address donor;
        bool exist;
    }
    
    //global variables
    address[] recipientarr;
    address[] donorarr;
    address[] transplantarr;
    
    //Mappings
    mapping(address => recipient) Recipients;
    mapping(address => donor) Donors;
    mapping(address => transplant) Transplants;
    
    //modifier
    
    modifier checkrecipientexist(address addr){
        require(!Recipients[addr].exist,"recipient already added");
        _;
    }
    
     modifier checkdonorexist(address addr){
        require(!Donors[addr].exist,"recipient already added");
        _;
    }
    
    //donor functions
    
    function adddonor(
        address donori,
        uint age,
        string memory organ_name,
        string memory bgroup,
        string memory factor) public checkdonorexist(donori){
            Donors[donori]=donor(donori,age,organ_name,bgroup,factor,false,true);
            donorarr.push(donori);
        }
        
    function getdonor(address donoradd) public view
    returns (address,
    uint,
    string memory ,
    string memory ,
    string memory ){
        if(!Donors[donoradd].matchfound)
        return(
            Donors[donoradd].donorid,
            Donors[donoradd].age,
            Donors[donoradd].organ,
            Donors[donoradd].bloodgroup,
            Donors[donoradd].rhfactor);
        else
        getdonorandrecipientwithtransplant(donoradd);
    }
    
    function getdonorandrecipientwithtransplant(address donoradd) public view
    returns (address,
    uint,
    string memory ,
    string memory ,
    string memory,
    address) {
        for(uint i=0;i<transplantarr.length;i++)
        {
            if(donoradd==Transplants[transplantarr[i]].donor)
            return(Donors[donoradd].donorid,
            Donors[donoradd].age,
            Donors[donoradd].organ,
            Donors[donoradd].bloodgroup,
            Donors[donoradd].rhfactor,
            Transplants[transplantarr[i]].recipient);
        }
    }
    
    //recipient functions
    
    function addrecipient(
        address patient,
        uint age,
        string memory organ_name,
        string memory bgroup,
        string memory factor) public checkrecipientexist(patient){
            Recipients[patient]=recipient(patient,age,organ_name,bgroup,factor,false,true);
            recipientarr.push(patient);
    }
        
    function getrecipient(address reciadd) public view
    returns(address,
   // address,
    uint,
    string memory ,
    string memory ,
    string memory ){
        return(
            Recipients[reciadd].patientid,
            Recipients[reciadd].age,
            Recipients[reciadd].organ,
            Recipients[reciadd].bloodgroup,
            Recipients[reciadd].rhfactor);
    }
    
    
    //transplant matching
    uint minAge=150;
    address rAddr;
    function transplantmatch(address donorad) public
    returns(address) {
        for(uint i=0;i<recipientarr.length;i++)
        {
            if(  Recipients[recipientarr[i]].matchfound == false && (keccak256(abi.encodePacked(Recipients[recipientarr[i]].organ))==keccak256(abi.encodePacked(Donors[donorad].organ))) 
            && (keccak256(abi.encodePacked(Recipients[recipientarr[i]].bloodgroup))==keccak256(abi.encodePacked(Donors[donorad].bloodgroup)))
            && (keccak256(abi.encodePacked(Recipients[recipientarr[i]].rhfactor))==keccak256(abi.encodePacked(Donors[donorad].rhfactor))) )
            {
                if(Recipients[recipientarr[i]].age < minAge){
                    minAge=Recipients[recipientarr[i]].age;
                    rAddr=recipientarr[i];
                }
            }
        }
                
        Transplants[rAddr]=transplant(rAddr,donorad,true);
        transplantarr.push(rAddr);
        Recipients[rAddr].matchfound=true;
        Donors[donorad].matchfound=true;
        return (rAddr);
    }
}