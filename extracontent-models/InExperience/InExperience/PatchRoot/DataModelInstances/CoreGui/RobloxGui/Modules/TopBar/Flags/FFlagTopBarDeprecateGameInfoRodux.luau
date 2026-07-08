local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)

return game:DefineFastFlag("TopBarDeprecateGameInfoRodux", false) and (FFlagEnableConsoleExpControls and not isNewInGameMenuEnabled)
