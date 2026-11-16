local createGetConnectionsByEntityId = require("@game/CorePackages/Workspace/Packages/_Index/SocialProofNetworking/SocialProofNetworking/networkRequests/createGetConnectionsByEntityId")

local function createRequestThunks(p2)
	return { GetConnectionsByEntityId = createGetConnectionsByEntityId(p2) }
end

return { config = createRequestThunks, Types = require("@game/CorePackages/Workspace/Packages/_Index/SocialProofNetworking/SocialProofNetworking/types") }
