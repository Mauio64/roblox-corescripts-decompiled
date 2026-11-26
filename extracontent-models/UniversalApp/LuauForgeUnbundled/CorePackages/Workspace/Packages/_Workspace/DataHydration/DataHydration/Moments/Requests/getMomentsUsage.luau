local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")
local decodeMomentsUsage = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/decodeMomentsUsage")

local function getMomentsUsage(p2)
	local v5, v6 = constructApiUrl("content-captures-api/v2/moments/usage")

	return HttpClient.fetch({
		method = "GET",
		url = v5,
		headers = v6,
		analyticsKey = "moments.get-moments-usage",
		network = p2,
		decode = decodeMomentsUsage
	})
end

return getMomentsUsage
