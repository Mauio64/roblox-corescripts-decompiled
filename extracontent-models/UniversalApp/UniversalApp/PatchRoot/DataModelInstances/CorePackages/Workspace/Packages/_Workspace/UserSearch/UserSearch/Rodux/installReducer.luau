local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local Rodux = require(UserSearchParent.Rodux)
local Presence = require(UserSearch.Rodux.Presence)
local Friends = require(UserSearch.Rodux.Friends)
local myRoduxNetworking = require(UserSearch.Networking.myRoduxNetworking)

return function() -- line: 9
	-- upvalues: Rodux (copy), Presence (copy), myRoduxNetworking (copy), Friends (copy)
	return Rodux.combineReducers({
		Presence = Presence,
		NetworkStatus = myRoduxNetworking.installReducer(),
		Friends = Friends
	})
end
