local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local PaymentPlatformEnum = require(BulkPurchaseApp.Enums.PaymentPlatformEnum)

local function getPaymentPlatform() -- line: 9
	-- upvalues: UserInputService (copy), PaymentPlatformEnum (copy), VRService (copy)
	local Platform = UserInputService:GetPlatform()

	if Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.Linux) then
		return PaymentPlatformEnum.Desktop
	end

	if Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android or Platform == Enum.Platform.UWP then
		return PaymentPlatformEnum.Mobile
	end

	if Platform == Enum.Platform.XBoxOne or Platform == Enum.Platform.XBox360 or Platform == Enum.Platform.PS3 or Platform == Enum.Platform.PS4 or Platform == Enum.Platform.PS5 then
		return PaymentPlatformEnum.Console
	end

	if VRService:IsVRAppBuild() then
		return PaymentPlatformEnum.VR
	end

	return PaymentPlatformEnum.Unknown
end

return getPaymentPlatform
