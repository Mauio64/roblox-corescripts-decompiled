local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local useCallback = React.useCallback
local useReducer = React.useReducer
local immutable = AppCommonLib.Immutable

local function externalNavigationByScreenReducer(p2, p3)
	if p3.callback == nil then
		return immutable.RemoveFromDictionary(p2, p3.screen)
	end

	assert(p3.callback ~= nil, "")
	return immutable.Set(p2, p3.screen, p3.callback)
end

return function()
	local v5, v6 = useReducer(externalNavigationByScreenReducer, {})
	return v5, (useCallback(function(p2, p3)
		v6({ callback = p2, screen = p3 })
	end, { v6 }))
end
