require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
return {
	default = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/utils").mergeResolvers({
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/UserResolver").default,
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/PlayerResolver").default,
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/OmniFeed").default,
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/ScalarResolver").default,
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/VirtualEventResolver"),
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/ExperienceResolver"),
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/ProfileInsightsResolver"),
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/AmpUpsellResolver").default,
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/UserProfileResolver"),
		require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/FriendsResolver"),
		(require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers/ShareLinkResolver"))
	})
}
