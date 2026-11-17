local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
require(DataHydration.Moments.MomentsStoreTypes)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local decodeMomentsUsage = require(DataHydration.Moments.Util.decodeMomentsUsage)

local function getMomentsUsage(network)
	local url, headers = constructApiUrl("content-captures-api/v2/moments/usage")

	return HttpClient.fetch({
		method = "GET",
		url = url,
		headers = headers,
		analyticsKey = "moments.get-moments-usage",
		network = network,
		decode = decodeMomentsUsage
	})
end

return getMomentsUsage
