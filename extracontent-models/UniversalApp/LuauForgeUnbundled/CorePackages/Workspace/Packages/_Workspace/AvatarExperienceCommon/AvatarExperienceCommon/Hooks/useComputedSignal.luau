local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

local function useComputedSignal(p2, p3)
	return (React.useMemo(function()
		return Signals.createComputed(p2, p3)
	end, {}))
end

return useComputedSignal
