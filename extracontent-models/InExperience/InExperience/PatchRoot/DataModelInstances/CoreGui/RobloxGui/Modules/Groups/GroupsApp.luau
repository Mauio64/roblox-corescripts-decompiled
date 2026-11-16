local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Groups = require(CorePackages.Workspace.Packages.Groups)

local app = Groups.GroupsInExperienceApp.createApp()

app.mountCoreUI(RobloxGui)

return app
