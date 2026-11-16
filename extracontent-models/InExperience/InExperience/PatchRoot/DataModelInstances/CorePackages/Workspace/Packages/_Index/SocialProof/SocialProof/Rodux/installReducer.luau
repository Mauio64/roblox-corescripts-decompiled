local SocialProof = script:FindFirstAncestor("SocialProof")
local parent = SocialProof.Parent

local Rodux = require(parent.Rodux)
local myRoduxNetworking = require(SocialProof.Networking.myRoduxNetworking)
local ConnectionsByEntityId = require(SocialProof.Rodux.ConnectionsByEntityId)

return function()
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer(),
		ConnectionsByEntityId = ConnectionsByEntityId
	})
end
