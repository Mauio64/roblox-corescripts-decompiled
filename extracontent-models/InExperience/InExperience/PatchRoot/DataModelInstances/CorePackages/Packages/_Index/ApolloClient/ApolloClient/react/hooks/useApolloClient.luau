local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local context = require(parent.react.context)
local getApolloContext = context.getApolloContext

require(parent.core)

function useApolloClient()
	local client = React.useContext(getApolloContext()).client
	invariant2(
		client,
		"No Apollo Client instance can be found. Please ensure that you have called `ApolloProvider` higher up in your tree."
	)

	return client
end

return { useApolloClient = useApolloClient }
