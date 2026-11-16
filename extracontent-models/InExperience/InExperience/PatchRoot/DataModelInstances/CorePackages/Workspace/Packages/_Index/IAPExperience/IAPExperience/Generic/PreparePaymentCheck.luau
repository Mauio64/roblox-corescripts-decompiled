local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local UserInputService = game:GetService("UserInputService")
local PaymentPlatform = require(parent2.Enums.PaymentPlatform)
local Http = require(parent3.Http)
local Url = Http.Url
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local AppCommonLib = require(parent3.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local AppCommonLib2 = require(parent3.AppCommonLib)
local isTenFootInterface = AppCommonLib2.isTenFootInterface
local getBlockingConsolePreparePaymentCheck = require(parent2.Flags.getBlockingConsolePreparePaymentCheck)
local getIsQuestPlatform = require(parent2.Utility.getIsQuestPlatform)
local LoggingProtocol = require(parent3.LoggingProtocol)
local default = LoggingProtocol.default
local PreparePaymentCheckCounter = require(parent.Events.PreparePaymentCheckCounter)

local defineFastFlag = game:DefineFastFlag("UsePlaystationPaymentsProtocolCommonFunctions", false)

function GetPaymentMethod(p): string
	if p == Enum.Platform.PS4 then
		return "PlaystationStore"
	end

	if p == PaymentPlatform.Maquettes or getIsQuestPlatform() then
		return "QuestStore"
	end

	return if p == Enum.Platform.XBoxOne then "XboxStore" else ""
end

function IsPreparePaymentSuccessful(paymentMethod: string, providerProductId: string): boolean
	local jsonEncode = HttpService:JSONEncode({
		paymentMethod = paymentMethod,
		providerProductId = providerProductId
	})

	local success, result = pcall(function()
		return HttpRbxApiService:PostAsyncFullUrl(Url.APIS_URL .. "payments-gateway/v1/prepare-payment", jsonEncode)
	end)

	if not success then
		default:logRobloxTelemetryCounter(PreparePaymentCheckCounter, 1, {
			paymentMethod = paymentMethod,
			result = "Error"
		})

		return true
	end

	if HttpService:JSONDecode(result).isSuccess then
		default:logRobloxTelemetryCounter(PreparePaymentCheckCounter, 1, {
			paymentMethod = paymentMethod,
			result = "Success"
		})

		return true
	end

	default:logRobloxTelemetryCounter(PreparePaymentCheckCounter, 1, {
		paymentMethod = paymentMethod,
		result = "Failed"
	})

	return false
end

function ConsolePreparePaymentCheck(p: string)
	local platform = UserInputService:GetPlatform()
	local v = GetPaymentMethod(platform)

	if
		defineFastFlag and (platform == Enum.Platform.PS4 or platform == Enum.Platform.PS5)
		or (v == "" or platform == Enum.Platform.XBoxOne)
	then
		return true
	end

	return IsPreparePaymentSuccessful(v, p)
end

return function(p: string)
	if IsVRAppBuild() or isTenFootInterface() then
		local v = ConsolePreparePaymentCheck(p)
		return not getBlockingConsolePreparePaymentCheck() or v
	end

	return true
end
