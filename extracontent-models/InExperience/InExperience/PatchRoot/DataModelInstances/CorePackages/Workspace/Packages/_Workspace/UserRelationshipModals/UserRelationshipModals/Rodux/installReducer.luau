local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local parent = UserRelationshipModals.Parent

local Rodux = require(parent.Rodux)
local myRoduxNetworking = require(UserRelationshipModals.Networking.myRoduxNetworking)

return function()
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
