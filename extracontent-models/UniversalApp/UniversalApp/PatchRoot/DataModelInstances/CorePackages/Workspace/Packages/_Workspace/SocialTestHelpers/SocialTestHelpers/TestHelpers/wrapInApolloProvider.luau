local Parent = script:FindFirstAncestor("SocialTestHelpers").Parent
local React = require(Parent.React)
local ApolloProvider = require(Parent.ApolloClient).ApolloProvider
local mockApolloClient = require(Parent.GraphQLServer).ApolloClientTestUtils.mockApolloClient

return function(p1, p2) -- line: 9
	-- upvalues: React (copy), ApolloProvider (copy), mockApolloClient (copy)
	return React.createElement(ApolloProvider, {
		client = p2 or mockApolloClient({})
	}, p1)
end
