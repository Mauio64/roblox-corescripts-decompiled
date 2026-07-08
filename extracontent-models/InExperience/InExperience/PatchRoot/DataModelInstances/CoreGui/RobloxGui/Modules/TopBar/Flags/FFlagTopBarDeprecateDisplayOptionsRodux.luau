local CorePackages = game:GetService("CorePackages")
local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local FFlagTopBarDeprecateGamepadNavigationDialogRodux = require(script.Parent.FFlagTopBarDeprecateGamepadNavigationDialogRodux)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

return game:DefineFastFlag("TopBarDeprecateDisplayOptionsRodux2", false) and (Enabled() and (FFlagEnableConsoleExpControls and (FFlagTopBarDeprecateGamepadNavigationDialogRodux and (FFlagTopBarSignalizeMenuOpen and (FFlagTopBarSignalizeKeepOutAreas and FFlagTopBarSignalizeScreenSize)))))
