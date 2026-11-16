local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local Rodux = require(parent.Rodux)
local myRoduxNetworking = require(UserList.Networking.myRoduxNetworking)
local Presence = require(UserList.Rodux.Presence)
local FFlagUserListPresenceStoreMigration = require(UserList.Flags.FFlagUserListPresenceStoreMigration)

return function()
	local combineReducers = Rodux.combineReducers
	local presence

	if not FFlagUserListPresenceStoreMigration then
		presence = Presence
	end

	return combineReducers({
		Presence = presence,
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
