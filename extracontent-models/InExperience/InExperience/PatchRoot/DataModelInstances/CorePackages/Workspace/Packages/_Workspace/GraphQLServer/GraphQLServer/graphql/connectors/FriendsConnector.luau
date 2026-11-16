local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local parent = GraphQLServer.Parent

local UrlBuilder = require(GraphQLServer.Parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(GraphQLServer.Parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
require(GraphQLServer.Parent.LuauPolyfill)
local Promise = require(GraphQLServer.Parent.Promise)
local GraphQL = require(GraphQLServer.Parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
require(GraphQLServer.graphql.generatedTypes)

local Fetch = require(GraphQLServer.Parent.Fetch)
local fetch = Fetch.fetch
local Response = Fetch.Response

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local reportPromiseLoadingTimeWrapper = SocialLuaAnalytics.Analytics.Timing.reportPromiseLoadingTimeWrapper
local createDiagMetricString = SocialLuaAnalytics.Analytics.Formatters.createDiagMetricString
local Diag = SocialLuaAnalytics.Analytics.DefaultAnalyticsService.Diag
local getPlatformSuffix = SocialLuaAnalytics.Analytics.FireEvent.getPlatformSuffix
local PlatformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity

local HttpService = game:GetService("HttpService")

local LoggingProtocol = require(parent.LoggingProtocol)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

local v = urlBuilder.new({
	base = UrlBase.FRIENDS,
	path = "users/{userId}/friends/find",
	query = {
		{ name = "limit", value = "{limit}", optional = false },
		{ name = "userSort", value = "{userSort}", optional = true },
		{ name = "cursor", value = "{cursor}", optional = true }
	}
})

local v2 = urlBuilder.new({
	base = UrlBase.FRIENDS,
	path = "users/{userId}/friends/online",
	query = {
		{ name = "userSort", value = "{userSort}", optional = true }
	}
})

local emitter = SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = game:DefineFastInt("FriendsCommonAnalyticsThrottlingThousandths", 10000),
		links = "https://docs.google.com/document/d/1uRCdl8pEuiW9wDiOTL39JPMGLhgxtpvVgiXovE8Xof4"
	},
	getSharedInfo = function()
		return {}
	end
})

local telemetry = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeFindFriendsResponse",
	description = "User making a request to /FindFriends",
	lastUpdated = { 2026, 3, 18 },
	backendsList = {
		{
			type = SupportedTelemetryBackends.EventIngest,
			format = function(p, _)
				return p
			end
		}
	}
})

local telemetry2 = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeGetAllOnlineFriendsResponse",
	description = "User making a request to /GetAllOnlineFriends",
	lastUpdated = { 2026, 3, 18 },
	backendsList = {
		{
			type = SupportedTelemetryBackends.EventIngest,
			format = function(p, _)
				return p
			end
		}
	}
})

local function fn() -- 2 equivalent calls inferred from this helper
	return string.format("friends-sort-%s", HttpService:GenerateGUID(false))
end

local function fn2(requestId, ids, telemetry3, sortType) -- 2 equivalent calls inferred from this helper
	local v3 = { requestId = requestId, friendIds = table.concat(ids, ","), sortType = sortType }

	emitter.emit(telemetry3, v3)
end

local function getAllFriendsByUserId(data, p)
	local v3 = p or fetch
	return Promise.new(function(callback, callback2)
		local v4 = v({
			userId = data.userId,
			limit = data.pageLimit or 50,
			cursor = data.pageCursor,
			userSort = data.sort
		})
		local friendssort = fn() -- inferred equivalent call
		local expect = v3(v4, {
			method = "GET",
			headers = { ["friends-sort"] = friendssort }
		}):catch(function(p2)
			local v5 = Response.error()
			v5.statusText = p2.message
			return v5
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(expect.statusText, nil, nil, nil, nil, {
				extensions = { status = expect.status, statusText = expect.statusText }
			}))

			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if not expect2 then
			callback2(GraphQLError.new("Failed to decode HTTP response as JSON for friends API"))
			return
		end

		callback(expect2)

		if friendssort == nil then
			return
		end

		local ids = {}

		for _, pageItem in pairs(expect2.PageItems) do
			table.insert(ids, pageItem.id)
		end

		fn2(friendssort, ids, telemetry, "FriendScore") -- inferred equivalent call
	end)
end

local function getOnlineFriendsByUserId(p, p2)
	local v3 = p2 or fetch
	return Promise.new(function(callback, callback2)
		local v4 = v2({ userId = p.userId, userSort = p.sort })
		local friendssort = fn() -- inferred equivalent call
		local expect = v3(v4, {
			method = "GET",
			headers = { ["friends-sort"] = friendssort }
		}):catch(function(p3)
			local v5 = Response.error()
			v5.statusText = p3.message
			return v5
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(expect.statusText, nil, nil, nil, nil, {
				extensions = { status = expect.status, statusText = expect.statusText }
			}))

			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if not expect2 then
			callback2(GraphQLError.new("Failed to decode HTTP response as JSON for friends API"))
			return
		end

		local data = expect2.data or {}
		callback(data)

		if friendssort == nil then
			return
		end

		local ids = {}

		for _, v5 in data do
			table.insert(ids, v5.id)
		end

		fn2(friendssort, ids, telemetry2, "Carousel") -- inferred equivalent call
	end)
end

local function fireLoadingEvent(p, p2, p3)
	Diag:reportStats(createDiagMetricString(p, p2) .. getPlatformSuffix(PlatformSpecificity.BucketsOnly), p3)
end

return {
	getAllFriendsByUserId = reportPromiseLoadingTimeWrapper(getAllFriendsByUserId, function(p)
		return {
			fetch = "friends_find",
			nextPage = p.pageCursor and p.pageCursor ~= ""
		}
	end, { fireEvent = fireLoadingEvent }),
	getOnlineFriendsByUserId = reportPromiseLoadingTimeWrapper(getOnlineFriendsByUserId, function(_)
		return { fetch = "friends_online" }
	end, { fireEvent = fireLoadingEvent })
}
