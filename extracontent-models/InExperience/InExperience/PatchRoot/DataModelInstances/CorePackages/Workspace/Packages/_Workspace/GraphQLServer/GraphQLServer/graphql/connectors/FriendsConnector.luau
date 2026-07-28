local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local GraphQLServerParent = GraphQLServer.Parent
local UrlBuilder = require(GraphQLServer.Parent.UrlBuilder).UrlBuilder
local UrlBase = require(GraphQLServer.Parent.UrlBuilder).UrlBase

require(GraphQLServer.Parent.LuauPolyfill)

local Promise = require(GraphQLServer.Parent.Promise)
local GraphQLError = require(GraphQLServer.Parent.GraphQL).GraphQLError

require(GraphQLServer.graphql.generatedTypes)

local Fetch = require(GraphQLServer.Parent.Fetch)
local fetch = Fetch.fetch
local Response = Fetch.Response
local SocialLuaAnalytics = require(GraphQLServerParent.SocialLuaAnalytics)
local reportPromiseLoadingTimeWrapper = SocialLuaAnalytics.Analytics.Timing.reportPromiseLoadingTimeWrapper
local createDiagMetricString = SocialLuaAnalytics.Analytics.Formatters.createDiagMetricString
local Diag = SocialLuaAnalytics.Analytics.DefaultAnalyticsService.Diag
local getPlatformSuffix = SocialLuaAnalytics.Analytics.FireEvent.getPlatformSuffix
local PlatformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity
local HttpService = game:GetService("HttpService")
local LoggingProtocol = require(GraphQLServerParent.LoggingProtocol)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local v19 = UrlBuilder.new({
	path = "users/{userId}/friends/find",
	base = UrlBase.FRIENDS,
	query = {
		{
			name = "limit",
			value = "{limit}",
			optional = false
		},
		{
			name = "userSort",
			value = "{userSort}",
			optional = true
		},
		{
			name = "cursor",
			value = "{cursor}",
			optional = true
		}
	}
})
local v20 = UrlBuilder.new({
	path = "users/{userId}/friends/online",
	base = UrlBase.FRIENDS,
	query = {{
		name = "userSort",
		value = "{userSort}",
		optional = true
	}}
})
local v21 = SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		links = "https://docs.google.com/document/d/1uRCdl8pEuiW9wDiOTL39JPMGLhgxtpvVgiXovE8Xof4",
		throttlingThousandths = game:DefineFastInt("FriendsCommonAnalyticsThrottlingThousandths", 10000)
	},
	getSharedInfo = function() -- line: 108
		return {}
	end
})
local v22 = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeFindFriendsResponse",
	description = "User making a request to /FindFriends",
	lastUpdated = {
		2026,
		3,
		18
	},
	backendsList = {{
		type = SupportedTelemetryBackends.EventIngest,
		format = function(t1: {[any]: any}, _: {[any]: any}) -- line: 120
			return t1
		end
	}}
})
local v23 = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeGetAllOnlineFriendsResponse",
	description = "User making a request to /GetAllOnlineFriends",
	lastUpdated = {
		2026,
		3,
		18
	},
	backendsList = {{
		type = SupportedTelemetryBackends.EventIngest,
		format = function(t3: {[any]: any}, _: {[any]: any}) -- line: 134
			return t3
		end
	}}
})

local function getAllFriendsByUserId(t5: {[any]: any}, p1) -- line: 150
	-- upvalues: fetch (copy), Promise (copy), v19 (copy), HttpService (copy), Response (copy), GraphQLError (copy), v22 (copy), v21 (copy)
	local v38 = p1 or fetch

	return Promise.new(function(resolve, reject) -- line: 153
		-- upvalues: v19 (copy), t5 (copy), HttpService (copy), v38 (copy), Response (copy), GraphQLError (copy), v22 (copy), v21 (copy)
		local v50 = v19({
			userId = t5.userId,
			limit = t5.pageLimit or 50,
			cursor = t5.pageCursor,
			userSort = t5.sort
		})
		local v51 = string.format("friends-sort-%s", HttpService:GenerateGUID(false))
		local v52 = v38(v50, {
			method = "GET",
			headers = {
				["friends-sort"] = v51
			}
		}):catch(function(p2) -- line: 163
			-- upvalues: Response (copy)
			local v72 = Response.error()

			v72.statusText = p2.message

			return v72
		end):expect()

		if not v52.ok then
			reject(GraphQLError.new(v52.statusText, nil, nil, nil, nil, {
				extensions = {
					status = v52.status,
					statusText = v52.statusText
				}
			}))

			return
		end

		local v53 = v52:json():catch(function() -- line: 182
			return nil
		end):expect()

		if not v53 then
			reject(GraphQLError.new("Failed to decode HTTP response as JSON for friends API"))

			return
		end

		resolve(v53)

		if v51 == nil then
			return
		end

		local t6 = {}

		for _, v in pairs(v53.PageItems) do
			table.insert(t6, v.id)
		end

		local v57 = v22
		local t7 = {
			sortType = "FriendScore",
			requestId = v51,
			friendIds = table.concat(t6, ",")
		}

		v21.emit(v57, t7)
	end)
end
local function getOnlineFriendsByUserId(t8: {[any]: any}, p3) -- line: 206
	-- upvalues: fetch (copy), Promise (copy), v20 (copy), HttpService (copy), Response (copy), GraphQLError (copy), v23 (copy), v21 (copy)
	local v41 = p3 or fetch

	return Promise.new(function(resolve, reject) -- line: 209
		-- upvalues: v20 (copy), t8 (copy), HttpService (copy), v41 (copy), Response (copy), GraphQLError (copy), v23 (copy), v21 (copy)
		local v61 = v20({
			userId = t8.userId,
			userSort = t8.sort
		})
		local v62 = string.format("friends-sort-%s", HttpService:GenerateGUID(false))
		local v63 = v41(v61, {
			method = "GET",
			headers = {
				["friends-sort"] = v62
			}
		}):catch(function(p4) -- line: 217
			-- upvalues: Response (copy)
			local v74 = Response.error()

			v74.statusText = p4.message

			return v74
		end):expect()

		if not v63.ok then
			reject(GraphQLError.new(v63.statusText, nil, nil, nil, nil, {
				extensions = {
					status = v63.status,
					statusText = v63.statusText
				}
			}))

			return
		end

		local v64 = v63:json():catch(function() -- line: 236
			return nil
		end):expect()

		if not v64 then
			reject(GraphQLError.new("Failed to decode HTTP response as JSON for friends API"))

			return
		end

		local v65 = v64.data or {}

		resolve(v65)

		if v62 == nil then
			return
		end

		local t9 = {}

		for _, v68 in v65 do
			table.insert(t9, v68.id)
		end

		local v69 = v23
		local t10 = {
			sortType = "Carousel",
			requestId = v62,
			friendIds = table.concat(t9, ",")
		}

		v21.emit(v69, t10)
	end)
end
local function fireLoadingEvent(p5, p6, p7) -- line: 261
	-- upvalues: createDiagMetricString (copy), getPlatformSuffix (copy), PlatformSpecificity (copy), Diag (copy)
	local v45 = createDiagMetricString(p5, p6) .. getPlatformSuffix(PlatformSpecificity.BucketsOnly)

	Diag:reportStats(v45, p7)
end

return {
	getAllFriendsByUserId = reportPromiseLoadingTimeWrapper(getAllFriendsByUserId, function(p8) -- line: 269
		return {
			fetch = "friends_find",
			nextPage = p8.pageCursor and p8.pageCursor ~= ""
		}
	end, {
		fireEvent = fireLoadingEvent
	}),
	getOnlineFriendsByUserId = reportPromiseLoadingTimeWrapper(getOnlineFriendsByUserId, function(_) -- line: 277
		return {
			fetch = "friends_online"
		}
	end, {
		fireEvent = fireLoadingEvent
	})
}
