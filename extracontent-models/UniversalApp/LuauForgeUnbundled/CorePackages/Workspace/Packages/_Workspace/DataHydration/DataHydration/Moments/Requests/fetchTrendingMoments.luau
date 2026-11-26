local HttpService = game:GetService("HttpService")

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local FFlagArgusUseMockFeedItems = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/FFlagArgusUseMockFeedItems")
local MockTrendingMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MockTrendingMoments")
local convertApiMomentsToMomentItems = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/convertApiMomentsToMomentItems")
local extractCommentsByFeedItemId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractCommentsByFeedItemId")
local extractReactionsByMomentId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractReactionsByMomentId")
local extractShareInfoByMomentId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractShareInfoByMomentId")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")

local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local mockNetwork = HttpClient.createMockNetwork({
	fallback = function()
		return { statusCode = 200, responseBody = HttpService:JSONEncode({}) }
	end
})

local function fetchTrendingMoments(p2, p3, network, p4)
	local v5, v6 = constructApiUrl("content-captures-api/v2/moments/get-moment-recommendations")
	local url = Http.Url
	local v7 = { momentsSessionId = p2, paginationContext = p3, signals = 0 }

	local v8 = if p4 then HttpService:JSONEncode(p4) else nil
	v7.signals = v8
	local formatted = `{v5}?{url:makeQueryString(v7)}`
	local v9 = FFlagArgusUseMockFeedItems()

	local fetch = HttpClient.fetch

	if v9 then
		network = mockNetwork
	end

	return fetch({
		method = "GET",
		url = formatted,
		headers = v6,
		analyticsKey = "moments.get-moment-recommendations",
		network = network,
		decode = function(p5)
			if v9 then
				return {
					moments = MockTrendingMoments,
					nextCursor = nil,
					reactionsByMomentId = {},
					shareInfoByMomentId = {},
					commentsByFeedItemId = fFlagMomentsComments and {} or nil
				}
			end

			local v11 = {
				moments = convertApiMomentsToMomentItems(p5.items),
				nextCursor = p5.paginationContext or p3,
				reactionsByMomentId = extractReactionsByMomentId(p5.items),
				shareInfoByMomentId = extractShareInfoByMomentId(p5.items),
				commentsByFeedItemId = 0
			}
			local v12 = if fFlagMomentsComments then extractCommentsByFeedItemId(p5.items) else nil
			v11.commentsByFeedItemId = v12
			return v11
		end
	})
end

return fetchTrendingMoments
