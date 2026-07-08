local CorePackages = game:GetService("CorePackages")
local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local v3 = game:DefineFastFlag("UnibarMenuOpenSubmenu", false)

return FFlagEnableConsoleExpControls and v3
