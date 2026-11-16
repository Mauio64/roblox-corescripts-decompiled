return [[
	    enum PresenceType {
	        InGame,
	        Online,
	        InStudio,
	        Offline,
	    }
	
	    interface Presence {
	        userPresenceType: PresenceType,
	        lastLocation: String,
	        lastOnline: String
	        gameId: String,
	        placeId: String,
	        rootPlaceId: String,
	        universeId: String,
	    }
	
	    type UserPresence implements Presence {
	        id: ID!
	        userPresenceType: PresenceType,
	        lastLocation: String,
	        lastOnline: String
	        gameId: String,
	        placeId: String,
	        rootPlaceId: String,
	        universeId: String,
	    }
	]]
