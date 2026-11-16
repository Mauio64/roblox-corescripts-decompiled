local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local Drawer = require(InExperienceSideSheet.Parent.Drawer)
local Constants = Drawer.Constants

return function()
	return Constants.DRAWER_ANIM_SETTINGS.duration
end
