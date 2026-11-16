local parent = script:FindFirstAncestor("FriendsCommon").Parent

local ApolloLocalState = require(parent.ApolloLocalState)
local queries = ApolloLocalState.queries

local ApolloFriends = require(parent.ApolloFriends)
local ApolloPresence = require(parent.ApolloPresence)

require(parent.GraphQLServer)

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local LoggingProtocol = require(parent.LoggingProtocol)

local function rtnPresenceToGraphQLPresence(updatedPresence)
	return {
		id = tostring(updatedPresence.userId),
		userPresenceType = ApolloPresence.Formatters.formatNumberToPresenceType(updatedPresence.userPresenceType),
		lastLocation = updatedPresence.lastLocation,
		lastOnline = updatedPresence.lastOnline or "",
		gameId = updatedPresence.gameId or "",
		placeId = updatedPresence.placeId and tostring(updatedPresence.placeId) or "",
		rootPlaceId = updatedPresence.rootPlaceId and tostring(updatedPresence.rootPlaceId) or "",
		universeId = updatedPresence.universeId and tostring(updatedPresence.universeId) or "",
		__typename = "UserPresence"
	}
end

local function toUserIdToFriendMap(onlineFriendsByUserId)
	local clonesById = {}

	for _, item in onlineFriendsByUserId do
		clonesById[item.id] = table.clone(item)
	end

	return clonesById
end

local function userIdFriendMapToList(items) -- 1 equivalent call inferred from this helper
	local result = {}

	for _, item in items do
		table.insert(result, item)
	end

	return result
end

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
	name = "FriendsSortFeRtnMessage",
	description = "User received an rtn message v2",
	lastUpdated = { 2026, 3, 18 },
	backendsList = {
		{
			type = "EventIngest",
			format = function(p, _)
				return p
			end
		}
	}
})

local function handlePresenceEventWithScores(data)
	local variables = { userId = data.localUserId, sort = ApolloFriends.Enums.Sort.FriendshipScore }

	local query = data.apolloClient:readQuery({
		query = queries.onlineFriendsByUserId,
		variables = variables
	})

	local v = not (query and query.onlineFriendsByUserId) and {} or toUserIdToFriendMap(query.onlineFriendsByUserId)

	local userIds = {}

	for _, updatedPresence in pairs(data.updatedPresences) do
		local userId = tostring(updatedPresence.userId)
		local updatedSortScore = data.updatedSortScores[userId]

		table.insert(userIds, userId)

		if updatedPresence.userPresenceType == 0 then
			v[userId] = nil
		elseif v[userId] == nil then
			v[userId] = {
				__typename = "Friend",
				["id"] = tostring(updatedPresence.userId),
				targetUserId = data.localUserId,
				presence = rtnPresenceToGraphQLPresence(updatedPresence),
				sortScore = updatedSortScore
			}
		else
			local v2 = v[userId]
			v2.presence = rtnPresenceToGraphQLPresence(updatedPresence)
			v2.sortScore = updatedSortScore
		end
	end

	local onlineFriendsByUserId = userIdFriendMapToList(v) -- inferred equivalent call
	data.apolloClient:writeQuery({
		query = queries.onlineFriendsByUserId,
		variables = variables,
		data = { onlineFriendsByUserId = onlineFriendsByUserId }
	})

	if data.rtnMessageId ~= nil then
		local v2 = {
			messageId = data.rtnMessageId,
			userId = tonumber(data.localUserId),
			friendIds = table.concat(userIds, ","),
			sortType = "Carousel"
		}

		emitter.emit(telemetry, v2)
	end
end

return handlePresenceEventWithScores
