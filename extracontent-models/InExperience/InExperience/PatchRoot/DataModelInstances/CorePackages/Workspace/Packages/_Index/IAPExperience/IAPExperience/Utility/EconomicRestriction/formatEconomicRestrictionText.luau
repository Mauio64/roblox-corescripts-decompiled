local IAPExperience = script:FindFirstAncestor("IAPExperience")
local IAPExperienceParent = IAPExperience.Parent
local getEconomicRestrictionLocalizedLabel = require(IAPExperience.Utility.EconomicRestriction.getEconomicRestrictionLocalizedLabel)
local default = require(IAPExperienceParent.LoggingProtocol).default
local EconomicRestrictionsPromptShownCounter = require(IAPExperience.Generic.Events.PurchaseErrorPromptCounter).EconomicRestrictionsPromptShownCounter
local logger = require(IAPExperience.Utility.logger)
local getAppContext = require(IAPExperience.Utility.getAppContext)

return function(t1: {[any]: any}, t2: {[any]: any}, b1: boolean) -- line: 14
	-- upvalues: default (copy), EconomicRestrictionsPromptShownCounter (copy), getAppContext (copy), logger (copy), getEconomicRestrictionLocalizedLabel (copy)
	local v11 = t2.timeoutMinutes or (t2.expirationTimeInMinutes or t2.ExpirationTimeInMinutes)
	local v12 = t2.violationType or (t2.failureReason or t2.FailureReason)

	default:logRobloxTelemetryCounter(EconomicRestrictionsPromptShownCounter, 1, {
		violationType = tostring(v12),
		appContext = getAppContext()
	})

	if not v11 or not v12 then
		logger.error({
			error = "Timeout and violationType is required for economic restriction text. Showing unknown error.",
			timeoutMinutes = v11,
			violationType = v12
		})

		return t1.unknownText
	end

	local v13 = getEconomicRestrictionLocalizedLabel(t1, v12)
	local v14 = math.ceil(v11 / 60)

	if v14 >= 24 then
		local v15 = math.ceil(v14 / 24)

		return ((if not b1 then t1.economicRestrictionBaseTextDays else t1.economicRestrictionBaseTextDaysGeneral)):gsub("{day}", (tostring(v15))):gsub("{violation}", v13)
	end

	return ((if not b1 then t1.economicRestrictionBaseTextHours else t1.economicRestrictionBaseTextHoursGeneral)):gsub("{hour}", (tostring(v14))):gsub("{violation}", v13)
end
