local SocialTabState = script:FindFirstAncestor("SocialTabState")
local dependencies = require(SocialTabState.dependencies)
local Rodux = dependencies.Rodux
local RoduxNetworking = dependencies.RoduxNetworking
local ShowContactImporterParams = dependencies.ShowContactImporterParams

return function() -- line: 8
	-- upvalues: Rodux (copy), ShowContactImporterParams (copy), RoduxNetworking (copy)
	return Rodux.combineReducers({
		Users = require(script.Users),
		Friends = require(script.Friends),
		Presence = require(script.Presence),
		PremiumByUserId = require(script.PremiumByUserId),
		ShowContactImporterParams = ShowContactImporterParams,
		NetworkStatus = RoduxNetworking.installReducer(),
		UnreadConversationCount = require(script.UnreadConversationCount)
	})
end
