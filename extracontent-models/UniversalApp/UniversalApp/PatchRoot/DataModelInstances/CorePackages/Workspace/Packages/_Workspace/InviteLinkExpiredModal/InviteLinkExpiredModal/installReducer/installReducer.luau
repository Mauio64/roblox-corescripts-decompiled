local InviteLinkExpiredModal = script:FindFirstAncestor("InviteLinkExpiredModal")
local dependencies = require(InviteLinkExpiredModal.dependencies)
local Rodux = dependencies.Rodux
local RoduxGames = dependencies.RoduxGames
local RoduxNetworking = dependencies.RoduxNetworking

return function() -- line: 8
	-- upvalues: Rodux (copy), RoduxGames (copy), RoduxNetworking (copy)
	return Rodux.combineReducers({
		Games = RoduxGames.installReducer(),
		NetworkStatus = RoduxNetworking.installReducer()
	})
end
