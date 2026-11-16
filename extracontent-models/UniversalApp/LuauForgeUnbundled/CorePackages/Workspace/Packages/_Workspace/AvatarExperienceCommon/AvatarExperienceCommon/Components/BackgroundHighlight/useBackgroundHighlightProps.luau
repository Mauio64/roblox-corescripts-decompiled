local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/BackgroundHighlight/BackgroundHighlight")

local useTokens = Foundation.Hooks.useTokens

return function(p2)
	local surface_100 = useTokens().Color.Surface.Surface_100

	return {
		ZIndex = p2.ZIndex or 0,
		highlightColor = surface_100
	}
end
