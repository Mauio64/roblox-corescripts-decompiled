require("@luauforge/bundled/dCJ")
local React = require("@game/CorePackages/Workspace/Packages/React")
local useDispatch = require("@luauforge/bundled/dCP").Hooks.RoactRodux.useDispatch
require("@luauforge/bundled/dCC")

local function useProcessNavigationStateChange(callback, callback2)
	local v5 = useDispatch()

	return (React.useCallback(function(p2, p3, p4)
		if callback2 then
			callback2(p3)
		end

		v5(callback(p3))
	end, { v5, callback, callback2 }))
end

return useProcessNavigationStateChange
