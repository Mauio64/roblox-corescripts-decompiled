local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local convertApiMomentsToMomentItems = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/convertApiMomentsToMomentItems")
local extractCommentsByFeedItemId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractCommentsByFeedItemId")
local extractReactionsByMomentId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractReactionsByMomentId")
local extractShareInfoByMomentId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractShareInfoByMomentId")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")

local defineFastFlag = game:DefineFastFlag("MomentsFixBatchedGetMomentsQueryParams", false)
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local momentGetIdType = MomentsTypes.Enums.MomentGetIdType
local shareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function fetchMomentsByIds(ids, p2, p3)
	local v5, v6 = constructApiUrl("content-captures-api/v2/moments/get-moments")
	local v7 = { Ids = table.concat(ids, ",") }

	if defineFastFlag then
		v7.Ids = ids
	end

	local v8 = if p3 == shareLinkTargetIdType.FeedItemId then momentGetIdType.FeedItemId else momentGetIdType.MomentId
	v7.type = v8

	local formatted = `{v5}?{module.Url:makeQueryString(v7)}`

	return HttpClient.fetch({
		method = "GET",
		url = formatted,
		headers = v6,
		analyticsKey = "moments.get-moments",
		network = p2,
		decode = function(p4)
			local v9 = {
				moments = convertApiMomentsToMomentItems(p4.items),
				reactionsByMomentId = extractReactionsByMomentId(p4.items),
				shareInfoByMomentId = extractShareInfoByMomentId(p4.items),
				commentsByFeedItemId = 0
			}
			local v10 = if fFlagMomentsComments then extractCommentsByFeedItemId(p4.items) else nil
			v9.commentsByFeedItemId = v10
			return v9
		end
	})
end

return fetchMomentsByIds
