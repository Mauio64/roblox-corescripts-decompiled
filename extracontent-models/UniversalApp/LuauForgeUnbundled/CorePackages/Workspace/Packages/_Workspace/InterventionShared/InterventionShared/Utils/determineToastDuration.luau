local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/RobloxAppLocales").Localization.new(LocalizationService.RobloxLocaleId)

local v5 = {
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

return function(p2)
	for k, v7 in v5 do
		if v7.threshold <= p2 then
			local v8 = math.ceil(p2 / v7.unit)

			if v8 == 1 then
				return (localization:Format(v7.headingSingle))
			end

			return (localization:Format(v7.headingPlural, { number = v8 }))
		end
	end

	return ""
end
