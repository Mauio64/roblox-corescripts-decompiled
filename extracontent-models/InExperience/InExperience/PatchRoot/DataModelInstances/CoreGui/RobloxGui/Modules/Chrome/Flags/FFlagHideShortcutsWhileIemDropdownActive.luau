local CorePackages = game:GetService("CorePackages")
local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local v3 = require(CorePackages.Workspace.Packages.Chrome).Enabled()

return FFlagEnableConsoleExpControls and v3
