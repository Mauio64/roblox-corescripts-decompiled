local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local v4 = require(CorePackages.Workspace.Packages.VirtualEvents).EventsInExperienceApp.createApp()

v4.mountCoreUI(RobloxGui)

return v4
