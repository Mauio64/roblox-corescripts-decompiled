local fFlagAddUILessMode = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/SharedFlags").FFlagAddUILessMode
local fFlagTopBarSignalizeMenuOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Flags").FFlagTopBarSignalizeMenuOpen
local fFlagTopBarSignalizeKeepOutAreas = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Flags").FFlagTopBarSignalizeKeepOutAreas
local fFlagTopBarSignalizeHealthBar = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Flags").FFlagTopBarSignalizeHealthBar
local fFlagEnableUISelector = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Flags").FFlagEnableUISelector

local v6 = if fFlagAddUILessMode then require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores/GetUILessStore") else nil

local v7 = if fFlagTopBarSignalizeMenuOpen then require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores/GetInspectAndBuyStore") else nil

local v8 = if fFlagTopBarSignalizeKeepOutAreas then require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores/GetKeepOutAreasStore") else nil

local v9 = if fFlagTopBarSignalizeHealthBar then require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores/GetLocalHumanoidStore") else nil

local v10 = if fFlagEnableUISelector then require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores/GetUiSelectorSignalStore") else nil
return {
	GetUILessStore = v6,
	GetInspectAndBuyStore = v7,
	GetKeepOutAreasStore = v8,
	GetLocalHumanoidStore = v9,
	GetUiSelectorSignalStore = v10
}
