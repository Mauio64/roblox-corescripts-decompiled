local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

local FriendsConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/FriendsConnector")
local getAllFriendsByUserId = FriendsConnector.getAllFriendsByUserId
local getOnlineFriendsByUserId = FriendsConnector.getOnlineFriendsByUserId

local function convertToStringWithDefault(p2)
	if p2 then
		return (tostring(p2))
	end

	return ""
end

return {
	UserPresence = {
		id = function(self)
			return self.id
		end,
		userPresenceType = function(p2)
			return p2.userPresence.UserPresenceType
		end,
		gameId = function(p2)
			local gameInstanceId = p2.userPresence.gameInstanceId

			if gameInstanceId then
				return (tostring(gameInstanceId))
			end

			return ""
		end,
		placeId = function(p2)
			local placeId = p2.userPresence.placeId

			if placeId then
				return (tostring(placeId))
			end

			return ""
		end,
		rootPlaceId = function(p2)
			local rootPlaceId = p2.userPresence.rootPlaceId

			if rootPlaceId then
				return (tostring(rootPlaceId))
			end

			return ""
		end,
		universeId = function(p2)
			local universeId = p2.userPresence.universeId

			if universeId then
				return (tostring(universeId))
			end

			return ""
		end,
		lastLocation = function(p2)
			return p2.userPresence.lastLocation
		end,
		lastOnline = function(p2)
			return p2.userPresence.lastOnline
		end
	},
	Friend = {
		targetUserId = function(p2, p3, p4, p5)
			return p5.variableValues.userId
		end,
		displayName = function()
			return graphQLError.new("The displayName field is being deprecated, please use UserProfile to retrieve names")
		end,
		presence = function(p2)
			return p2
		end,
		hasVerifiedBadge = function(p2): boolean
			return false
		end,
		sortScore = function(p2)
			return p2.sortScore or 0
		end
	},
	AllFriendsPage = {
		targetUserId = function(p2, p3, p4, p5)
			return p5.variableValues.userId
		end,
		curCursor = function(p2, p3, p4, p5)
			return p5.variableValues.pageCursor or ""
		end,
		nextCursor = function(p2)
			return p2.NextCursor or ""
		end,
		prevCursor = function(p2)
			return p2.PreviousCursor or ""
		end,
		friends = function(p2)
			return p2.PageItems or {}
		end
	},
	Query = {
		allFriendsByUserId = function(p2, p3, p4)
			return getAllFriendsByUserId(p3, p4.fetchImpl)
		end,
		onlineFriendsByUserId = function(p2, p3, p4)
			return getOnlineFriendsByUserId(p3, p4.fetchImpl)
		end
	}
}
