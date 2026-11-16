local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local Rodux = require(parent.Rodux)
local Presence = require(UserSearch.Rodux.Presence)
local Friends = require(UserSearch.Rodux.Friends)
local myRoduxNetworking = require(UserSearch.Networking.myRoduxNetworking)

local FFlagUserSearchPresenceStoreMigration = require(UserSearch.Flags.FFlagUserSearchPresenceStoreMigration)

return function()
	local combineReducers = Rodux.combineReducers
	local presence

	if not FFlagUserSearchPresenceStoreMigration then
		presence = Presence
	end

	return combineReducers({
		Presence = presence,
		NetworkStatus = myRoduxNetworking.installReducer(),
		Friends = Friends
	})
end
