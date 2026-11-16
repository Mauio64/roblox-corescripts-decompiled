local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")

local function reactToFeedItemV2(p2, p3)
	local v5, v6 = constructApiUrl("content-captures-api/v2/moments/react-to-feed-item-v2")

	return HttpClient.fetch({
		method = "POST",
		url = v5,
		headers = v6,
		body = p2,
		analyticsKey = "moments.react-to-feed-item-v2",
		network = p3,
		decode = function(options)
			return options or {}
		end
	})
end

return reactToFeedItemV2
