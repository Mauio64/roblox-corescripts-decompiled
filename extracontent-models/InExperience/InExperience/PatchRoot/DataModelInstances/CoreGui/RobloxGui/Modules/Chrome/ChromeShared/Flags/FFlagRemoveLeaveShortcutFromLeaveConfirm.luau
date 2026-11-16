local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
return SharedFlags.FFlagEnableConsoleExpControls and game:DefineFastFlag("RemoveLeaveShortcutFromLeaveConfirm", false)
