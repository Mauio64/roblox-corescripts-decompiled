local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpService = game:GetService("HttpService")

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)
local SharedFlags = require(parent.SharedFlags)
require(DataHydration.Moments.MomentsStoreTypes)
local FFlagArgusUseMockFeedItems = require(DataHydration.Moments.FFlagArgusUseMockFeedItems)
local MockTrendingMoments = require(DataHydration.Moments.MockTrendingMoments)
local convertApiMomentsToMomentItems = require(DataHydration.Moments.Util.convertApiMomentsToMomentItems)
local extractCommentsByFeedItemId = require(DataHydration.Moments.Util.extractCommentsByFeedItemId)
local extractReactionsByMomentId = require(DataHydration.Moments.Util.extractReactionsByMomentId)
local extractShareInfoByMomentId = require(DataHydration.Moments.Util.extractShareInfoByMomentId)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)

local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local mockNetwork = HttpClient.createMockNetwork({
	fallback = function()
		return { statusCode = 200, responseBody = HttpService:JSONEncode({}) }
	end
})

local function fetchTrendingMoments(momentsSessionId: string, paginationContext: string?, network, p)
	local v, headers = constructApiUrl("content-captures-api/v2/moments/get-moment-recommendations")
	local url = Http.Url
	local v2 = {
		momentsSessionId = momentsSessionId,
		paginationContext = paginationContext,
		signals = 0
	}
	local signals

	if p then
		signals = HttpService:JSONEncode(p)
	end

	v2.signals = signals
	local formatted = `{v}?{url:makeQueryString(v2)}`
	local fFlagArgusUseMockFeedItems = FFlagArgusUseMockFeedItems()

	local fetch = HttpClient.fetch

	if fFlagArgusUseMockFeedItems then
		network = mockNetwork
	end

	return fetch({
		method = "GET",
		url = formatted,
		headers = headers,
		analyticsKey = "moments.get-moment-recommendations",
		network = network,
		decode = function(p2)
			if fFlagArgusUseMockFeedItems then
				return {
					moments = MockTrendingMoments,
					nextCursor = nil,
					reactionsByMomentId = {},
					shareInfoByMomentId = {},
					commentsByFeedItemId = FFlagMomentsComments and {} or nil
				}
			end

			local v3 = {
				moments = convertApiMomentsToMomentItems(p2.items),
				nextCursor = p2.paginationContext or paginationContext,
				reactionsByMomentId = extractReactionsByMomentId(p2.items),
				shareInfoByMomentId = extractShareInfoByMomentId(p2.items),
				commentsByFeedItemId = 0
			}
			local commentsByFeedItemId

			if FFlagMomentsComments then
				commentsByFeedItemId = extractCommentsByFeedItemId(p2.items)
			end

			v3.commentsByFeedItemId = commentsByFeedItemId
			return v3
		end
	})
end

return fetchTrendingMoments
