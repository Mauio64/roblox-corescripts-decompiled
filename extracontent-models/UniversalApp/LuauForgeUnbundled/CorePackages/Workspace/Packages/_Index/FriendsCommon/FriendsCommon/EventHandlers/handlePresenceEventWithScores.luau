local queries = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloLocalState").queries

local ApolloFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloFriends")
local ApolloPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloPresence")

require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/GraphQLServer")

local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SocialLuaAnalytics")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCommon/LoggingProtocol")

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

	for k, item in onlineFriendsByUserId do
		clonesById[item.id] = table.clone(item)
	end

	return clonesById
end

local function userIdFriendMapToList(items)
	local result = {}

	for k, item in items do
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
			format = function(p2, p3)
				return p2
			end
		}
	}
})

local function handlePresenceEventWithScores(data)
	local v5 = { userId = data.localUserId, sort = ApolloFriends.Enums.Sort.FriendshipScore }

	local query = data.apolloClient:readQuery({
		query = queries.onlineFriendsByUserId,
		variables = v5
	})

	local v6 = not (query and query.onlineFriendsByUserId) and {}
		or toUserIdToFriendMap(query.onlineFriendsByUserId)

	local userIds = {}

	for k, updatedPresence in pairs(data.updatedPresences) do
		local userId = tostring(updatedPresence.userId)
		local updatedSortScore = data.updatedSortScores[userId]

		table.insert(userIds, userId)

		if updatedPresence.userPresenceType == 0 then
			v6[userId] = nil
		elseif v6[userId] == nil then
			v6[userId] = {
				__typename = "Friend",
				["id"] = tostring(updatedPresence.userId),
				targetUserId = data.localUserId,
				presence = rtnPresenceToGraphQLPresence(updatedPresence),
				sortScore = updatedSortScore
			}
		else
			local v7 = v6[userId]
			v7.presence = rtnPresenceToGraphQLPresence(updatedPresence)
			v7.sortScore = updatedSortScore
		end
	end

	local v7 = {}

	for k, v8 in v6 do
		table.insert(v7, v8)
	end

	data.apolloClient:writeQuery({
		query = queries.onlineFriendsByUserId,
		variables = v5,
		data = { onlineFriendsByUserId = v7 }
	})

	if data.rtnMessageId ~= nil then
		local v8 = {
			messageId = data.rtnMessageId,
			userId = tonumber(data.localUserId),
			friendIds = table.concat(userIds, ","),
			sortType = "Carousel"
		}

		emitter.emit(telemetry, v8)
	end
end

return handlePresenceEventWithScores
