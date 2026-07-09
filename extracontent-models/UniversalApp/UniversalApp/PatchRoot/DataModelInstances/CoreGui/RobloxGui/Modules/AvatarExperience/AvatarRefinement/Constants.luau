local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local v3 = not require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild() and 1 or 1.3
local t1 = {
	LongPressSeconds = 0.25,
	RightMargin = 12,
	Tile = {
		Size = v3 * 50,
		SelectedSize = v3 * 58,
		Padding = v3 * 6,
		ContextWidth = v3 * 42,
		ShownContextWidth = v3 * 33,
		MoreIconSize = v3 * 34,
		ArrowSize = UDim2.fromOffset(28, 22)
	},
	VerticalList = {
		HeightScale = 0.8,
		Padding = 13,
		Width = v3 * 62
	},
	NoItem = {
		TextSize = 12,
		BottomPadding = 0,
		IconSize = 30
	}
}
local t2 = {
	LongPressSeconds = 0.0625,
	RightMargin = 80,
	Tile = {
		Size = 80,
		SelectedSize = 88,
		Padding = 6,
		ContextWidth = 64,
		ShownContextWidth = 51,
		MoreIconSize = 52,
		ArrowSize = UDim2.fromOffset(42, 33)
	},
	VerticalList = {
		Width = 92,
		HeightScale = 0.8,
		Padding = 13
	},
	NoItem = {
		TextSize = 20,
		BottomPadding = -72,
		IconSize = 48
	}
}

return GuiService:IsTenFootInterface() and t2 or t1
