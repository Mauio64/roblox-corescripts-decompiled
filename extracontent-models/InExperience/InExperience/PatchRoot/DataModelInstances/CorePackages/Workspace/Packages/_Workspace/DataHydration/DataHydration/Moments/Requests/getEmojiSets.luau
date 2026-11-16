local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local decodeEmojiSets = require(DataHydration.Moments.Util.decodeEmojiSets)

local function getEmojiSets(network)
	local url, headers = constructApiUrl("emoji-api/v1/get-emoji-sets?product=Moments")

	return HttpClient.fetch({
		method = "GET",
		url = url,
		headers = headers,
		analyticsKey = "moments.get-emoji-sets",
		network = network,
		decode = function(p)
			return decodeEmojiSets.decodeGetEmojiSetsResponse(p)
		end
	})
end

return getEmojiSets
