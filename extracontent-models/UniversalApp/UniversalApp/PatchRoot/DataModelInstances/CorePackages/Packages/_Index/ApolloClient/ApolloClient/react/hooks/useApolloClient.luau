local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local t1 = {}
local React = require(ParentParentParent.React)
local invariant = require(ParentParent.jsutils.invariant).invariant
local getApolloContext = require(ParentParent.react.context).getApolloContext

require(ParentParent.core)

function useApolloClient() -- line: 21
	-- upvalues: React (copy), getApolloContext (copy), invariant (copy)
	local client = React.useContext(getApolloContext()).client

	invariant(client, "No Apollo Client instance can be found. Please ensure that you have called `ApolloProvider` higher up in your tree.")

	return client
end

t1.useApolloClient = useApolloClient

return t1
