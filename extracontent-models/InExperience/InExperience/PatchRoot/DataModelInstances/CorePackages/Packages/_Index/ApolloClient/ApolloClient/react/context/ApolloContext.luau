local ParentParent = script.Parent.Parent.Parent.Parent
local WeakMap = require(ParentParent.LuauPolyfill).WeakMap
local React = require(ParentParent.React)

require(script.Parent.Parent.Parent.core)

local u4 = WeakMap.new()

return {
	getApolloContext = function() -- line: 33
		-- upvalues: u4 (ref), React (copy)
		local v5 = u4:get(React.createContext)

		if v5 == nil then
			v5 = React.createContext({})
			v5.displayName = "ApolloContext"
			u4:set(React.createContext, v5)
		end

		return v5
	end,
	resetApolloContext = function() -- line: 45
		-- upvalues: u4 (ref), WeakMap (copy)
		u4 = WeakMap.new()
	end
}
