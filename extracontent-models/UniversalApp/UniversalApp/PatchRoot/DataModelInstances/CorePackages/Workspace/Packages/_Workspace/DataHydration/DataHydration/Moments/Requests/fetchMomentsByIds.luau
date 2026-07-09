local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Http = require(DataHydrationParent.Http)
local HttpClient = require(DataHydrationParent.HttpClient)

require(DataHydration.Moments.MomentsStoreTypes)

local convertApiMomentsToMomentItems = require(DataHydration.Moments.Util.convertApiMomentsToMomentItems)
local extractReactionsByMomentId = require(DataHydration.Moments.Util.extractReactionsByMomentId)
local extractShareInfoByMomentId = require(DataHydration.Moments.Util.extractShareInfoByMomentId)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)

local function fetchMomentsByIds(t1: {[any]: any}, p1) -- line: 25
	-- upvalues: constructApiUrl (copy), Http (copy), HttpClient (copy), convertApiMomentsToMomentItems (copy), extractReactionsByMomentId (copy), extractShareInfoByMomentId (copy)
	local v12, v13 = constructApiUrl("content-captures-api/v2/moments/get-moments")
	local v14 = `{ v12 }?{ Http.Url:makeQueryString({
		Ids = table.concat(t1, ",")
	}) }`

	return HttpClient.fetch({
		method = "GET",
		analyticsKey = "moments.get-moments",
		url = v14,
		headers = v13,
		network = p1,
		decode = function(p2) -- line: 38
			-- upvalues: convertApiMomentsToMomentItems (copy), extractReactionsByMomentId (copy), extractShareInfoByMomentId (copy)
			return {
				moments = convertApiMomentsToMomentItems(p2.items),
				reactionsByMomentId = extractReactionsByMomentId(p2.items),
				shareInfoByMomentId = extractShareInfoByMomentId(p2.items)
			}
		end
	})
end

return fetchMomentsByIds
