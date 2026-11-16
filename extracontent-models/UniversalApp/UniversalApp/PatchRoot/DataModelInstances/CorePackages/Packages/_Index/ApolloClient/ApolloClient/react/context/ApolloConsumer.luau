local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local ApolloContext = require(script.Parent.ApolloContext)
local getApolloContext = ApolloContext.getApolloContext
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

require(parent.core.ApolloClient)

function ApolloConsumer(p)
	local apolloContext = getApolloContext()
	return React.createElement(apolloContext.Consumer, nil, function(p2)
		invariant2(
			p2 and p2.client,
			"Could not find \"client\" in the context of ApolloConsumer. Wrap the root component in an <ApolloProvider>."
		)

		return p.children(p2.client)
	end)
end

return { ApolloConsumer = ApolloConsumer }
