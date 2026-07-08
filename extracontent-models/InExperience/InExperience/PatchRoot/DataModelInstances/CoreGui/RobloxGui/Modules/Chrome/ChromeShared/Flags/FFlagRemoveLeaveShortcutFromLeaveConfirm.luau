local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls and game:DefineFastFlag("RemoveLeaveShortcutFromLeaveConfirm", false)
