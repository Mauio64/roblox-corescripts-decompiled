local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local Rodux = require(UserListParent.Rodux)
local myRoduxNetworking = require(UserList.Networking.myRoduxNetworking)
local Presence = require(UserList.Rodux.Presence)
local FFlagUserListPresenceStoreMigration = require(UserList.Flags.FFlagUserListPresenceStoreMigration)

return function() -- line: 9
	-- upvalues: Rodux (copy), FFlagUserListPresenceStoreMigration (copy), Presence (copy), myRoduxNetworking (copy)
	return Rodux.combineReducers({
		Presence = if FFlagUserListPresenceStoreMigration then nil else Presence,
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
