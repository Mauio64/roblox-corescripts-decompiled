local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local IXPUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/IXPUtils")

local function unifiedImpressionExposer(p2, p3)
	return React.useCallback(function(p4)
		local current = p2.current

		if current and p4.visibleInstance:IsDescendantOf(current) then
			IXPUtils.logLayerExposure(p3)
		end
	end, { p3 })
end

return unifiedImpressionExposer
