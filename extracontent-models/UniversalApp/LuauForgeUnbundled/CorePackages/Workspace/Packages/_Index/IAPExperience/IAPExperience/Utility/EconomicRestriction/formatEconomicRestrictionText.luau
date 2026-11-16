local getEconomicRestrictionLocalizedLabel = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/getEconomicRestrictionLocalizedLabel")
local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local economicRestrictionsPromptShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/PurchaseErrorPromptCounter").EconomicRestrictionsPromptShownCounter
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

return function(data, data2, p2)
	local timeoutMinutes = data2.timeoutMinutes
		or data2.expirationTimeInMinutes
		or data2.ExpirationTimeInMinutes
	local violationType = data2.violationType or data2.failureReason or data2.FailureReason
	default:logRobloxTelemetryCounter(economicRestrictionsPromptShownCounter, 1, {
		violationType = tostring(violationType),
		appContext = getAppContext()
	})

	if not (timeoutMinutes and violationType) then
		logger.error({
			error = "Timeout and violationType is required for economic restriction text. Showing unknown error.",
			timeoutMinutes = timeoutMinutes,
			violationType = violationType
		})

		return data.unknownText
	end

	local v5 = getEconomicRestrictionLocalizedLabel(data, violationType)
	local v6 = math.ceil(timeoutMinutes / 60)

	if v6 >= 24 then
		local v7 = math.ceil(v6 / 24)
		local v8

		if p2 then
			v8 = data.economicRestrictionBaseTextDaysGeneral
		else
			v8 = data.economicRestrictionBaseTextDays
		end

		return v8:gsub("{day}", (tostring(v7))):gsub("{violation}", v5)
	else
		local v7

		if p2 then
			v7 = data.economicRestrictionBaseTextHoursGeneral
		else
			v7 = data.economicRestrictionBaseTextHours
		end

		return v7:gsub("{hour}", (tostring(v6))):gsub("{violation}", v5)
	end
end
