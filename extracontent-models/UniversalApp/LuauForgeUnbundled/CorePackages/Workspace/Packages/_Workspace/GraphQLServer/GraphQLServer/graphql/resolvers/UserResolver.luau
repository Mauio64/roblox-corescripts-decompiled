local UserConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/UserConnector")
local findUserById = UserConnector.findUserById
local findMe = UserConnector.findMe
return {
	default = {
		User = {
			__resolveType = function(): string
				return "Player"
			end
		},
		Query = {
			me = function(p2, p3, p4)
				return findMe(p4.fetchImpl)
			end,
			user = function(p2, p3, p4)
				return findUserById(p3.id, p4.fetchImpl)
			end
		}
	}
}
