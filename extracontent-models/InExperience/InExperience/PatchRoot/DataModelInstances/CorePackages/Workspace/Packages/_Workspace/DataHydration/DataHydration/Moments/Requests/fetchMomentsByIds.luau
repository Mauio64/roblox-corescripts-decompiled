local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Http = require(DataHydrationParent.Http)
local HttpClient = require(DataHydrationParent.HttpClient)
local MomentsTypes = require(DataHydrationParent.MomentsTypes)
local SharedFlags = require(DataHydrationParent.SharedFlags)

require(DataHydration.Moments.MomentsStoreTypes)

local convertApiMomentsToMomentItems = require(DataHydration.Moments.Util.convertApiMomentsToMomentItems)
local extractReactionsByMomentId = require(DataHydration.Moments.Util.extractReactionsByMomentId)
local extractShareInfoByMomentId = require(DataHydration.Moments.Util.extractShareInfoByMomentId)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis
local MomentGetIdType = MomentsTypes.Enums.MomentGetIdType
local ShareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function fetchMomentsByIds(t1: {[any]: any}, p1, s1: string?) -- line: 32
	-- upvalues: constructApiUrl (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), ShareLinkTargetIdType (copy), MomentGetIdType (copy), Http (copy), HttpClient (copy), convertApiMomentsToMomentItems (copy), extractReactionsByMomentId (copy), extractShareInfoByMomentId (copy)
	local v18, v19 = constructApiUrl("content-captures-api/v2/moments/get-moments")
	local t2 = {
		Ids = table.concat(t1, ",")
	}

	if FFlagMomentsPassFeedItemIdToBackendApis then
		t2.type = if s1 ~= ShareLinkTargetIdType.FeedItemId then MomentGetIdType.MomentId else MomentGetIdType.FeedItemId
	end

	local v21 = `{ v18 }?{ Http.Url:makeQueryString(t2) }`

	return HttpClient.fetch({
		method = "GET",
		analyticsKey = "moments.get-moments",
		url = v21,
		headers = v19,
		network = p1,
		decode = function(p2) -- line: 51
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
