local SOCIAL_PROOF_URL = require("@game/CorePackages/Workspace/Packages/_Index/SocialProofNetworking/SocialProofNetworking/SOCIAL_PROOF_URL")
require("@game/CorePackages/Workspace/Packages/_Index/SocialProofNetworking/SocialProofNetworking/types")

return function(p2)
	return p2.roduxNetworking.POST("GetConnectionsByEntityId", function(callback, data)
		return (callback(SOCIAL_PROOF_URL):path("social-proof-api"):path("v1"):path("social-proof"):path("entity"):path("connections"):body({
			entityId = data.entityId,
			entityType = data.entityType,
			connectionType = data.connectionType,
			cursor = data.cursor
		}))
	end)
end
