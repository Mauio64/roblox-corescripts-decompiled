local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")

local function useTopBar(p2)
	local v5 = GetTopBarStore(false)

	return {
		setScreenTopBar = React.useCallback(function(p3)
			v5.setScreenTopBar(p2, p3)
		end, { p2 }),
		clearScreenTopBar = React.useCallback(function()
			v5.clearScreenTopBar(p2)
		end, { p2 })
	}
end

return useTopBar
