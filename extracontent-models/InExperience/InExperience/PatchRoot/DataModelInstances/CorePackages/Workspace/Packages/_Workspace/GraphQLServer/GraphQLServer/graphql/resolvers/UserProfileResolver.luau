local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local parent = GraphQLServer.Parent
require(parent.LuauPolyfill)
local GraphQL = require(GraphQLServer.Parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local formatUserProfileFields = require(GraphQLServer.graphql.utils.formatUserProfileFields)
require(script.Parent.Parent.generatedTypes)
local FFlagUserProfileBetterErrors = require(GraphQLServer.Flags.FFlagUserProfileBetterErrors)

return {
	UserProfile = {
		id = function(p)
			return (tostring(p.userId))
		end,
		displayName = function()
			return GraphQLError.new("The displayName field is not available on the UserProfile implementation of User, please use the names field instead")
		end
	},
	Query = {
		userProfiles = function(_, p, data, p2)
			local v = formatUserProfileFields(p2, data.collectSubFieldsImpl)
			return data.dataLoaders.userProfiles:getLoader(data.fetchImpl, v):loadMany(p.userIds):andThen(function(options)
				return options or {}
			end):catch(function(p3)
				if FFlagUserProfileBetterErrors then
					return p3
				end

				return {}
			end)
		end
	}
}
