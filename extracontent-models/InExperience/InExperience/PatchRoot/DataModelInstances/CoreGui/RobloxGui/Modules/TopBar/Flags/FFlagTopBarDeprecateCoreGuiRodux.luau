local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar

return game:DefineFastFlag("TopBarDeprecateCoreGuiRodux2", false)
	and FFlagTopBarSignalizeHealthBar
	and FFlagEnableConsoleExpControls
	and Enabled()
