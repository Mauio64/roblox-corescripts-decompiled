local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
require(DataHydration.Moments.MomentsStoreTypes)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local decodeMomentsUsage = require(DataHydration.Moments.Util.decodeMomentsUsage)

local function postMomentsUsageHeartbeat(network)
	local url, headers = constructApiUrl("content-captures-api/v2/moments/usage/heartbeat")

	return HttpClient.fetch({
		method = "POST",
		url = url,
		headers = headers,
		body = {},
		analyticsKey = "moments.post-moments-usage-heartbeat",
		network = network,
		retry = false,
		decode = decodeMomentsUsage
	})
end

return postMomentsUsageHeartbeat
