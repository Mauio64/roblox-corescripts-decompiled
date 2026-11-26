local useStatusBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/RobloxAppHooks").useStatusBarHeight

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/OutfitDetails/TopBar/OutfitDetailsTopBar")

local function useOutfitDetailsTopBarProps(p2)
	return {
		statusBarHeight = useStatusBarHeight(),
		LayoutOrder = p2.LayoutOrder,
		onClose = p2.onClose
	}
end

return useOutfitDetailsTopBarProps
