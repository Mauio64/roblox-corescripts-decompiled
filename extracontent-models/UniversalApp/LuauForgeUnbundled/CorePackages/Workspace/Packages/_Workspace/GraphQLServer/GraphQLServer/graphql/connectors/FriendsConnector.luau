local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBase
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch")
local fetch = Fetch.fetch
local response = Fetch.Response

local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/SocialLuaAnalytics")
local reportPromiseLoadingTimeWrapper = SocialLuaAnalytics.Analytics.Timing.reportPromiseLoadingTimeWrapper
local createDiagMetricString = SocialLuaAnalytics.Analytics.Formatters.createDiagMetricString
local diag = SocialLuaAnalytics.Analytics.DefaultAnalyticsService.Diag
local getPlatformSuffix = SocialLuaAnalytics.Analytics.FireEvent.getPlatformSuffix
local platformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity

local HttpService = game:GetService("HttpService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LoggingProtocol")
local supportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

local v5 = urlBuilder.new({
	base = urlBase.FRIENDS,
	path = "users/{userId}/friends/find",
	query = {
		{ name = "limit", value = "{limit}", optional = false },
		{ name = "userSort", value = "{userSort}", optional = true },
		{ name = "cursor", value = "{cursor}", optional = true }
	}
})

local v6 = urlBuilder.new({
	base = urlBase.FRIENDS,
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
			type = supportedTelemetryBackends.EventIngest,
			format = function(p2, p3)
				return p2
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
			type = supportedTelemetryBackends.EventIngest,
			format = function(p2, p3)
				return p2
			end
		}
	}
})

local function getAllFriendsByUserId(data, p2)
	local v7 = p2 or fetch
	return Promise.new(function(callback, callback2)
		local v8 = v5({
			userId = data.userId,
			limit = data.pageLimit or 50,
			cursor = data.pageCursor,
			userSort = data.sort
		})
		local v9 = string.format("friends-sort-%s", HttpService:GenerateGUID(false))

		local expect = v7(v8, {
			method = "GET",
			headers = { ["friends-sort"] = v9 }
		}):catch(function(p3)
			local v10 = response.error()
			v10.statusText = p3.message
			return v10
		end):expect()

		if not expect.ok then
			callback2(graphQLError.new(expect.statusText, nil, nil, nil, nil, {
				extensions = { status = expect.status, statusText = expect.statusText }
			}))

			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if not expect2 then
			callback2(graphQLError.new("Failed to decode HTTP response as JSON for friends API"))
			return
		end

		callback(expect2)

		if v9 == nil then
			return
		end

		local ids = {}

		for k, pageItem in pairs(expect2.PageItems) do
			table.insert(ids, pageItem.id)
		end

		local v11 = {
			requestId = v9,
			friendIds = table.concat(ids, ","),
			sortType = "FriendScore"
		}

		emitter.emit(telemetry, v11)
	end)
end

local function getOnlineFriendsByUserId(p2, p3)
	local v7 = p3 or fetch
	return Promise.new(function(callback, callback2)
		local v8 = v6({ userId = p2.userId, userSort = p2.sort })
		local v9 = string.format("friends-sort-%s", HttpService:GenerateGUID(false))

		local expect = v7(v8, {
			method = "GET",
			headers = { ["friends-sort"] = v9 }
		}):catch(function(p4)
			local v10 = response.error()
			v10.statusText = p4.message
			return v10
		end):expect()

		if not expect.ok then
			callback2(graphQLError.new(expect.statusText, nil, nil, nil, nil, {
				extensions = { status = expect.status, statusText = expect.statusText }
			}))

			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if not expect2 then
			callback2(graphQLError.new("Failed to decode HTTP response as JSON for friends API"))
			return
		end

		local data = expect2.data or {}
		callback(data)

		if v9 == nil then
			return
		end

		local ids = {}

		for k, v10 in data do
			table.insert(ids, v10.id)
		end

		local v11 = {
			requestId = v9,
			friendIds = table.concat(ids, ","),
			sortType = "Carousel"
		}

		emitter.emit(telemetry2, v11)
	end)
end

local function fireLoadingEvent(p2, p3, p4)
	diag:reportStats(
		createDiagMetricString(p2, p3) .. getPlatformSuffix(platformSpecificity.BucketsOnly),
		p4
	)
end

return {
	getAllFriendsByUserId = reportPromiseLoadingTimeWrapper(getAllFriendsByUserId, function(p2)
		return {
			fetch = "friends_find",
			nextPage = p2.pageCursor and p2.pageCursor ~= ""
		}
	end, { fireEvent = fireLoadingEvent }),
	getOnlineFriendsByUserId = reportPromiseLoadingTimeWrapper(getOnlineFriendsByUserId, function(p2)
		return { fetch = "friends_online" }
	end, { fireEvent = fireLoadingEvent })
}
