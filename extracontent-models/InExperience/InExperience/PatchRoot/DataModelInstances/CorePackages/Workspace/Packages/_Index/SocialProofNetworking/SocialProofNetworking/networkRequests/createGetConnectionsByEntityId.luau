local SocialProofNetworking = script:FindFirstAncestor("SocialProofNetworking")
local SOCIAL_PROOF_URL = require(SocialProofNetworking.SOCIAL_PROOF_URL)
require(SocialProofNetworking.types)

return function(p)
	return p.roduxNetworking.POST("GetConnectionsByEntityId", function(callback, data)
		return (callback(SOCIAL_PROOF_URL):path("social-proof-api"):path("v1"):path("social-proof"):path("entity"):path("connections"):body({
			entityId = data.entityId,
			entityType = data.entityType,
			connectionType = data.connectionType,
			cursor = data.cursor
		}))
	end)
end
