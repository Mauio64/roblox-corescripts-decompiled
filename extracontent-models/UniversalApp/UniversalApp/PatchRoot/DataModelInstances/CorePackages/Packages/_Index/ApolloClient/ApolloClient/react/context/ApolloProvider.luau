local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

require(parent2.LuauPolyfill)

local React = require(parent2.React)

local ApolloContext = require(script.Parent.ApolloContext)
local getApolloContext = ApolloContext.getApolloContext
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

require(parent.core.ApolloClient)

function ApolloProvider(p)
	local apolloContext = getApolloContext()
	return React.createElement(apolloContext.Consumer, nil, function(p2)
		local v = p2 == nil and {} or p2

		if p.client and v.client ~= p.client then
			v.client = p.client
		end

		invariant2(
			v.client,
			"ApolloProvider was not passed a client instance. Make sure you pass in your client via the \"client\" prop."
		)

		return React.createElement(apolloContext.Provider, { value = v }, p.children)
	end)
end

return { ApolloProvider = ApolloProvider }
