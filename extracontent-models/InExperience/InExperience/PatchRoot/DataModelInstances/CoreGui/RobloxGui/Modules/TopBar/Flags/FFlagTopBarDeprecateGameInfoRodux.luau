local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)

return game:DefineFastFlag("TopBarDeprecateGameInfoRodux", false)
	and FFlagEnableConsoleExpControls
	and not isNewInGameMenuEnabled
