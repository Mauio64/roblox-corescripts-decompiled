local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

return function(callback)
	local v5 = useDispatch()

	return React.useMemo(function()
		return callback(v5)
	end, { v5, callback })
end
