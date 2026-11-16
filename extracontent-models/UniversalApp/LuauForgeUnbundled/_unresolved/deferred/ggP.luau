local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface

local v5 = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild() and 1.3 or 1

local v6 = {
	Tile = {
		Size = v5 * 50,
		SelectedSize = v5 * 58,
		Padding = v5 * 6,
		ContextWidth = v5 * 42,
		ShownContextWidth = v5 * 33,
		MoreIconSize = v5 * 34,
		ArrowSize = UDim2.fromOffset(28, 22)
	},
	VerticalList = {
		Width = v5 * 62,
		HeightScale = 0.8,
		Padding = 13
	},
	NoItem = { TextSize = 12, BottomPadding = 0, IconSize = 30 },
	LongPressSeconds = 0.25,
	RightMargin = 12
}

local v7 = {
	Tile = {
		Size = 80,
		SelectedSize = 88,
		Padding = 6,
		ContextWidth = 64,
		ShownContextWidth = 51,
		MoreIconSize = 52,
		ArrowSize = UDim2.fromOffset(42, 33)
	},
	VerticalList = { Width = 92, HeightScale = 0.8, Padding = 13 },
	NoItem = { TextSize = 20, BottomPadding = -72, IconSize = 48 },
	LongPressSeconds = 0.0625,
	RightMargin = 80
}

return isTenFootInterface() and v7 or v6
