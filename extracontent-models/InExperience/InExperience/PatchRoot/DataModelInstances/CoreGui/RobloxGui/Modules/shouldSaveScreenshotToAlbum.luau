local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local GetFFlagScreenshotHudApi = require(RobloxGui.Modules.Flags.GetFFlagScreenshotHudApi)

return function()
	local platform = UserInputService:GetPlatform()
	local v = platform == Enum.Platform.IOS or platform == Enum.Platform.Android

	return GetFFlagScreenshotHudApi() and v and not CachedPolicyService:IsSubjectToChinaPolicies() and true or false
end
