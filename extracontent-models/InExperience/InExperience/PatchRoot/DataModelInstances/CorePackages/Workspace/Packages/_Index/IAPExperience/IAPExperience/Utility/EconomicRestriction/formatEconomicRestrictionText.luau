local IAPExperience = script:FindFirstAncestor("IAPExperience")
local parent = IAPExperience.Parent

local getEconomicRestrictionLocalizedLabel = require(IAPExperience.Utility.EconomicRestriction.getEconomicRestrictionLocalizedLabel)
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local PurchaseErrorPromptCounter = require(IAPExperience.Generic.Events.PurchaseErrorPromptCounter)
local EconomicRestrictionsPromptShownCounter = PurchaseErrorPromptCounter.EconomicRestrictionsPromptShownCounter
local logger = require(IAPExperience.Utility.logger)
local getAppContext = require(IAPExperience.Utility.getAppContext)

return function(data, data2, flag: boolean)
	local timeoutMinutes = data2.timeoutMinutes or data2.expirationTimeInMinutes or data2.ExpirationTimeInMinutes
	local violationType = data2.violationType or data2.failureReason or data2.FailureReason
	default:logRobloxTelemetryCounter(EconomicRestrictionsPromptShownCounter, 1, {
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

	local economicRestrictionLocalizedLabel = getEconomicRestrictionLocalizedLabel(data, violationType)
	local v = math.ceil(timeoutMinutes / 60)

	if v >= 24 then
		local v2 = math.ceil(v / 24)
		local v3

		if flag then
			v3 = data.economicRestrictionBaseTextDaysGeneral
		else
			v3 = data.economicRestrictionBaseTextDays
		end

		return v3:gsub("{day}", (tostring(v2))):gsub("{violation}", economicRestrictionLocalizedLabel)
	else
		local v2

		if flag then
			v2 = data.economicRestrictionBaseTextHoursGeneral
		else
			v2 = data.economicRestrictionBaseTextHours
		end

		return v2:gsub("{hour}", (tostring(v))):gsub("{violation}", economicRestrictionLocalizedLabel)
	end
end
