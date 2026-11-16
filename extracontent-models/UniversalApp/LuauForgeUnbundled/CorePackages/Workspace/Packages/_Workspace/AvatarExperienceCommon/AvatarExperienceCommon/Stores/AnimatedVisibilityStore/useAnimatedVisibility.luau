local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local AnimatedVisibilityContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AnimatedVisibilityStore/AnimatedVisibilityContext")

local function useAnimatedVisibility()
	local v5 = React.useContext(AnimatedVisibilityContext)

	if v5 then
		return v5
	end

	warn("useAnimatedVisibility must be used within a AnimatedVisibilityProvider")
	return nil
end

return useAnimatedVisibility
