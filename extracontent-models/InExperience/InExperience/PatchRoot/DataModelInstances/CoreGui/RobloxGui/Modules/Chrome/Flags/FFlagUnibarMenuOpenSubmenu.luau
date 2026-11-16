local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local defineFastFlag = game:DefineFastFlag("UnibarMenuOpenSubmenu", false)

return FFlagEnableConsoleExpControls and defineFastFlag
