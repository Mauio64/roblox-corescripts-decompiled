local parent = script:FindFirstAncestor("AppChat").Parent

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local React = require(parent.React)

return function(callback)
	local v = useDispatch()

	return React.useMemo(function()
		return callback(v)
	end, { v, callback })
end
