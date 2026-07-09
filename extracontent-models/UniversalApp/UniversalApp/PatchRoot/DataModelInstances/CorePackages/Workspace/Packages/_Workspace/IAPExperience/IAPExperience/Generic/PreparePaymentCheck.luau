local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local PaymentPlatform = require(scriptParentParent.Enums.PaymentPlatform)
local Url = require(scriptParentParentParent.Http).Url
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local IsVRAppBuild = require(scriptParentParentParent.AppCommonLib).IsVRAppBuild
local getBlockingConsolePreparePaymentCheck = require(scriptParentParent.Flags.getBlockingConsolePreparePaymentCheck)
local getIsQuestPlatform = require(scriptParentParent.Utility.getIsQuestPlatform)
local default = require(scriptParentParentParent.LoggingProtocol).default
local PreparePaymentCheckCounter = require(scriptParent.Events.PreparePaymentCheckCounter)
local v15 = game:DefineFastFlag("UsePlaystationPaymentsProtocolCommonFunctions", false)
local v16 = game:DefineFastFlag("EnableVRPreparePaymentCheck", false)

function GetPaymentMethod(p1) -- line: 20
	-- upvalues: PaymentPlatform (copy), v16 (copy), getIsQuestPlatform (copy)
	if p1 == Enum.Platform.PS4 then
		return "PlaystationStore"
	end

	if p1 == PaymentPlatform.Maquettes or v16 and getIsQuestPlatform() then
		return "QuestStore"
	end

	if p1 == Enum.Platform.XBoxOne then
		return "XboxStore"
	end

	return ""
end
function IsPreparePaymentSuccessful(s1: string, s2: string) -- line: 31
	-- upvalues: HttpService (copy), HttpRbxApiService (copy), Url (copy), default (copy), PreparePaymentCheckCounter (copy)
	local json = HttpService:JSONEncode({
		paymentMethod = s1,
		providerProductId = s2
	})
	local ok, result = pcall(function() -- line: 38
		-- upvalues: HttpRbxApiService (copy), Url (copy), json (copy)
		return HttpRbxApiService:PostAsyncFullUrl(Url.APIS_URL .. "payments-gateway/v1/prepare-payment", json)
	end)

	if not ok then
		default:logRobloxTelemetryCounter(PreparePaymentCheckCounter, 1, {
			result = "Error",
			paymentMethod = s1
		})

		return true
	end

	if HttpService:JSONDecode(result).isSuccess then
		default:logRobloxTelemetryCounter(PreparePaymentCheckCounter, 1, {
			result = "Success",
			paymentMethod = s1
		})

		return true
	end

	default:logRobloxTelemetryCounter(PreparePaymentCheckCounter, 1, {
		result = "Failed",
		paymentMethod = s1
	})

	return false
end
function ConsolePreparePaymentCheck(s3: string) -- line: 66
	-- upvalues: UserInputService (copy), v15 (copy)
	local Platform = UserInputService:GetPlatform()
	local v25 = GetPaymentMethod(Platform)

	if v15 and (Platform == Enum.Platform.PS4 or Platform == Enum.Platform.PS5) then
		return true
	end

	if v25 == "" or Platform == Enum.Platform.XBoxOne then
		return true
	end

	return IsPreparePaymentSuccessful(v25, s3)
end

return function(s4: string) -- line: 85
	-- upvalues: IsVRAppBuild (copy), GuiService (copy), getBlockingConsolePreparePaymentCheck (copy)
	if IsVRAppBuild() or GuiService:IsTenFootInterface() then
		local v27 = ConsolePreparePaymentCheck(s4)

		if not getBlockingConsolePreparePaymentCheck() then
			v27 = true
		end

		return v27
	end

	return true
end
