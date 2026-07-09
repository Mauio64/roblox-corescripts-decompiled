local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpService = game:GetService("HttpService")
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local LoggingProtocol = require(Parent.LoggingProtocol)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local v6 = SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		links = "https://docs.google.com/document/d/1uRCdl8pEuiW9wDiOTL39JPMGLhgxtpvVgiXovE8Xof4",
		throttlingThousandths = game:DefineFastInt("FriendsCommonAnalyticsThrottlingThousandths", 10000)
	},
	getSharedInfo = function() -- line: 23
		return {}
	end
})
local v7 = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeFindFriendsResponse",
	description = "User making a request to /FindFriends",
	lastUpdated = {
		2026,
		6,
		18
	},
	backendsList = {{
		type = SupportedTelemetryBackends.EventIngest,
		format = function(t1: {[any]: any}, _: {[any]: any}) -- line: 35
			return t1
		end
	}}
})
local v8 = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeGetAllOnlineFriendsResponse",
	description = "User making a request to /GetAllOnlineFriends",
	lastUpdated = {
		2026,
		6,
		18
	},
	backendsList = {{
		type = SupportedTelemetryBackends.EventIngest,
		format = function(t3: {[any]: any}, _: {[any]: any}) -- line: 49
			return t3
		end
	}}
})

local function safeEmit(p1, t5: {[any]: any}) -- line: 72
	-- upvalues: v6 (copy)
	pcall(function() -- line: 73
		-- upvalues: v6 (copy), p1 (copy), t5 (copy)
		v6.emit(p1, t5)
	end)
end

return {
	generateRequestId = function() -- line: 56
		-- upvalues: HttpService (copy)
		return string.format("friends-sort-%s", HttpService:GenerateGUID(false))
	end,
	getRequestOptions = function(s1: string?) -- line: 60
		if s1 == nil then
			return nil
		end

		return {
			headers = {
				["friends-sort"] = s1
			}
		}
	end,
	emitFindFriendsResponse = function(s2: string, t6: {[any]: any}) -- line: 78
		-- upvalues: v7 (copy), v6 (copy)
		local v19 = v7
		local t7 = {
			sortType = "FriendScore",
			requestId = s2,
			friendIds = table.concat(t6, ",")
		}

		pcall(function() -- line: 73
			-- upvalues: v6 (copy), v19 (copy), t7 (copy)
			v6.emit(v19, t7)
		end)
	end,
	emitGetAllOnlineFriendsResponse = function(s3: string, t8: {[any]: any}) -- line: 86
		-- upvalues: v8 (copy), v6 (copy)
		local v23 = v8
		local t9 = {
			sortType = "Carousel",
			requestId = s3,
			friendIds = table.concat(t8, ",")
		}

		pcall(function() -- line: 73
			-- upvalues: v6 (copy), v23 (copy), t9 (copy)
			v6.emit(v23, t9)
		end)
	end
}
