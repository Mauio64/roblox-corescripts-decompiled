local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled

return game:DefineFastFlag("TopBarDeprecateRespawnRodux2", false) and FFlagEnableConsoleExpControls and Enabled()
