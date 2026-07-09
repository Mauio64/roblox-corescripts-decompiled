local Parent = script:FindFirstAncestor("RobloxApolloClient").Parent
local ApolloClient = require(Parent.ApolloClient)
local ApolloLocalState = require(Parent.ApolloLocalState)
local GraphQLServer = require(Parent.GraphQLServer).GraphQLServer
local ApolloClient2 = ApolloClient.ApolloClient
local HttpLink = ApolloClient.HttpLink
local InMemoryCache = ApolloClient.InMemoryCache
local typePolicies = ApolloLocalState.typePolicies

function initalizeApolloClient(p1) -- line: 14
	-- upvalues: GraphQLServer (copy), HttpLink (copy), InMemoryCache (copy), typePolicies (copy), ApolloClient2 (copy)
	local v10 = GraphQLServer.new(p1)
	local v11 = HttpLink.new({
		uri = "/api",
		fetch = function(_, p3) -- line: 18
			-- upvalues: v10 (copy)
			return v10:fetchLocal(p3)
		end
	})
	local v12 = InMemoryCache.new({
		typePolicies = typePolicies
	})

	return (ApolloClient2.new({
		link = v11,
		cache = v12
	}))
end

return initalizeApolloClient
