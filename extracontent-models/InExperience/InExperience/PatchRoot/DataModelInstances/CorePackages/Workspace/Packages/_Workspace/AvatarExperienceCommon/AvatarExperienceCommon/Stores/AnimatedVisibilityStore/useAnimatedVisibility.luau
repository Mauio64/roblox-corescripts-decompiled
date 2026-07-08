local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local AnimatedVisibilityContext = require(script.Parent.AnimatedVisibilityContext)

local function useAnimatedVisibility() -- line: 11
	-- upvalues: React (copy), AnimatedVisibilityContext (copy)
	local v5 = React.useContext(AnimatedVisibilityContext)

	if not v5 then
		warn("useAnimatedVisibility must be used within a AnimatedVisibilityProvider")

		return nil
	end

	return v5
end

return useAnimatedVisibility
