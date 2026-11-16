local parent = script:FindFirstAncestor("AppSystemBar").Parent
local SharedFlags = require(parent.SharedFlags)
return {
	TOP_BAR_SIZE = 64,
	BOTTOM_BAR_SIZE = SharedFlags.FFlagShrinkAppNavBar and 52 or 64,
	GAMEPAD_BOTTOM_BAR_SIZE = 72
}
