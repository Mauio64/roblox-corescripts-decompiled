local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)

local React = require(ParentParentParent.React)
local getApolloContext = require(script.Parent.ApolloContext).getApolloContext
local invariant = require(ParentParent.jsutils.invariant).invariant

require(ParentParent.core.ApolloClient)

function ApolloProvider(t1: {[any]: any}) -- line: 29
	-- upvalues: getApolloContext (copy), React (copy), invariant (copy)
	local v7 = getApolloContext()

	return React.createElement(v7.Consumer, nil, function(p1) -- line: 31
		-- upvalues: t1 (copy), invariant (copy), React (copy), v7 (copy)
		if p1 == nil then
			p1 = {}
		end

		if t1.client and p1.client ~= t1.client then
			p1.client = t1.client
		end

		invariant(p1.client, "ApolloProvider was not passed a client instance. Make sure you pass in your client via the \"client\" prop.")

		return React.createElement(v7.Provider, {
			value = p1
		}, t1.children)
	end)
end

return {
	ApolloProvider = ApolloProvider
}
