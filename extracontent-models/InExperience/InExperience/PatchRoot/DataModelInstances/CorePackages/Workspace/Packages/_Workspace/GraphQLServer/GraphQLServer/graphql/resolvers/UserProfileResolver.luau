local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local GraphQLServerParent = GraphQLServer.Parent

require(GraphQLServerParent.LuauPolyfill)

local GraphQLError = require(GraphQLServer.Parent.GraphQL).GraphQLError
local formatUserProfileFields = require(GraphQLServer.graphql.utils.formatUserProfileFields)

require(script.Parent.Parent.generatedTypes)

local FFlagUserProfileBetterErrors = require(GraphQLServer.Flags.FFlagUserProfileBetterErrors)

return {
	UserProfile = {
		id = function(p1) -- line: 16
			return (tostring(p1.userId))
		end,
		displayName = function() -- line: 19
			-- upvalues: GraphQLError (copy)
			return GraphQLError.new("The displayName field is not available on the UserProfile implementation of User, please use the names field instead")
		end
	},
	Query = {
		userProfiles = function(_, p3, p4, p5) -- line: 26
			-- upvalues: formatUserProfileFields (copy), FFlagUserProfileBetterErrors (copy)
			local v11 = formatUserProfileFields(p5, p4.collectSubFieldsImpl)

			return p4.dataLoaders.userProfiles:getLoader(p4.fetchImpl, v11):loadMany(p3.userIds):andThen(function(p6) -- line: 31
				return p6 or {}
			end):catch(function(p7) -- line: 34
				-- upvalues: FFlagUserProfileBetterErrors (copy)
				if FFlagUserProfileBetterErrors then
					return p7
				end

				return {}
			end)
		end
	}
}
