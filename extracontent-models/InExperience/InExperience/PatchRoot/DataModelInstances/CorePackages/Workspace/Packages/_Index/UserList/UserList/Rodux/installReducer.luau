local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local Rodux = require(UserListParent.Rodux)
local myRoduxNetworking = require(UserList.Networking.myRoduxNetworking)
local Presence = require(UserList.Rodux.Presence)

return function() -- line: 8
	-- upvalues: Rodux (copy), Presence (copy), myRoduxNetworking (copy)
	return Rodux.combineReducers({
		Presence = Presence,
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
