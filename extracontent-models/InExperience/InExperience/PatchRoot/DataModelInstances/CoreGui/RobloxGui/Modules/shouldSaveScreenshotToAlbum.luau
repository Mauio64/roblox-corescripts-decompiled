local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local GetFFlagScreenshotHudApi = require(RobloxGui.Modules.Flags.GetFFlagScreenshotHudApi)

return function() -- line: 9
	-- upvalues: UserInputService (copy), GetFFlagScreenshotHudApi (copy), CachedPolicyService (copy)
	local Platform = UserInputService:GetPlatform()
	local v8 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android
	local v9 = false

	if GetFFlagScreenshotHudApi() and (v8 and not CachedPolicyService:IsSubjectToChinaPolicies()) then
		v9 = true
	end

	return v9
end
