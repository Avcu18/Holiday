// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// To-Do: Preise der reisen

contract Voting {

    mapping(uint => VacationSpot) public vacationspotMap; // Mapped die Id's auf die Freunde, für zugriff und sortierung
    mapping(address => bool) public GaveVote; // Mapped die Adresse der Freunde auf true/false, je nach dem ob sie gevotet haben
    event voteEvent(uint indexed _id);
    uint idDistribution;
    uint numberOfVacationSpots = 0;
    address owner;
    address[] public voter = [0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB];



    constructor() {
        addVacationSpot("Tuerkei", 200);
        addVacationSpot("Spanien", 300);
        owner = msg.sender;
    }

    // Erstelle ein Freunde Objekt, dass die gewünschte Attribute enthält
    struct VacationSpot {
        uint uniqueID; // um mapping zu vereinfachen
        string NameOfDestination;
        uint NumberOfvotes;
        uint PriceOfvacation;
    }


    function addVacationSpot(string memory _Name, uint price)public {
        idDistribution++;
        vacationspotMap[idDistribution] = VacationSpot(idDistribution, _Name, 0, price);
        numberOfVacationSpots++;
    }

    function vote(uint _id) public onlyFriends {
        require(!GaveVote[msg.sender],"you already voted"); //schaut ob die Adresse schon gevotet hat 
        require(_id > 0 && _id <= idDistribution); // Da wir durch eine unqiue ID unsere urlaubsorte fest gemacht haben, muss eine zahl größer 0 sein && Die Eingegebe Zahl darf nicht größer als die Anzahl von ausgeteilten Id's sein
        GaveVote[msg.sender] = true; // setzt den messenger auf true damit er nicht nochmal voted
        vacationspotMap[_id].NumberOfvotes++; //zählt die anzahl votes
        emit voteEvent(_id); //logged das event
    }

    //test für die anzahl an vacationspots
   function returnNumberOfVacationSpots() view public returns(uint){
    return numberOfVacationSpots;
   }

   //einfach den gewinner ausgeben
   function winnerOfVoting() view public returns(string memory, uint) {
    uint comperator= 0;
    string memory winner;
    uint cost;
    for (uint i = 1 ; i <= numberOfVacationSpots ; i++) 
    {
        if(vacationspotMap[i].NumberOfvotes> comperator){
            comperator = vacationspotMap[i].NumberOfvotes;
            winner = vacationspotMap[i].NameOfDestination;
            cost = vacationspotMap[i].PriceOfvacation;
        }
    }
    return (winner, cost);
   }
    // To-Do: Alle bools clearen, damit man erneut voten kann
    // nur der owner, also ich kann (die adresse die den contract deployed) kann die votes reseten
    function resetVoting() public onlyOwner {
        for (uint i = 1 ; i <= numberOfVacationSpots ; i++) 
        {
            vacationspotMap[i].NumberOfvotes = 0;
        }
    }
    // damit resetVoting() nur von mir ausgeführt werden kann
    modifier onlyOwner{
        require(msg.sender == owner,"Sender is not the owner");
        _;
    }
    // damit nur Freunde voten können
    modifier onlyFriends{
        bool isFriend = false;
        for (uint i = 0; i < voter.length; i++) 
        {
            if(voter[i] == msg.sender){
                isFriend = true;
                break;
            }
        }
        require(isFriend, "Voter is not a Friend");
        _;
    }
}