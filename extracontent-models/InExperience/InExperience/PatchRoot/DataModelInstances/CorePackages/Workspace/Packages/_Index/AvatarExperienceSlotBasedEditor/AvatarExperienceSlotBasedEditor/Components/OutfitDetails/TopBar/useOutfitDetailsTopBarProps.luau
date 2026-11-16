local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useStatusBarHeight = RobloxAppHooks.useStatusBarHeight

require(script.Parent.OutfitDetailsTopBar)

local function useOutfitDetailsTopBarProps(p)
	return {
		statusBarHeight = useStatusBarHeight(),
		LayoutOrder = p.LayoutOrder,
		onClose = p.onClose
	}
end

return useOutfitDetailsTopBarProps
