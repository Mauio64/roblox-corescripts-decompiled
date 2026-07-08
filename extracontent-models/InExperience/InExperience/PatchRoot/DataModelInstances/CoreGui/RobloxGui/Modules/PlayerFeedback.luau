local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local v3 = require(CorePackages.Workspace.Packages.CoreScriptsPlayerFeedback).createApp()

v3.instance.Parent = RobloxGui

return v3
