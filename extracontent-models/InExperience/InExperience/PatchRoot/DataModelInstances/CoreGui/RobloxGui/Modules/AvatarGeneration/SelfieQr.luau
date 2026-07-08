local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local v4 = require(CorePackages.Workspace.Packages.SelfieQr).SelfieQRFactory.createFactory()

v4.mountCoreUI(RobloxGui)

return v4
