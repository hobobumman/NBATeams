public class NBAPlayer {
    
    //web callouts with http objects. To be reused.
    public static Map<String,Object> WebCallout(string Endpoint){
        Map<String,Object> callOut = new Map<String,Object>();
        //http Callout stuff.
        Http httpCallout = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint('https://www.balldontlie.io/api/v1/'+Endpoint);
        httpReq.setMethod('GET');
        HttpResponse httpRes = httpCallout.send(httpReq);
        
        
        //Store the API request in theResult. check for errors. 
        if(httpRes.getStatusCode() == 200) {
            callOut = (Map<String,Object>) JSON.deserializeUntyped(httpRes.getBody());
        //If it isn't a success, tell us what it is.
        } else {
			callOut.put('The GET request returned a response with status code ', httpRes.getStatusCode());
            
        }
        //return statement
        return callOut;
    }
    
    public static void getPlayerStats(){
        
        List<Object> playerList = new List<Object>();
        Map<String,Object> specificPlayer = new Map<String,Object>();
        Map<String,Object> responseBody = new Map<String,Object>();
        Integer i =1;
		responseBody = NBAPlayer.WebCallout('players?per_page=100&page='+i);
        playerList =  (List<Object>) responseBody.get('data');
        
        system.debug('Player List Length: '+playerList.size());
        for(Object player : playerList){
			specificPlayer = (Map<String,Object>)player;
            system.debug('One Player: '+specificPlayer);
            
        } 
    }
    
    public static void getAllPlayers(){
        //This string will store the result of API consuation.
        //Variable declaration
        String theResult;
        List<Contact> storePlayers = new List<Contact>();
        List<Object> PlayerList = new List<Object>();
        Map<String,Object> specificPlayer = new Map<String,Object>();
        Map<String,Object> responseBody = new Map<String,Object>();
        
        //for loop to simply store every single player into the org database.
        for(Integer i= 1; i <=1 ; i++){
			responseBody = NBAPlayer.WebCallout('players?per_page=100&page='+i);
            playerList =  (List<Object>) responseBody.get('data');
            
            //Retrieve individual player and store as Contact object. Store in a contact list.
            for(Object player : playerList){
                specificPlayer = (Map<String,Object>)player;
                Contact Aplayer = new Contact();
                Aplayer.FirstName = (String) specificPlayer.get('first_name');
                Aplayer.LastName = (String) specificPlayer.get('last_name');
                Aplayer.Weight__c = (Decimal) specificPlayer.get('weight_pounds');
                Aplayer.Height_Feet__c = (Decimal) specificPlayer.get('height_feet');
                Aplayer.Height_Inches__c = (Decimal) specificPlayer.get('height_inches');
        		Aplayer.Position__c = (String) specificPlayer.get('position');
        		Aplayer.Player_ID__c = (Decimal) specificPlayer.get('id');
                
                system.debug('A single Player: '+Aplayer.Player_ID__c );
                //update season averages.
        		responseBody = NBAPlayer.WebCallout('season_averages?player_ids[]='+Aplayer.Player_ID__c);
        
        		//store the results in a list of players
        		playerList =  (List<Object>) responseBody.get('data');
				//system.debug('List Size: '+playerList.size());
        		//update every season average stat if the season average data is not empty.
                if(playerList.size()>0 && playerList != null){
                    //access information for a single player
        			specificPlayer = (Map<String,Object>)playerList[0];
        			Aplayer.Points_Per_Game__c = (Decimal) specificPlayer.get('pts');
                	Aplayer.Blocks__c = (Decimal) specificPlayer.get('blk');
        			Aplayer.Assists_Per_Game__c = (Decimal) specificPlayer.get('ast');
        			Aplayer.Rebounds_Per_Game__c = (Decimal) specificPlayer.get('reb');
        			Aplayer.Steals__c = (Decimal) specificPlayer.get('stl');
        			Aplayer.Turnovers__c = (Decimal) specificPlayer.get('turnover');
        			Aplayer.X3_Point_Percentage__c = (Decimal) specificPlayer.get('fg3_pct');
        			Aplayer.Field_Goal_Percentage__c = (Decimal) specificPlayer.get('fg_pct');
        			Aplayer.Free_Throw_Percentage__c = (Decimal) specificPlayer.get('ft_pct');
                }//end if statement
                
                storePlayers.add(Aplayer);
            }
        }
		
        insert storePlayers;
        
    }//End getAllPlayers Method FAILURE
    
    public static void playerSearch(String name, Integer season){
        //replace every space with %20 for the web search to work.
        name = name.replace(' ','%20');
        
        //Declare a few variables. 
        List<Object> playerList = new List<Object>();
        Map<String,Object> specificPlayer = new Map<String,Object>();
        Map<String,Object> responseBody = new Map<String,Object>();
        
        //perform the webcallout to retrieve information.
		responseBody = NBAPlayer.WebCallout('players?search='+name);
        //store the results in a list of players
        playerList =  (List<Object>) responseBody.get('data');
        //access information for a single player
        specificPlayer = (Map<String,Object>)playerList[0];
        //accessinformation for a single attribute of a single player
        //and store all of it in a new player (contact).
        Contact Aplayer = new Contact();
                Aplayer.FirstName = (String) specificPlayer.get('first_name');
                Aplayer.LastName = (String) specificPlayer.get('last_name');
                Aplayer.Weight__c = (Decimal) specificPlayer.get('weight_pounds');
                Aplayer.Height_Feet__c = (Decimal) specificPlayer.get('height_feet');
                Aplayer.Height_Inches__c = (Decimal) specificPlayer.get('height_inches');
        		Aplayer.Position__c = (String) specificPlayer.get('position');
        		Aplayer.Player_ID__c = (Decimal) specificPlayer.get('id');
        

        //update season averages.
        responseBody = NBAPlayer.WebCallout('season_averages?player_ids[]='+Aplayer.Player_ID__c);
        
        //store the results in a list of players
        playerList =  (List<Object>) responseBody.get('data');
        //access information for a single player
        specificPlayer = (Map<String,Object>)playerList[0];
        
        //update every season average stat.
        Aplayer.Points_Per_Game__c = (Decimal) specificPlayer.get('pts');
        Aplayer.Blocks__c = (Decimal) specificPlayer.get('blk');
        Aplayer.Assists_Per_Game__c = (Decimal) specificPlayer.get('ast');
        Aplayer.Rebounds_Per_Game__c = (Decimal) specificPlayer.get('reb');
        Aplayer.Steals__c = (Decimal) specificPlayer.get('stl');
        Aplayer.Turnovers__c = (Decimal) specificPlayer.get('turnover');
        Aplayer.X3_Point_Percentage__c = (Decimal) specificPlayer.get('fg3_pct');
        Aplayer.Field_Goal_Percentage__c = (Decimal) specificPlayer.get('fg_pct');
        Aplayer.Free_Throw_Percentage__c = (Decimal) specificPlayer.get('ft_pct');
        //update in database. 
        upsert APlayer;
    }

    	
}