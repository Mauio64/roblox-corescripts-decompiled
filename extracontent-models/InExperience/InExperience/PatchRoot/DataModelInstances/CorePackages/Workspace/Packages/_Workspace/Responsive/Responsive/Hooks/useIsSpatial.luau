local parent = script:FindFirstAncestor("Responsive").Parent
local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)

local function useIsSpatial()
	local state, setState = React.useState(AppCommonLib.isSpatial)
	React.useEffect(function()
		setState(AppCommonLib.isSpatial())
		local connection = AppCommonLib.connectToIsSpatialChanged(function(flag: boolean)
			setState(flag)
		end)
		return function()
			connection:Disconnect()
		end
	end, {})
	return state
end

return useIsSpatial
