local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)
local SharedFlags = require(parent.SharedFlags)
require(DataHydration.Moments.MomentsStoreTypes)
local convertApiMomentsToMomentItems = require(DataHydration.Moments.Util.convertApiMomentsToMomentItems)
local extractCommentsByFeedItemId = require(DataHydration.Moments.Util.extractCommentsByFeedItemId)
local extractReactionsByMomentId = require(DataHydration.Moments.Util.extractReactionsByMomentId)
local extractShareInfoByMomentId = require(DataHydration.Moments.Util.extractShareInfoByMomentId)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)

local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsResolvePublishedPostFeedItem = SharedFlags.FFlagMomentsResolvePublishedPostFeedItem

local function collectExcludedMomentIds(p)
	local clone = table.clone(p.moderatedMomentIds or {})

	for _, v in p.failedMomentIds or {} do
		table.insert(clone, v)
	end

	return clone
end

local function fetchUserMoments(targetUserId: number, paginationContext: string?, network)
	local v, headers = constructApiUrl("content-captures-api/v2/moments/get-users-moments")
	local formatted = `{v}?{Http.Url:makeQueryString({ targetUserId = targetUserId, count = 18, paginationContext = paginationContext })}`

	return HttpClient.fetch({
		method = "GET",
		url = formatted,
		headers = headers,
		analyticsKey = "moments.get-users-moments",
		network = network,
		decode = function(p)
			local items = p.items
			local v2

			if items == nil then
				v2 = false
			else
				v2 = #items >= 18
			end

			local v3 = {
				moments = convertApiMomentsToMomentItems(items),
				nextCursor = 0,
				reactionsByMomentId = 0,
				shareInfoByMomentId = 0,
				commentsByFeedItemId = 0,
				excludedMomentIds = 0
			}
			local nextCursor

			if v2 then
				nextCursor = p.paginationContext or paginationContext
			end

			v3.nextCursor = nextCursor
			v3.reactionsByMomentId = extractReactionsByMomentId(items)
			v3.shareInfoByMomentId = extractShareInfoByMomentId(items)
			local commentsByFeedItemId

			if FFlagMomentsComments then
				commentsByFeedItemId = extractCommentsByFeedItemId(items)
			end

			v3.commentsByFeedItemId = commentsByFeedItemId
			local excludedMomentIds

			if FFlagMomentsResolvePublishedPostFeedItem then
				excludedMomentIds = collectExcludedMomentIds(p)
			end

			v3.excludedMomentIds = excludedMomentIds
			return v3
		end
	})
end

return fetchUserMoments
