local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local IXPUtils = require(parent.IXPUtils)

local function unifiedImpressionExposer(p, p2: string)
	return React.useCallback(function(p3)
		local current = p.current

		if current and p3.visibleInstance:IsDescendantOf(current) then
			IXPUtils.logLayerExposure(p2)
		end
	end, { p2 })
end

return unifiedImpressionExposer
