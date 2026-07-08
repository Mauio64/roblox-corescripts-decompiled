local Parent = script:FindFirstAncestor("InExperienceTopBar").Parent
local Enabled = require(Parent.Chrome).Enabled
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode
local CoreGuiCommon = require(Parent.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize
local v10 = game:DefineFastFlag("TopBarSignalizeSetCores", false)
local v11 = game:DefineFastFlag("TopBarRefactor2", false)

return {
	FFlagTopBarSignalizeSetCores = v10,
	FFlagTopBarRefactor = v11 and (Enabled() and (FFlagTopBarSignalizeKeepOutAreas and (FFlagTopBarSignalizeMenuOpen and (FFlagTopBarSignalizeScreenSize and (FFlagEnableConsoleExpControls and not FFlagAddUILessMode)))))
}
