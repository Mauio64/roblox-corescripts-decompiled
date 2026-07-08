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
local v16 = game:DefineFastFlag("PassRequestIdToFriendsApiCalls", false)
local HttpService = game:GetService("HttpService")
local v18 = game:DefineFastFlag("FriendsSortFriendsApiFeatureLoggingEnabled", false)
local LoggingProtocol = require(GraphQLServerParent.LoggingProtocol)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local v21 = UrlBuilder.new({
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
local v22 = UrlBuilder.new({
	path = "users/{userId}/friends/online",
	base = UrlBase.FRIENDS,
	query = {{
		name = "userSort",
		value = "{userSort}",
		optional = true
	}}
})
local v23 = if not v16 then nil else SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		links = "https://docs.google.com/document/d/1uRCdl8pEuiW9wDiOTL39JPMGLhgxtpvVgiXovE8Xof4",
		throttlingThousandths = game:DefineFastInt("FriendsCommonAnalyticsThrottlingThousandths", 10000)
	},
	getSharedInfo = function() -- line: 113
		return {}
	end
})
local v24 = if not v16 then nil else SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeFindFriendsResponse",
	description = "User making a request to /FindFriends",
	lastUpdated = {
		2026,
		3,
		18
	},
	backendsList = {{
		type = SupportedTelemetryBackends.EventIngest,
		format = function(t1: {[any]: any}, _: {[any]: any}) -- line: 127
			return t1
		end
	}}
})
local v25 = if not v16 then nil else SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeGetAllOnlineFriendsResponse",
	description = "User making a request to /GetAllOnlineFriends",
	lastUpdated = {
		2026,
		3,
		18
	},
	backendsList = {{
		type = SupportedTelemetryBackends.EventIngest,
		format = function(t3: {[any]: any}, _: {[any]: any}) -- line: 143
			return t3
		end
	}}
})

local function getAllFriendsByUserId(t5: {[any]: any}, p1) -- line: 160
	-- upvalues: fetch (copy), Promise (copy), v21 (copy), v16 (copy), HttpService (copy), Response (copy), GraphQLError (copy), v18 (copy), v24 (copy), v23 (copy)
	local v40 = p1 or fetch

	return Promise.new(function(resolve, reject) -- line: 163
		-- upvalues: v21 (copy), t5 (copy), v16 (copy), HttpService (copy), v40 (copy), Response (copy), GraphQLError (copy), v18 (copy), v24 (copy), v23 (copy)
		local v52 = v21({
			userId = t5.userId,
			limit = t5.pageLimit or 50,
			cursor = t5.pageCursor,
			userSort = t5.sort
		})
		local v53 = if not v16 then nil else string.format("friends-sort-%s", HttpService:GenerateGUID(false))
		local v54 = v40(v52, (if not v16 then {
			method = "GET"
		} else {
			method = "GET",
			headers = {
				["friends-sort"] = v53
			}
		})):catch(function(p2) -- line: 178
			-- upvalues: Response (copy)
			local v74 = Response.error()

			v74.statusText = p2.message

			return v74
		end):expect()

		if not v54.ok then
			reject(GraphQLError.new(v54.statusText, nil, nil, nil, nil, {
				extensions = {
					status = v54.status,
					statusText = v54.statusText
				}
			}))

			return
		end

		local v55 = v54:json():catch(function() -- line: 197
			return nil
		end):expect()

		if not v55 then
			reject(GraphQLError.new("Failed to decode HTTP response as JSON for friends API"))

			return
		end

		resolve(v55)

		if v16 and v18 then
			if v53 == nil then
				return
			end

			local t6 = {}

			for _, v in pairs(v55.PageItems) do
				table.insert(t6, v.id)
			end

			local v59 = v24
			local t7 = {
				sortType = "FriendScore",
				requestId = v53,
				friendIds = table.concat(t6, ",")
			}

			v23.emit(v59, t7)
		end
	end)
end
local function getOnlineFriendsByUserId(t8: {[any]: any}, p3) -- line: 223
	-- upvalues: fetch (copy), Promise (copy), v22 (copy), v16 (copy), HttpService (copy), Response (copy), GraphQLError (copy), v18 (copy), v25 (copy), v23 (copy)
	local v43 = p3 or fetch

	return Promise.new(function(resolve, reject) -- line: 226
		-- upvalues: v22 (copy), t8 (copy), v16 (copy), HttpService (copy), v43 (copy), Response (copy), GraphQLError (copy), v18 (copy), v25 (copy), v23 (copy)
		local v63 = v22({
			userId = t8.userId,
			userSort = t8.sort
		})
		local v64 = if not v16 then nil else string.format("friends-sort-%s", HttpService:GenerateGUID(false))
		local v65 = v43(v63, (if not v16 then {
			method = "GET"
		} else {
			method = "GET",
			headers = {
				["friends-sort"] = v64
			}
		})):catch(function(p4) -- line: 239
			-- upvalues: Response (copy)
			local v76 = Response.error()

			v76.statusText = p4.message

			return v76
		end):expect()

		if not v65.ok then
			reject(GraphQLError.new(v65.statusText, nil, nil, nil, nil, {
				extensions = {
					status = v65.status,
					statusText = v65.statusText
				}
			}))

			return
		end

		local v66 = v65:json():catch(function() -- line: 258
			return nil
		end):expect()

		if not v66 then
			reject(GraphQLError.new("Failed to decode HTTP response as JSON for friends API"))

			return
		end

		local v67 = v66.data or {}

		resolve(v67)

		if v16 and v18 then
			if v64 == nil then
				return
			end

			local t9 = {}

			for _, v70 in v67 do
				table.insert(t9, v70.id)
			end

			local v71 = v25
			local t10 = {
				sortType = "Carousel",
				requestId = v64,
				friendIds = table.concat(t9, ",")
			}

			v23.emit(v71, t10)
		end
	end)
end
local function fireLoadingEvent(p5, p6, p7) -- line: 285
	-- upvalues: createDiagMetricString (copy), getPlatformSuffix (copy), PlatformSpecificity (copy), Diag (copy)
	local v47 = createDiagMetricString(p5, p6) .. getPlatformSuffix(PlatformSpecificity.BucketsOnly)

	Diag:reportStats(v47, p7)
end

return {
	getAllFriendsByUserId = reportPromiseLoadingTimeWrapper(getAllFriendsByUserId, function(p8) -- line: 293
		return {
			fetch = "friends_find",
			nextPage = p8.pageCursor and p8.pageCursor ~= ""
		}
	end, {
		fireEvent = fireLoadingEvent
	}),
	getOnlineFriendsByUserId = reportPromiseLoadingTimeWrapper(getOnlineFriendsByUserId, function(_) -- line: 301
		return {
			fetch = "friends_online"
		}
	end, {
		fireEvent = fireLoadingEvent
	})
}
