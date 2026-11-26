local ApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxApolloClient/ApolloClient")
local ApolloLocalState = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxApolloClient/ApolloLocalState")
local graphQLServer = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxApolloClient/GraphQLServer").GraphQLServer
local apolloClient = ApolloClient.ApolloClient
local httpLink = ApolloClient.HttpLink
local inMemoryCache = ApolloClient.InMemoryCache
local typePolicies = ApolloLocalState.typePolicies

function LUAUFORGE_MODULE_GLOBALS_doc_initalizeApolloClient(p2)
	local v5 = graphQLServer.new(p2)
	local v6 = httpLink.new({
		uri = "/api",
		fetch = function(p3, p4)
			return v5:fetchLocal(p4)
		end
	})

	local v7 = inMemoryCache.new({ typePolicies = typePolicies })

	return (apolloClient.new({ link = v6, cache = v7 }))
end

return LUAUFORGE_MODULE_GLOBALS_doc_initalizeApolloClient
