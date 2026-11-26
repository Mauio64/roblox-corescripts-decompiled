local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")
local decodeMomentsUsage = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/decodeMomentsUsage")

local function postMomentsUsageHeartbeat(p2)
	local v5, v6 = constructApiUrl("content-captures-api/v2/moments/usage/heartbeat")

	return HttpClient.fetch({
		method = "POST",
		url = v5,
		headers = v6,
		body = {},
		analyticsKey = "moments.post-moments-usage-heartbeat",
		network = p2,
		retry = false,
		decode = decodeMomentsUsage
	})
end

return postMomentsUsageHeartbeat
