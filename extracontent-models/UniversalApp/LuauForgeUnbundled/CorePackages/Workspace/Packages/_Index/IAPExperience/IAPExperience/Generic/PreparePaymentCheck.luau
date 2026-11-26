local UserInputService = game:GetService("UserInputService")
local PaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/PaymentPlatform")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Http").Url
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/AppCommonLib").IsVRAppBuild
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/AppCommonLib").isTenFootInterface
local getBlockingConsolePreparePaymentCheck = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/getBlockingConsolePreparePaymentCheck")
local getIsQuestPlatform = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getIsQuestPlatform")
local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local PreparePaymentCheckCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/PreparePaymentCheckCounter")

local defineFastFlag = game:DefineFastFlag("UsePlaystationPaymentsProtocolCommonFunctions", false)

function LUAUFORGE_MODULE_GLOBALS_baW_GetPaymentMethod(p2): string
	if p2 == Enum.Platform.PS4 then
		return "PlaystationStore"
	end

	if p2 == PaymentPlatform.Maquettes or getIsQuestPlatform() then
		return "QuestStore"
	end

	if p2 == Enum.Platform.XBoxOne then
		return "XboxStore"
	end

	return ""
end

function LUAUFORGE_MODULE_GLOBALS_baW_IsPreparePaymentSuccessful(p2, p3): boolean
	local jsonEncode = HttpService:JSONEncode({
		paymentMethod = p2,
		providerProductId = p3
	})

	local success, result = pcall(function()
		return HttpRbxApiService:PostAsyncFullUrl(
			url.APIS_URL .. "payments-gateway/v1/prepare-payment",
			jsonEncode
		)
	end)

	if not success then
		default:logRobloxTelemetryCounter(PreparePaymentCheckCounter, 1, {
			paymentMethod = p2,
			result = "Error"
		})

		return true
	end

	if HttpService:JSONDecode(result).isSuccess then
		default:logRobloxTelemetryCounter(PreparePaymentCheckCounter, 1, {
			paymentMethod = p2,
			result = "Success"
		})

		return true
	end

	default:logRobloxTelemetryCounter(PreparePaymentCheckCounter, 1, {
		paymentMethod = p2,
		result = "Failed"
	})

	return false
end

function LUAUFORGE_MODULE_GLOBALS_baW_ConsolePreparePaymentCheck(p2)
	local platform = UserInputService:GetPlatform()
	local v5 = LUAUFORGE_MODULE_GLOBALS_baW_GetPaymentMethod(platform)

	if
		defineFastFlag and (platform == Enum.Platform.PS4 or platform == Enum.Platform.PS5)
		or (v5 == "" or platform == Enum.Platform.XBoxOne)
	then
		return true
	end

	return LUAUFORGE_MODULE_GLOBALS_baW_IsPreparePaymentSuccessful(v5, p2)
end

return function(p2)
	if isVRAppBuild() or isTenFootInterface() then
		local v5 = LUAUFORGE_MODULE_GLOBALS_baW_ConsolePreparePaymentCheck(p2)
		return not getBlockingConsolePreparePaymentCheck() or v5
	end

	return true
end
