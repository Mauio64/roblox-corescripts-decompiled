local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Tokens = UIBlox.App.Style.Tokens
local Constants = UIBlox.App.Style.Constants
local DeviceType = Constants.DeviceType
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)

return function(p, p2)
	local v

	if TenFootInterface:IsEnabled() then
		v = DeviceType.Console
	else
		v = p or DeviceType.DefaultDeviceType
	end

	return Tokens.getFoundationTokens(v, p2 or Constants.DefaultThemeName)
end
