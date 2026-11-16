local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Stores/GetInspectAvatarTooltipStore")(false)

local function useInspectAvatarTooltip()
	local v6 = useSignalState(v5.getIsOpen)

	React.useEffect(function()
		v5.tryShow()

		return function()
			v5.hide()
		end
	end, {})

	return { showTooltip = v6, onDismiss = v5.permanentlyDismiss }
end

return useInspectAvatarTooltip
