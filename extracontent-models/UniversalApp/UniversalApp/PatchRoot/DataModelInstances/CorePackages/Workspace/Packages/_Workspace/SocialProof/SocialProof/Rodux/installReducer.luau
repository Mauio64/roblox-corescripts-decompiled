local SocialProof = script:FindFirstAncestor("SocialProof")
local SocialProofParent = SocialProof.Parent
local Rodux = require(SocialProofParent.Rodux)
local myRoduxNetworking = require(SocialProof.Networking.myRoduxNetworking)
local ConnectionsByEntityId = require(SocialProof.Rodux.ConnectionsByEntityId)

return function() -- line: 8
	-- upvalues: Rodux (copy), myRoduxNetworking (copy), ConnectionsByEntityId (copy)
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer(),
		ConnectionsByEntityId = ConnectionsByEntityId
	})
end
