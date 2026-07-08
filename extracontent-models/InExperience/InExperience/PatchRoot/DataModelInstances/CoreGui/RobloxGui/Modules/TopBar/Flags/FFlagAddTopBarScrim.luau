local CorePackages = game:GetService("CorePackages")
local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local v3 = game:DefineFastFlag("AddTopBarScrim", false)

return FFlagEnableConsoleExpControls and v3
