local parent = script:FindFirstAncestor("InterventionShared").Parent

local LocalizationService = game:GetService("LocalizationService")
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization.new(LocalizationService.RobloxLocaleId)

local v = {
	{
		threshold = 1380,
		unit = 1440,
		headingPlural = "Feature.InExperienceIntervention.Description.CannotSendDays",
		headingSingle = "Feature.InExperienceIntervention.Description.CannotSend1Day"
	},
	{
		threshold = 59,
		unit = 60,
		headingPlural = "Feature.InExperienceIntervention.Description.CannotSendHours",
		headingSingle = "Feature.InExperienceIntervention.Description.CannotSend1Hour"
	},
	{
		threshold = 1,
		unit = 1,
		headingPlural = "Feature.InExperienceIntervention.Description.CannotSend",
		headingSingle = "Feature.InExperienceIntervention.Description.CannotSend1Min"
	}
}

return function(p: number)
	for _, v2 in v do
		if v2.threshold <= p then
			local number = math.ceil(p / v2.unit)

			if number == 1 then
				return (localization:Format(v2.headingSingle))
			end

			return (localization:Format(v2.headingPlural, { number = number }))
		end
	end

	return ""
end
