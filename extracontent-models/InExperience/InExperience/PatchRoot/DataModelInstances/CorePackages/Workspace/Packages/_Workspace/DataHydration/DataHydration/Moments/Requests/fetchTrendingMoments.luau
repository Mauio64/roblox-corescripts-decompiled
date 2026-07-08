local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpService = game:GetService("HttpService")
local Http = require(DataHydrationParent.Http)
local HttpClient = require(DataHydrationParent.HttpClient)

require(DataHydration.Moments.MomentsStoreTypes)

local FFlagArgusUseMockFeedItems = require(DataHydration.Moments.FFlagArgusUseMockFeedItems)
local MockTrendingMoments = require(DataHydration.Moments.MockTrendingMoments)
local convertApiMomentsToMomentItems = require(DataHydration.Moments.Util.convertApiMomentsToMomentItems)
local extractReactionsByMomentId = require(DataHydration.Moments.Util.extractReactionsByMomentId)
local extractShareInfoByMomentId = require(DataHydration.Moments.Util.extractShareInfoByMomentId)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local v12 = HttpClient.createMockNetwork({
	fallback = function() -- line: 25
		-- upvalues: HttpService (copy)
		return {
			statusCode = 200,
			responseBody = HttpService:JSONEncode({})
		}
	end
})

local function fetchTrendingMoments(s1: string, s2: string?, p1, t1: {[any]: any}?) -- line: 32
	-- upvalues: constructApiUrl (copy), Http (copy), HttpService (copy), FFlagArgusUseMockFeedItems (copy), HttpClient (copy), v12 (copy), MockTrendingMoments (copy), convertApiMomentsToMomentItems (copy), extractReactionsByMomentId (copy), extractShareInfoByMomentId (copy)
	local v18, v19 = constructApiUrl("content-captures-api/v2/moments/get-moment-recommendations")
	local v20 = `{ v18 }?{ Http.Url:makeQueryString({
		momentsSessionId = s1,
		paginationContext = s2,
		signals = if not t1 then nil else HttpService:JSONEncode(t1)
	}) }`
	local v21 = FFlagArgusUseMockFeedItems()

	return HttpClient.fetch({
		method = "GET",
		analyticsKey = "moments.get-moment-recommendations",
		url = v20,
		headers = v19,
		network = if not v21 then p1 else v12,
		decode = function(p2) -- line: 53
			-- upvalues: v21 (copy), MockTrendingMoments (copy), convertApiMomentsToMomentItems (copy), s2 (copy), extractReactionsByMomentId (copy), extractShareInfoByMomentId (copy)
			if v21 then
				return {
					nextCursor = nil,
					moments = MockTrendingMoments,
					reactionsByMomentId = {},
					shareInfoByMomentId = {}
				}
			end

			return {
				moments = convertApiMomentsToMomentItems(p2.items),
				nextCursor = p2.paginationContext or s2,
				reactionsByMomentId = extractReactionsByMomentId(p2.items),
				shareInfoByMomentId = extractShareInfoByMomentId(p2.items)
			}
		end
	})
end

return fetchTrendingMoments
