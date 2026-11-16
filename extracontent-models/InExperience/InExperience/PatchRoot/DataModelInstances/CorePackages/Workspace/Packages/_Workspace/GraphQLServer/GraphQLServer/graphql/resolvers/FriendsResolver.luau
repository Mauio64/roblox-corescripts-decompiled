local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local parent = GraphQLServer.Parent
local GraphQL = require(GraphQLServer.Parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
require(GraphQLServer.graphql.generatedTypes)

require(parent.LuauPolyfill)

local FriendsConnector = require(GraphQLServer.graphql.connectors.FriendsConnector)
local getAllFriendsByUserId = FriendsConnector.getAllFriendsByUserId
local getOnlineFriendsByUserId = FriendsConnector.getOnlineFriendsByUserId

local function convertToStringWithDefault(p) -- 4 equivalent calls inferred from this helper
	if p then
		return (tostring(p))
	end

	return ""
end

return {
	UserPresence = {
		id = function(p)
			return p.id
		end,
		userPresenceType = function(p)
			return p.userPresence.UserPresenceType
		end,
		gameId = function(p)
			return convertToStringWithDefault(p.userPresence.gameInstanceId) -- inferred equivalent call
		end,
		placeId = function(p)
			return convertToStringWithDefault(p.userPresence.placeId) -- inferred equivalent call
		end,
		rootPlaceId = function(p)
			return convertToStringWithDefault(p.userPresence.rootPlaceId) -- inferred equivalent call
		end,
		universeId = function(p)
			return convertToStringWithDefault(p.userPresence.universeId) -- inferred equivalent call
		end,
		lastLocation = function(p)
			return p.userPresence.lastLocation
		end,
		lastOnline = function(p)
			return p.userPresence.lastOnline
		end
	},
	Friend = {
		targetUserId = function(_, _, _, p)
			return p.variableValues.userId
		end,
		displayName = function()
			return GraphQLError.new("The displayName field is being deprecated, please use UserProfile to retrieve names")
		end,
		presence = function(p)
			return p
		end,
		hasVerifiedBadge = function(_): boolean
			return false
		end,
		sortScore = function(p)
			return p.sortScore or 0
		end
	},
	AllFriendsPage = {
		targetUserId = function(_, _, _, p)
			return p.variableValues.userId
		end,
		curCursor = function(_, _, _, p)
			return p.variableValues.pageCursor or ""
		end,
		nextCursor = function(p)
			return p.NextCursor or ""
		end,
		prevCursor = function(p)
			return p.PreviousCursor or ""
		end,
		friends = function(p)
			return p.PageItems or {}
		end
	},
	Query = {
		allFriendsByUserId = function(_, p, p2)
			return getAllFriendsByUserId(p, p2.fetchImpl)
		end,
		onlineFriendsByUserId = function(_, p, p2)
			return getOnlineFriendsByUserId(p, p2.fetchImpl)
		end
	}
}
