local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local getApolloContext = require(script.Parent.ApolloContext).getApolloContext
local invariant = require(ParentParent.jsutils.invariant).invariant

require(ParentParent.core.ApolloClient)

function ApolloConsumer(t1: {[any]: any}) -- line: 21
	-- upvalues: getApolloContext (copy), React (copy), invariant (copy)
	local v7 = getApolloContext()

	return React.createElement(v7.Consumer, nil, function(p1) -- line: 23
		-- upvalues: invariant (copy), t1 (copy)
		invariant(p1 and p1.client, "Could not find \"client\" in the context of ApolloConsumer. Wrap the root component in an <ApolloProvider>.")

		return t1.children(p1.client)
	end)
end

return {
	ApolloConsumer = ApolloConsumer
}
