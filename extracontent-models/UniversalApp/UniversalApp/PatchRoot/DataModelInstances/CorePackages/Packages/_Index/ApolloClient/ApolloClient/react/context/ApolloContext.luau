local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local WeakMap = LuauPolyfill.WeakMap

local React = require(parent.React)
require(script.Parent.Parent.Parent.core)

local v = WeakMap.new()
local ApolloContext = {}

function ApolloContext.getApolloContext()
	local apolloContext = v:get(React.createContext)

	if apolloContext == nil then
		apolloContext = React.createContext({})
		apolloContext.displayName = "ApolloContext"
		v:set(React.createContext, apolloContext)
	end

	return apolloContext
end

function ApolloContext.resetApolloContext()
	v = WeakMap.new()
end

return ApolloContext
