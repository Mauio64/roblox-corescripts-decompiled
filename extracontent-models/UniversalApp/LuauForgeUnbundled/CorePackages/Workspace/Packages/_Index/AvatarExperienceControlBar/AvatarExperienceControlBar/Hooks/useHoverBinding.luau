local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")

local function useHoverBinding()
	local v5, v6 = React.useBinding(false)

	return v5, (React.useCallback(function(p2)
		if p2 == Foundation.Enums.ControlState.Default then
			v6(false)
		elseif p2 == Foundation.Enums.ControlState.Hover then
			v6(true)
		end
	end, {}))
end

return useHoverBinding
