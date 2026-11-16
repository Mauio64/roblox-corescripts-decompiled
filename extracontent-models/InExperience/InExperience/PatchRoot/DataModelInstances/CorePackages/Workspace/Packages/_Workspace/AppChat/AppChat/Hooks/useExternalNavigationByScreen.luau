local parent = script:FindFirstAncestor("AppChat").Parent

local AppCommonLib = require(parent.AppCommonLib)
local React = require(parent.React)

local useCallback = React.useCallback
local useReducer = React.useReducer
local Immutable = AppCommonLib.Immutable

local function externalNavigationByScreenReducer(p, p2)
	if p2.callback == nil then
		return Immutable.RemoveFromDictionary(p, p2.screen)
	end

	assert(p2.callback ~= nil, "")
	return Immutable.Set(p, p2.screen, p2.callback)
end

return function()
	local v, v2 = useReducer(externalNavigationByScreenReducer, {})
	return v, (useCallback(function(callback, screen: string)
		v2({ callback = callback, screen = screen })
	end, { v2 }))
end
