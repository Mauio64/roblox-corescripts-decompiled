local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)

local function reactToFeedItemV2(body, network)
	local url, headers = constructApiUrl("content-captures-api/v2/moments/react-to-feed-item-v2")

	return HttpClient.fetch({
		method = "POST",
		url = url,
		headers = headers,
		body = body,
		analyticsKey = "moments.react-to-feed-item-v2",
		network = network,
		decode = function(options)
			return options or {}
		end
	})
end

return reactToFeedItemV2
