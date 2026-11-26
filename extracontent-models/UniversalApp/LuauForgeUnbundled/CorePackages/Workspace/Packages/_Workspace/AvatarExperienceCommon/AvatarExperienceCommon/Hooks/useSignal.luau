local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

local function useSignal(p2, p3)
	local v5, v6 = React.useMemo(function()
		return Signals.createSignal(p2, p3)
	end, {})
	return v5, v6
end

return useSignal
