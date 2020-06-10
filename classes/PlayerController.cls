public class PlayerController {

    //Variables for binding
    public List<Contact> playerList{get;set;}
    public String searchName{get;set;}
    public String seasonYear{get;set;}
    
    //generate search results list of players
    public void generatePlayerList()
    {
         	
		playerList = [SELECT Name, Weight__c, Height_Feet__c, Height_Inches__c,Position__c FROM Contact WHERE name =:searchName ];
    }
    
    
}