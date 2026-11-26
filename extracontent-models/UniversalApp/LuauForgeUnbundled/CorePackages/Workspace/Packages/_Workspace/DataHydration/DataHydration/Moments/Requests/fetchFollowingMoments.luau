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

local function fetchFollowingMoments(p2, p3)
	local v5, v6 = constructApiUrl("content-captures-api/v2/moments/get-following-moments")
	local queryString = Http.Url:makeQueryString({ paginationContext = p2 })

	if queryString ~= "" then
		v5 = `{v5}?{queryString}`
	end

	return HttpClient.fetch({
		method = "GET",
		url = v5,
		headers = v6,
		analyticsKey = "moments.get-following-moments",
		network = p3,
		decode = function(p4)
			local paginationContext = p4.paginationContext
			local v7 = {
				moments = convertApiMomentsToMomentItems(p4.items),
				nextCursor = 0,
				reactionsByMomentId = 0,
				shareInfoByMomentId = 0,
				commentsByFeedItemId = 0
			}

			if paginationContext == nil or paginationContext == "" then
				paginationContext = nil
			end

			v7.nextCursor = paginationContext
			v7.reactionsByMomentId = extractReactionsByMomentId(p4.items)
			v7.shareInfoByMomentId = extractShareInfoByMomentId(p4.items)
			local v8 = if fFlagMomentsComments then extractCommentsByFeedItemId(p4.items) else nil
			v7.commentsByFeedItemId = v8
			return v7
		end
	})
end

return fetchFollowingMoments
