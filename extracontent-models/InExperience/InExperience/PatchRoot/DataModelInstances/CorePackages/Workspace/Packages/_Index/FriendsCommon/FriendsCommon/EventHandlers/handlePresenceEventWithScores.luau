local Parent = script:FindFirstAncestor("FriendsCommon").Parent
local queries = require(Parent.ApolloLocalState).queries
local ApolloFriends = require(Parent.ApolloFriends)
local ApolloPresence = require(Parent.ApolloPresence)

require(Parent.GraphQLServer)

local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local LoggingProtocol = require(Parent.LoggingProtocol)

local function rtnPresenceToGraphQLPresence(t1: {[any]: any}) -- line: 37
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
local function toUserIdToFriendMap(p1) -- line: 51
	local t2 = {}

	for _, v17 in p1 do
		t2[v17.id] = table.clone(v17)
	end

	return t2
end
local function userIdFriendMapToList(p2) -- line: 60
	local t3 = {}

	for _, v21 in p2 do
		table.insert(t3, v21)
	end

	return t3
end

local v10 = SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		links = "https://docs.google.com/document/d/1uRCdl8pEuiW9wDiOTL39JPMGLhgxtpvVgiXovE8Xof4",
		throttlingThousandths = game:DefineFastInt("FriendsCommonAnalyticsThrottlingThousandths", 10000)
	},
	getSharedInfo = function() -- line: 82
		return {}
	end
})
local v11 = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeRtnMessage",
	description = "User received an rtn message v2",
	lastUpdated = {
		2026,
		3,
		18
	},
	backendsList = {{
		type = "EventIngest",
		format = function(t4: {[any]: any}, _: {[any]: any}) -- line: 94
			return t4
		end
	}}
})

local function handlePresenceEventWithScores(t6: {[any]: any}) -- line: 101
	-- upvalues: ApolloFriends (copy), queries (copy), toUserIdToFriendMap (copy), rtnPresenceToGraphQLPresence (copy), v10 (copy), v11 (copy)
	local t7 = {
		userId = t6.localUserId,
		sort = ApolloFriends.Enums.Sort.FriendshipScore
	}
	local v26 = t6.apolloClient:readQuery({
		query = queries.onlineFriendsByUserId,
		variables = t7
	})
	local v27 = if not v26 or not v26.onlineFriendsByUserId then {} else toUserIdToFriendMap(v26.onlineFriendsByUserId)
	local t8 = {}

	for _, v in pairs(t6.updatedPresences) do
		local str = tostring(v.userId)
		local v32 = t6.updatedSortScores[str]

		table.insert(t8, str)

		if v.userPresenceType == 0 then
			v27[str] = nil
		elseif v27[str] ~= nil then
			local v33 = v27[str]

			v33.presence = rtnPresenceToGraphQLPresence(v)
			v33.sortScore = v32
		else
			v27[str] = {
				__typename = "Friend",
				id = tostring(v.userId),
				targetUserId = t6.localUserId,
				presence = rtnPresenceToGraphQLPresence(v),
				sortScore = v32
			}
		end
	end

	local t9 = {}

	for _, v36 in v27 do
		table.insert(t9, v36)
	end

	t6.apolloClient:writeQuery({
		query = queries.onlineFriendsByUserId,
		variables = t7,
		data = {
			onlineFriendsByUserId = t9
		}
	})

	if t6.rtnMessageId ~= nil then
		local t10 = {
			sortType = "Carousel",
			messageId = t6.rtnMessageId,
			userId = tonumber(t6.localUserId),
			friendIds = table.concat(t8, ",")
		}

		v10.emit(v11, t10)
	end
end

return handlePresenceEventWithScores
