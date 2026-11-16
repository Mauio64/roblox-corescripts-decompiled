local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local parent = CoreGuiCommon.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode
local Flags = require(CoreGuiCommon.Flags)
local FFlagTopBarSignalizeMenuOpen = Flags.FFlagTopBarSignalizeMenuOpen
local Flags2 = require(CoreGuiCommon.Flags)
local FFlagTopBarSignalizeKeepOutAreas = Flags2.FFlagTopBarSignalizeKeepOutAreas
local Flags3 = require(CoreGuiCommon.Flags)
local FFlagTopBarSignalizeHealthBar = Flags3.FFlagTopBarSignalizeHealthBar
local Flags4 = require(CoreGuiCommon.Flags)
local FFlagEnableUISelector = Flags4.FFlagEnableUISelector
local getUILessStore

if FFlagAddUILessMode then
	getUILessStore = require(script.GetUILessStore)
end

local getInspectAndBuyStore

if FFlagTopBarSignalizeMenuOpen then
	getInspectAndBuyStore = require(script.GetInspectAndBuyStore)
end

local getKeepOutAreasStore

if FFlagTopBarSignalizeKeepOutAreas then
	getKeepOutAreasStore = require(script.GetKeepOutAreasStore)
end

local getLocalHumanoidStore

if FFlagTopBarSignalizeHealthBar then
	getLocalHumanoidStore = require(script.GetLocalHumanoidStore)
end

local getUiSelectorSignalStore

if FFlagEnableUISelector then
	getUiSelectorSignalStore = require(script.GetUiSelectorSignalStore)
end

return {
	GetUILessStore = getUILessStore,
	GetInspectAndBuyStore = getInspectAndBuyStore,
	GetKeepOutAreasStore = getKeepOutAreasStore,
	GetLocalHumanoidStore = getLocalHumanoidStore,
	GetUiSelectorSignalStore = getUiSelectorSignalStore
}
