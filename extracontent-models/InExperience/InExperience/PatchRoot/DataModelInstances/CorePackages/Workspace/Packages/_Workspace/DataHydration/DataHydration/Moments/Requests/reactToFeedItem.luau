local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)

require(DataHydrationParent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)

local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)

local function reactToFeedItem(p1, p2) -- line: 17
	-- upvalues: constructApiUrl (copy), HttpClient (copy)
	local v8, v9 = constructApiUrl("content-captures-api/v2/moments/react-to-feed-item")

	return HttpClient.fetch({
		method = "POST",
		analyticsKey = "moments.react-to-feed-item",
		url = v8,
		headers = v9,
		body = p1,
		network = p2,
		decode = function(p3) -- line: 30
			return p3 or {}
		end
	})
end

return reactToFeedItem
