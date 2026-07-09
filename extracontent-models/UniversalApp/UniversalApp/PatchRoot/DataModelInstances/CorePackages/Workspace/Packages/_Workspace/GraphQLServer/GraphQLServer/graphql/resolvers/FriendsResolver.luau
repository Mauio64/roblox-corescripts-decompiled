local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local GraphQLServerParent = GraphQLServer.Parent
local GraphQLError = require(GraphQLServer.Parent.GraphQL).GraphQLError

require(GraphQLServer.graphql.generatedTypes)
require(GraphQLServerParent.LuauPolyfill)

local FriendsConnector = require(GraphQLServer.graphql.connectors.FriendsConnector)
local getAllFriendsByUserId = FriendsConnector.getAllFriendsByUserId
local getOnlineFriendsByUserId = FriendsConnector.getOnlineFriendsByUserId

local function convertToStringWithDefault(p1) -- line: 20
	if p1 then
		return (tostring(p1))
	end

	return ""
end

return {
	UserPresence = {
		id = function(p2) -- line: 26
			return p2.id
		end,
		userPresenceType = function(p3) -- line: 29
			return p3.userPresence.UserPresenceType
		end,
		gameId = function(p4) -- line: 32
			local gameInstanceId = p4.userPresence.gameInstanceId

			if gameInstanceId then
				return (tostring(gameInstanceId))
			end

			return ""
		end,
		placeId = function(p5) -- line: 35
			local placeId = p5.userPresence.placeId

			if placeId then
				return (tostring(placeId))
			end

			return ""
		end,
		rootPlaceId = function(p6) -- line: 38
			local rootPlaceId = p6.userPresence.rootPlaceId

			if rootPlaceId then
				return (tostring(rootPlaceId))
			end

			return ""
		end,
		universeId = function(p7) -- line: 41
			local universeId = p7.userPresence.universeId

			if universeId then
				return (tostring(universeId))
			end

			return ""
		end,
		lastLocation = function(p8) -- line: 44
			return p8.userPresence.lastLocation
		end,
		lastOnline = function(p9) -- line: 47
			return p9.userPresence.lastOnline
		end
	},
	Friend = {
		targetUserId = function(_, _, _, p13) -- line: 52
			return p13.variableValues.userId
		end,
		displayName = function() -- line: 55
			-- upvalues: GraphQLError (copy)
			return GraphQLError.new("The displayName field is being deprecated, please use UserProfile to retrieve names")
		end,
		presence = function(p14) -- line: 60
			return p14
		end,
		hasVerifiedBadge = function(_) -- line: 63
			return false
		end,
		sortScore = function(p16) -- line: 66
			return p16.sortScore or 0
		end
	},
	AllFriendsPage = {
		targetUserId = function(_, _, _, p20) -- line: 71
			return p20.variableValues.userId
		end,
		curCursor = function(_, _, _, p24) -- line: 74
			return p24.variableValues.pageCursor or ""
		end,
		nextCursor = function(p25) -- line: 77
			return p25.NextCursor or ""
		end,
		prevCursor = function(p26) -- line: 80
			return p26.PreviousCursor or ""
		end,
		friends = function(p27) -- line: 83
			return p27.PageItems or {}
		end
	},
	Query = {
		allFriendsByUserId = function(_, p29, p30) -- line: 88
			-- upvalues: getAllFriendsByUserId (copy)
			return getAllFriendsByUserId(p29, p30.fetchImpl)
		end,
		onlineFriendsByUserId = function(_, p32, p33) -- line: 91
			-- upvalues: getOnlineFriendsByUserId (copy)
			return getOnlineFriendsByUserId(p32, p33.fetchImpl)
		end
	}
}
