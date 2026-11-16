local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local CoreScriptsPlayerFeedback = require(CorePackages.Workspace.Packages.CoreScriptsPlayerFeedback)

local app = CoreScriptsPlayerFeedback.createApp()
app.instance.Parent = RobloxGui

return app
