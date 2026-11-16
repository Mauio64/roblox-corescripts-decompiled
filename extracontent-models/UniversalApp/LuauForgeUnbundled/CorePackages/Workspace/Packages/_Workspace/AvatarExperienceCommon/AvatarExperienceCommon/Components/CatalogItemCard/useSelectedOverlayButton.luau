local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Responsive")

local useTokens = Foundation.Hooks.useTokens

local function useSelectedOverlayButton(p2)
	local v5 = useTokens()
	local v6 = Responsive.useLastInput()
	local v7 = Responsive.useIsSpatial()

	local v8 = v6 == Responsive.Input.Directional and not v7

	return {
		isVisible = p2 and not v8,
		height = v5.Size.Size_700,
		bottomOffset = v5.Gap.XXSmall,
		occupiedHeight = v5.Size.Size_700 + v5.Gap.XXSmall
	}
end

return useSelectedOverlayButton
