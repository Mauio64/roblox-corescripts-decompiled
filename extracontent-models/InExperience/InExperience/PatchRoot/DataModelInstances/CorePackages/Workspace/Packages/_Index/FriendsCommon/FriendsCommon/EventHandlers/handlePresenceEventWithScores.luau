local Parent = script:FindFirstAncestor("FriendsCommon").Parent
local FFlagFriendsSortFeatureLoggingEnabled = require(Parent.SharedFlags).FFlagFriendsSortFeatureLoggingEnabled
local queries = require(Parent.ApolloLocalState).queries
local ApolloFriends = require(Parent.ApolloFriends)
local ApolloPresence = require(Parent.ApolloPresence)

require(Parent.GraphQLServer)

local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local LoggingProtocol = require(Parent.LoggingProtocol)

local function rtnPresenceToGraphQLPresence(t1: {[any]: any}) -- line: 39
	-- upvalues: ApolloPresence (copy)
	return {
		__typename = "UserPresence",
		id = tostring(t1.userId),
		userPresenceType = ApolloPresence.Formatters.formatNumberToPresenceType(t1.userPresenceType),
		lastLocation = t1.lastLocation,
		lastOnline = t1.lastOnline or "",
		gameId = t1.gameId or "",
		placeId = t1.placeId and tostring(t1.placeId) or "",
		rootPlaceId = t1.rootPlaceId and tostring(t1.rootPlaceId) or "",
		universeId = t1.universeId and tostring(t1.universeId) or ""
	}
end
local function toUserIdToFriendMap(p1) -- line: 53
	local t2 = {}

	for _, v18 in p1 do
		t2[v18.id] = table.clone(v18)
	end

	return t2
end
local function userIdFriendMapToList(p2) -- line: 62
	local t3 = {}

	for _, v22 in p2 do
		table.insert(t3, v22)
	end

	return t3
end

local v11 = SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		links = "https://docs.google.com/document/d/1uRCdl8pEuiW9wDiOTL39JPMGLhgxtpvVgiXovE8Xof4",
		throttlingThousandths = game:DefineFastInt("FriendsCommonAnalyticsThrottlingThousandths", 10000)
	},
	getSharedInfo = function() -- line: 84
		return {}
	end
})
local v12 = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeRtnMessage",
	description = "User received an rtn message v2",
	lastUpdated = {
		2026,
		3,
		18
	},
	backendsList = {{
		type = "EventIngest",
		format = function(t4: {[any]: any}, _: {[any]: any}) -- line: 96
			return t4
		end
	}}
})

local function handlePresenceEventWithScores(t6: {[any]: any}) -- line: 103
	-- upvalues: ApolloFriends (copy), queries (copy), toUserIdToFriendMap (copy), FFlagFriendsSortFeatureLoggingEnabled (copy), rtnPresenceToGraphQLPresence (copy), v11 (copy), v12 (copy)
	local t7 = {
		userId = t6.localUserId,
		sort = ApolloFriends.Enums.Sort.FriendshipScore
	}
	local v27 = t6.apolloClient:readQuery({
		query = queries.onlineFriendsByUserId,
		variables = t7
	})
	local v28 = if not v27 or not v27.onlineFriendsByUserId then {} else toUserIdToFriendMap(v27.onlineFriendsByUserId)
	local t8 = {}

	for _, v in pairs(t6.updatedPresences) do
		local str = tostring(v.userId)
		local v33 = t6.updatedSortScores[str]

		if FFlagFriendsSortFeatureLoggingEnabled then
			table.insert(t8, str)
		end

		if v.userPresenceType == 0 then
			v28[str] = nil
		elseif v28[str] ~= nil then
			local v34 = v28[str]

			v34.presence = rtnPresenceToGraphQLPresence(v)
			v34.sortScore = v33
		else
			v28[str] = {
				__typename = "Friend",
				id = tostring(v.userId),
				targetUserId = t6.localUserId,
				presence = rtnPresenceToGraphQLPresence(v),
				sortScore = v33
			}
		end
	end

	local t9 = {}

	for _, v37 in v28 do
		table.insert(t9, v37)
	end

	t6.apolloClient:writeQuery({
		query = queries.onlineFriendsByUserId,
		variables = t7,
		data = {
			onlineFriendsByUserId = t9
		}
	})

	if FFlagFriendsSortFeatureLoggingEnabled and t6.rtnMessageId ~= nil then
		local t10 = {
			sortType = "Carousel",
			messageId = t6.rtnMessageId,
			userId = tonumber(t6.localUserId),
			friendIds = table.concat(t8, ",")
		}

		v11.emit(v12, t10)
	end
end

return handlePresenceEventWithScores
