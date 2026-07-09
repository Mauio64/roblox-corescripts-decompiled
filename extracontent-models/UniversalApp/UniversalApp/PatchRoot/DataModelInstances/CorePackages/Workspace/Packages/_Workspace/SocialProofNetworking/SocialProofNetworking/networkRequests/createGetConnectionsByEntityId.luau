local SocialProofNetworking = script:FindFirstAncestor("SocialProofNetworking")
local SOCIAL_PROOF_URL = require(SocialProofNetworking.SOCIAL_PROOF_URL)

require(SocialProofNetworking.types)

return function(p1) -- line: 17
	-- upvalues: SOCIAL_PROOF_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "GetConnectionsByEntityId"
	}, function(p2, t1: {[any]: any}) -- line: 22
		-- upvalues: SOCIAL_PROOF_URL (copy)
		return (p2(SOCIAL_PROOF_URL):path("social-proof-api"):path("v1"):path("social-proof"):path("entity"):path("connections"):body({
			entityId = t1.entityId,
			entityType = t1.entityType,
			connectionType = t1.connectionType,
			cursor = t1.cursor
		}))
	end)
end
