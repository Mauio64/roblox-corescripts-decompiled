local ReactUtils = script:FindFirstAncestor("ReactUtils")

local React = require(ReactUtils.Parent.React)
local useRefToState = require(ReactUtils.useRefToState)

local function useEventCallback(callback)
	local v = useRefToState(callback)
	return React.useCallback(function(...)
		return v.current(...)
	end, {})
end

return useEventCallback
