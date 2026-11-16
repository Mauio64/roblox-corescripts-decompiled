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

local function fetchFollowingMoments(paginationContext2: string?, network)
	local url, headers = constructApiUrl("content-captures-api/v2/moments/get-following-moments")
	local queryString = Http.Url:makeQueryString({ paginationContext = paginationContext2 })

	if queryString ~= "" then
		url = `{url}?{queryString}`
	end

	return HttpClient.fetch({
		method = "GET",
		url = url,
		headers = headers,
		analyticsKey = "moments.get-following-moments",
		network = network,
		decode = function(p)
			local paginationContext = p.paginationContext
			local v = {
				moments = convertApiMomentsToMomentItems(p.items),
				nextCursor = 0,
				reactionsByMomentId = 0,
				shareInfoByMomentId = 0,
				commentsByFeedItemId = 0
			}

			if paginationContext == nil or paginationContext == "" then
				paginationContext = nil
			end

			v.nextCursor = paginationContext
			v.reactionsByMomentId = extractReactionsByMomentId(p.items)
			v.shareInfoByMomentId = extractShareInfoByMomentId(p.items)
			local commentsByFeedItemId

			if FFlagMomentsComments then
				commentsByFeedItemId = extractCommentsByFeedItemId(p.items)
			end

			v.commentsByFeedItemId = commentsByFeedItemId
			return v
		end
	})
end

return fetchFollowingMoments
