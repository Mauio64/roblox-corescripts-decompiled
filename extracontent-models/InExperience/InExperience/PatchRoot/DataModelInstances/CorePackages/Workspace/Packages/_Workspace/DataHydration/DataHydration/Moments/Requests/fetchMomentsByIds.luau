local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)
local MomentsTypes = require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)
require(DataHydration.Moments.MomentsStoreTypes)
local convertApiMomentsToMomentItems = require(DataHydration.Moments.Util.convertApiMomentsToMomentItems)
local extractCommentsByFeedItemId = require(DataHydration.Moments.Util.extractCommentsByFeedItemId)
local extractReactionsByMomentId = require(DataHydration.Moments.Util.extractReactionsByMomentId)
local extractShareInfoByMomentId = require(DataHydration.Moments.Util.extractShareInfoByMomentId)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)

local defineFastFlag = game:DefineFastFlag("MomentsFixBatchedGetMomentsQueryParams", false)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local MomentGetIdType = MomentsTypes.Enums.MomentGetIdType
local ShareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function fetchMomentsByIds(ids, network, p: string?)
	local v, headers = constructApiUrl("content-captures-api/v2/moments/get-moments")
	local v2 = { Ids = table.concat(ids, ",") }

	if defineFastFlag then
		v2.Ids = ids
	end

	local v3

	if p == ShareLinkTargetIdType.FeedItemId then
		v3 = MomentGetIdType.FeedItemId
	else
		v3 = MomentGetIdType.MomentId
	end

	v2.type = v3

	local formatted = `{v}?{Http.Url:makeQueryString(v2)}`

	return HttpClient.fetch({
		method = "GET",
		url = formatted,
		headers = headers,
		analyticsKey = "moments.get-moments",
		network = network,
		decode = function(p2)
			local v4 = {
				moments = convertApiMomentsToMomentItems(p2.items),
				reactionsByMomentId = extractReactionsByMomentId(p2.items),
				shareInfoByMomentId = extractShareInfoByMomentId(p2.items),
				commentsByFeedItemId = 0
			}
			local commentsByFeedItemId

			if FFlagMomentsComments then
				commentsByFeedItemId = extractCommentsByFeedItemId(p2.items)
			end

			v4.commentsByFeedItemId = commentsByFeedItemId
			return v4
		end
	})
end

return fetchMomentsByIds
