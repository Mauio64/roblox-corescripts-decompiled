local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local VirtualEvents = require(CorePackages.Workspace.Packages.VirtualEvents)

local app = VirtualEvents.EventsInExperienceApp.createApp()

app.mountCoreUI(RobloxGui)

return app
