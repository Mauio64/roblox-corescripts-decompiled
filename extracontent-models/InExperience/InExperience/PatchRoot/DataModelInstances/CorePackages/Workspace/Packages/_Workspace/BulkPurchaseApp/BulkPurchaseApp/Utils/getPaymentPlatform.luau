local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local PaymentPlatformEnum = require(BulkPurchaseApp.Enums.PaymentPlatformEnum)

local function getPaymentPlatform()
	local platform = UserInputService:GetPlatform()

	if platform == Enum.Platform.Windows or platform == Enum.Platform.OSX or platform == Enum.Platform.Linux then
		return PaymentPlatformEnum.Desktop
	end

	if platform == Enum.Platform.IOS or platform == Enum.Platform.Android or platform == Enum.Platform.UWP then
		return PaymentPlatformEnum.Mobile
	end

	if
		platform == Enum.Platform.XBoxOne
		or platform == Enum.Platform.XBox360
		or platform == Enum.Platform.PS3
		or platform == Enum.Platform.PS4
		or platform == Enum.Platform.PS5
	then
		return PaymentPlatformEnum.Console
	end

	if VRService:IsVRAppBuild() then
		return PaymentPlatformEnum.VR
	end

	return PaymentPlatformEnum.Unknown
end

return getPaymentPlatform
