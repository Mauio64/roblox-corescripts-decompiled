local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)

require(DataHydrationParent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)

local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local decodeEmojiSets = require(DataHydration.Moments.Util.decodeEmojiSets)

local function getEmojiSets(p1) -- line: 16
	-- upvalues: constructApiUrl (copy), HttpClient (copy), decodeEmojiSets (copy)
	local v8, v9 = constructApiUrl("emoji-api/v1/get-emoji-sets?product=Moments")

	return HttpClient.fetch({
		method = "GET",
		analyticsKey = "moments.get-emoji-sets",
		url = v8,
		headers = v9,
		network = p1,
		decode = function(p2) -- line: 25
			-- upvalues: decodeEmojiSets (copy)
			return decodeEmojiSets.decodeGetEmojiSetsResponse(p2)
		end
	})
end

return getEmojiSets
