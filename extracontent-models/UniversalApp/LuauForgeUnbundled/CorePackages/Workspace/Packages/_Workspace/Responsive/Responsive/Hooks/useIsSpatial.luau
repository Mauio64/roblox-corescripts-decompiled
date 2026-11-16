local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/React")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/AppCommonLib")

local function useIsSpatial()
	local state, setState = React.useState(AppCommonLib.isSpatial)
	React.useEffect(function()
		setState(AppCommonLib.isSpatial())
		local connection = AppCommonLib.connectToIsSpatialChanged(function(p2)
			setState(p2)
		end)
		return function()
			connection:Disconnect()
		end
	end, {})
	return state
end

return useIsSpatial
