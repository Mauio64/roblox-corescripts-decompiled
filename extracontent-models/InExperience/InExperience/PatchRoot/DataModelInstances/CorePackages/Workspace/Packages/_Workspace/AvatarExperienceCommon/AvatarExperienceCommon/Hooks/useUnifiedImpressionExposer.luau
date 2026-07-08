local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local IXPUtils = require(Parent.IXPUtils)

local function unifiedImpressionExposer(t1: {[any]: any}, s1: string) -- line: 7
	-- upvalues: React (copy), IXPUtils (copy)
	return React.useCallback(function(t2: {[any]: any}) -- line: 8
		-- upvalues: t1 (copy), IXPUtils (copy), s1 (copy)
		local current = t1.current

		if current and t2.visibleInstance:IsDescendantOf(current) then
			IXPUtils.logLayerExposure(s1)
		end
	end, { s1 })
end

return unifiedImpressionExposer
