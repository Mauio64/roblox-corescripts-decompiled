local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Tokens = UIBlox.App.Style.Tokens
local Constants = UIBlox.App.Style.Constants
local DeviceType = Constants.DeviceType
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)

return function(p1, p2) -- line: 11
	-- upvalues: TenFootInterface (copy), DeviceType (copy), Tokens (copy), Constants (copy)
	local v10 = if not TenFootInterface:IsEnabled() then p1 or DeviceType.DefaultDeviceType else DeviceType.Console

	return Tokens.getFoundationTokens(v10, p2 or Constants.DefaultThemeName)
end
