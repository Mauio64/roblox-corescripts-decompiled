local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local useStatusBarHeight = require(Parent.RobloxAppHooks).useStatusBarHeight

require(script.Parent.OutfitDetailsTopBar)

local function useOutfitDetailsTopBarProps(t1: {[any]: any}) -- line: 14
	-- upvalues: useStatusBarHeight (copy)
	return {
		statusBarHeight = useStatusBarHeight(),
		LayoutOrder = t1.LayoutOrder,
		onClose = t1.onClose
	}
end

return useOutfitDetailsTopBarProps
