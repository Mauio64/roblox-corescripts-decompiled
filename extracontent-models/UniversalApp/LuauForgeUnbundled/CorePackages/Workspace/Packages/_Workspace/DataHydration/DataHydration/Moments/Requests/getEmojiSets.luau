local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")
local decodeEmojiSets = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/decodeEmojiSets")

local function getEmojiSets(p2)
	local v5, v6 = constructApiUrl("emoji-api/v1/get-emoji-sets?product=Moments")

	return HttpClient.fetch({
		method = "GET",
		url = v5,
		headers = v6,
		analyticsKey = "moments.get-emoji-sets",
		network = p2,
		decode = function(p3)
			return decodeEmojiSets.decodeGetEmojiSetsResponse(p3)
		end
	})
end

return getEmojiSets
