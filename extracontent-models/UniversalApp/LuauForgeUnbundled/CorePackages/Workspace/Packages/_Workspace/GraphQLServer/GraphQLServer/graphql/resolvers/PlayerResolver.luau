local findAvatarHeadshotById = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/PlayerConnector").findAvatarHeadshotById
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")
return {
	default = {
		Player = {
			avatarHeadshot = function(p2, p3, p4, p5)
				local fetchImpl = p4.fetchImpl
				return findAvatarHeadshotById(p2.id, fetchImpl)
			end
		}
	}
}
