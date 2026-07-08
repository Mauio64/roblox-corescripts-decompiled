local Parent = script:FindFirstAncestor("AppChat").Parent
local AppCommonLib = require(Parent.AppCommonLib)
local React = require(Parent.React)
local useCallback = React.useCallback
local useReducer = React.useReducer
local Immutable = AppCommonLib.Immutable

local function externalNavigationByScreenReducer(t1: {[any]: any}, t2: {[any]: any}) -- line: 20
	-- upvalues: Immutable (copy)
	if t2.callback == nil then
		return Immutable.RemoveFromDictionary(t1, t2.screen)
	end

	assert(t2.callback ~= nil, "")

	return Immutable.Set(t1, t2.screen, t2.callback)
end

return function() -- line: 29
	-- upvalues: useReducer (copy), externalNavigationByScreenReducer (copy), useCallback (copy)
	local v10, v11 = useReducer(externalNavigationByScreenReducer, {})

	return v10, (useCallback(function(p1: ((...any) -> ...any)?, s1: string) -- line: 31
		-- upvalues: v11 (copy)
		v11({
			callback = p1,
			screen = s1
		})
	end, { v11 }))
end
