local parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function useHoverBinding()
	local v, v2 = React.useBinding(false)

	return v, (React.useCallback(function(p)
		if p == Foundation.Enums.ControlState.Default then
			v2(false)
		elseif p == Foundation.Enums.ControlState.Hover then
			v2(true)
		end
	end, {}))
end

return useHoverBinding
