local parent = script:FindFirstAncestor("RobloxApolloClient").Parent

local ApolloClient = require(parent.ApolloClient)
local ApolloLocalState = require(parent.ApolloLocalState)
local GraphQLServer = require(parent.GraphQLServer)

local graphQLServer = GraphQLServer.GraphQLServer
local apolloClient = ApolloClient.ApolloClient
local HttpLink = ApolloClient.HttpLink
local InMemoryCache = ApolloClient.InMemoryCache
local typePolicies = ApolloLocalState.typePolicies

function initalizeApolloClient(p)
	local v = graphQLServer.new(p)
	local link = HttpLink.new({
		uri = "/api",
		fetch = function(_, p2)
			return v:fetchLocal(p2)
		end
	})

	local cache = InMemoryCache.new({ typePolicies = typePolicies })

	return (apolloClient.new({ link = link, cache = cache }))
end

return initalizeApolloClient
