local Parent = script:FindFirstAncestor("TenFootUiCommon").Parent

require(Parent.React)
require(Parent.Navigation)

local t1 = {
	ShowAll = "ShowAll",
	TabGroupOnly = "TabGroupOnly",
	OptionGroupOnly = "OptionGroupOnly",
	HideAll = "HideAll"
}

return {
	ScreenKind = {
		Default = "Default",
		FullScreen = "FullScreen"
	},
	GlobalNavDisplayOption = t1
}
