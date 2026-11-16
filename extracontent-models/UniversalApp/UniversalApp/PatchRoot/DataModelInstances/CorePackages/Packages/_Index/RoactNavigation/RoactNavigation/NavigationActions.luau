local NavigationSymbol = require(script.Parent.NavigationSymbol)

local back = NavigationSymbol("BACK")
local init = NavigationSymbol("INIT")
local navigate = NavigationSymbol("NAVIGATE")
local setParams = NavigationSymbol("SET_PARAMS")

local NavigationActions = { Back = back, Init = init, Navigate = navigate, SetParams = setParams }

setmetatable(NavigationActions, {
	__index = function(_, p)
		error(("%q is not a valid member of NavigationActions"):format((tostring(p))), 2)
	end
})

function NavigationActions.back(options)
	local v = options or {}
	return { type = back, key = v.key, immediate = v.immediate }
end

function NavigationActions.init(options)
	return {
		type = init,
		params = (options or {}).params
	}
end

function NavigationActions.navigate(options)
	local v = options or {}
	return {
		type = navigate,
		routeName = v.routeName,
		params = v.params,
		action = v.action,
		key = v.key
	}
end

function NavigationActions.setParams(options)
	local v = options or {}
	return { type = setParams, preserveFocus = true, key = v.key, params = v.params }
end

return NavigationActions
