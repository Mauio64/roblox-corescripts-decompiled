local Parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

local function useHoverBinding() -- line: 7
	-- upvalues: React (copy), Foundation (copy)
	local v5, v6 = React.useBinding(false)

	return v5, (React.useCallback(function(p1) -- line: 11
		-- upvalues: Foundation (copy), v6 (copy)
		if p1 == Foundation.Enums.ControlState.Default then
			v6(false)

			return
		end

		if p1 == Foundation.Enums.ControlState.Hover then
			v6(true)
		end
	end, {}))
end

return useHoverBinding
