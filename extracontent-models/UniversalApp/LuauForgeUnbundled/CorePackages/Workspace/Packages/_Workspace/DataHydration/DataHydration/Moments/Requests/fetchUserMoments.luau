local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local convertApiMomentsToMomentItems = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/convertApiMomentsToMomentItems")
local extractCommentsByFeedItemId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractCommentsByFeedItemId")
local extractReactionsByMomentId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractReactionsByMomentId")
local extractShareInfoByMomentId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractShareInfoByMomentId")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")

local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsResolvePublishedPostFeedItem = SharedFlags.FFlagMomentsResolvePublishedPostFeedItem

local function collectExcludedMomentIds(p2)
	local clone = table.clone(p2.moderatedMomentIds or {})

	for k, v5 in p2.failedMomentIds or {} do
		table.insert(clone, v5)
	end

	return clone
end

local function fetchUserMoments(p2, p3, p4)
	local v5, v6 = constructApiUrl("content-captures-api/v2/moments/get-users-moments")
	local formatted = `{v5}?{module.Url:makeQueryString({ targetUserId = p2, count = 18, paginationContext = p3 })}`

	return HttpClient.fetch({
		method = "GET",
		url = formatted,
		headers = v6,
		analyticsKey = "moments.get-users-moments",
		network = p4,
		decode = function(p5)
			local items = p5.items
			local v7 = not (items == nil) and #items >= 18
			local v8 = {
				moments = convertApiMomentsToMomentItems(items),
				nextCursor = 0,
				reactionsByMomentId = 0,
				shareInfoByMomentId = 0,
				commentsByFeedItemId = 0,
				excludedMomentIds = 0
			}
			local v9 = if v7 then p5.paginationContext or p3 else nil
			v8.nextCursor = v9
			v8.reactionsByMomentId = extractReactionsByMomentId(items)
			v8.shareInfoByMomentId = extractShareInfoByMomentId(items)
			local v10 = if fFlagMomentsComments then extractCommentsByFeedItemId(items) else nil
			v8.commentsByFeedItemId = v10

			local v11 = if fFlagMomentsResolvePublishedPostFeedItem then collectExcludedMomentIds(p5) else nil
			v8.excludedMomentIds = v11
			return v8
		end
	})
end

return fetchUserMoments
