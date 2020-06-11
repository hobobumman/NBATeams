public class PlayerController {

    //Variables for binding
    public List<Contact> playerList{get;set;}
    public List<playerWrapper> wrapPlayerList {get; set;}
    public List<Contact> selectedPlayers{get;set;}
     
  
    public String searchName{get;set;}
    public String seasonYear{get;set;}
    
    //generate search results list of players
    public void generatePlayerList()
    {
		playerList = [SELECT id,Name,Points_Per_Game__c, Rebounds_Per_Game__c,Assists_Per_game__c, Blocks__c, Steals__c,Field_Goal_Percentage__c, Weight__c, Height_Feet__c, Height_Inches__c,Position__c FROM Contact WHERE name like: '%'+searchName+'%' ];
        if(wrapPlayerList !=null){
            wrapPlayerList = null;
        }
        
        if(wrapPlayerList == null) {
            wrapPlayerList = new List<playerWrapper>();
            for(Contact a: playerList) {
                // As each Account is processed we create a new wrapAccount object and add it to the wrapAccountList
                wrapPlayerList.add(new playerWrapper(a));
            }
        
        }        
    }//End generatePlayerList
    
    //Process selected Players
    public void processSelected(){
        selectedPlayers = new List<Contact>();
        if(wrapPlayerList !=null){
        for(playerWrapper wrapPlayerObj : wrapPlayerList) {
            if(wrapPlayerObj.selected == true) {
                selectedPlayers.add(wrapPlayerObj.ct);
            }}
        }
    }//End processSelected
}//End Class