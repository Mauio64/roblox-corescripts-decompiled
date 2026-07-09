local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local ContactImporter = require(AddFriendsStateParent.ContactImporter)
local Rodux = require(AddFriendsStateParent.Rodux)

return function() -- line: 7
	-- upvalues: Rodux (copy), AddFriendsState (copy), ContactImporter (copy)
	return Rodux.combineReducers({
		NetworkStatus = require(AddFriendsState.Networking.myRoduxNetworking).installReducer(),
		Games = require(script.Parent.RoduxGames).installReducer(),
		Friends = require(script.Parent.RoduxFriends).installReducer(),
		Users = require(script.Parent.RoduxUsers).installReducer(),
		Analytics = require(script.Parent.RoduxAnalytics).installReducer(),
		Presence = require(script.Parent.RoduxPresence).installReducer(),
		ShowContactImporterParams = ContactImporter.ShowContactImporterParams,
		RequestsFromOriginSourceType = require(script.Parent.RequestsFromOriginSourceType),
		ContactImporterWarning = require(script.Parent.contactImporterWarning),
		IsUserFollowing = require(script.Parent.IsUserFollowing)
	})
end
