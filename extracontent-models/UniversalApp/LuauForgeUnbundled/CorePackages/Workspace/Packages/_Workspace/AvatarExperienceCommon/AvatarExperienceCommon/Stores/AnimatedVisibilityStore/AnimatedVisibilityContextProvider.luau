local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local createAnimatedVisibilityStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AnimatedVisibilityStore/createAnimatedVisibilityStore")
local AnimatedVisibilityContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AnimatedVisibilityStore/AnimatedVisibilityContext")

local function AnimatedVisibilityProvider(p2)
	local v5 = React.useMemo(function()
		return createAnimatedVisibilityStore(p2.initialRatio)
	end, {})

	React.useEffect(function()
		return function()
			v5.destroy()
		end
	end, { v5 })

	return React.createElement(AnimatedVisibilityContext.Provider, {
		value = { animatedMenusStore = v5 }
	}, p2.children)
end

return AnimatedVisibilityProvider
