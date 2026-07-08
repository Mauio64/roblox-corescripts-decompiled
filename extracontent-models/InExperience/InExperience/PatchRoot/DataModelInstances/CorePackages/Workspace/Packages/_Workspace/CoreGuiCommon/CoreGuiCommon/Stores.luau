local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local CoreGuiCommonParent = CoreGuiCommon.Parent
local FFlagAddUILessMode = require(CoreGuiCommonParent.SharedFlags).FFlagAddUILessMode
local FFlagTopBarSignalizeMenuOpen = require(CoreGuiCommon.Flags).FFlagTopBarSignalizeMenuOpen
local FFlagTopBarSignalizeKeepOutAreas = require(CoreGuiCommon.Flags).FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeHealthBar = require(CoreGuiCommon.Flags).FFlagTopBarSignalizeHealthBar
local FFlagEnableUISelector = require(CoreGuiCommon.Flags).FFlagEnableUISelector

return {
	GetUILessStore = if not FFlagAddUILessMode then nil else require(script.GetUILessStore),
	GetInspectAndBuyStore = if not FFlagTopBarSignalizeMenuOpen then nil else require(script.GetInspectAndBuyStore),
	GetKeepOutAreasStore = if not FFlagTopBarSignalizeKeepOutAreas then nil else require(script.GetKeepOutAreasStore),
	GetLocalHumanoidStore = if not FFlagTopBarSignalizeHealthBar then nil else require(script.GetLocalHumanoidStore),
	GetUiSelectorSignalStore = if not FFlagEnableUISelector then nil else require(script.GetUiSelectorSignalStore)
}
