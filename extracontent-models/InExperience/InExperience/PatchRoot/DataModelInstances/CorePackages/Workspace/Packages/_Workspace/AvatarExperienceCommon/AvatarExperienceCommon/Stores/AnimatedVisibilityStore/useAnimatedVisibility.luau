local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)

local AnimatedVisibilityContext = require(script.Parent.AnimatedVisibilityContext)

local function useAnimatedVisibility()
	local v = React.useContext(AnimatedVisibilityContext)

	if v then
		return v
	end

	warn("useAnimatedVisibility must be used within a AnimatedVisibilityProvider")
	return nil
end

return useAnimatedVisibility
