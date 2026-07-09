local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local UserRelationshipModalsParent = UserRelationshipModals.Parent
local Rodux = require(UserRelationshipModalsParent.Rodux)
local myRoduxNetworking = require(UserRelationshipModals.Networking.myRoduxNetworking)

return function() -- line: 7
	-- upvalues: Rodux (copy), myRoduxNetworking (copy)
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
