local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()

return FFlagEnableConsoleExpControls and enabled
