require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
local formatUserProfileFields = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/utils/formatUserProfileFields")
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")
local FFlagUserProfileBetterErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/Flags/FFlagUserProfileBetterErrors")

return {
	UserProfile = {
		id = function(self)
			return (tostring(self.userId))
		end,
		displayName = function()
			return graphQLError.new("The displayName field is not available on the UserProfile implementation of User, please use the names field instead")
		end
	},
	Query = {
		userProfiles = function(p2, p3, data, p4)
			local v5 = formatUserProfileFields(p4, data.collectSubFieldsImpl)
			return data.dataLoaders.userProfiles:getLoader(data.fetchImpl, v5):loadMany(p3.userIds):andThen(function(options)
				return options or {}
			end):catch(function(p5)
				if FFlagUserProfileBetterErrors then
					return p5
				end

				return {}
			end)
		end
	}
}
