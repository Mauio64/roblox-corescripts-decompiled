local Parent = script:FindFirstAncestor("AppSystemBar").Parent
local FFlagShrinkAppNavBar = require(Parent.SharedFlags).FFlagShrinkAppNavBar

return {
	TOP_BAR_SIZE = 64,
	GAMEPAD_BOTTOM_BAR_SIZE = 72,
	BOTTOM_BAR_SIZE = not FFlagShrinkAppNavBar and 64 or 52
}
