local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Http = require(DataHydrationParent.Http)
local HttpClient = require(DataHydrationParent.HttpClient)

require(DataHydration.Moments.MomentsStoreTypes)

local convertApiMomentsToMomentItems = require(DataHydration.Moments.Util.convertApiMomentsToMomentItems)
local extractReactionsByMomentId = require(DataHydration.Moments.Util.extractReactionsByMomentId)
local extractShareInfoByMomentId = require(DataHydration.Moments.Util.extractShareInfoByMomentId)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local FFlagProfileMomentsOrderingAndReactions = require(DataHydrationParent.SharedFlags).FFlagProfileMomentsOrderingAndReactions

local function fetchUserMoments(n1: number, s1: string?, p1) -- line: 22
	-- upvalues: constructApiUrl (copy), Http (copy), HttpClient (copy), convertApiMomentsToMomentItems (copy), FFlagProfileMomentsOrderingAndReactions (copy), extractReactionsByMomentId (copy), extractShareInfoByMomentId (copy)
	local v14, v15 = constructApiUrl("content-captures-api/v2/moments/get-users-moments")
	local v16 = `{ v14 }?{ Http.Url:makeQueryString({
		count = 18,
		targetUserId = n1,
		paginationContext = s1
	}) }`

	return HttpClient.fetch({
		method = "GET",
		analyticsKey = "moments.get-users-moments",
		url = v16,
		headers = v15,
		network = p1,
		decode = function(p2) -- line: 41
			-- upvalues: convertApiMomentsToMomentItems (copy), s1 (copy), FFlagProfileMomentsOrderingAndReactions (copy), extractReactionsByMomentId (copy), extractShareInfoByMomentId (copy)
			local items = p2.items
			local v19 = items ~= nil and #items >= 18

			return {
				moments = convertApiMomentsToMomentItems(items),
				nextCursor = if not v19 then nil else p2.paginationContext or s1,
				reactionsByMomentId = if not FFlagProfileMomentsOrderingAndReactions then nil else extractReactionsByMomentId(items),
				shareInfoByMomentId = if not FFlagProfileMomentsOrderingAndReactions then nil else extractShareInfoByMomentId(items)
			}
		end
	})
end

return fetchUserMoments
