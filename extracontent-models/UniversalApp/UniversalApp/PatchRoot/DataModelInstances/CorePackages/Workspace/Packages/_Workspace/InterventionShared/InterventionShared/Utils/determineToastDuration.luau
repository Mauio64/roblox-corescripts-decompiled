local Parent = script:FindFirstAncestor("InterventionShared").Parent
local LocalizationService = game:GetService("LocalizationService")
local v3 = require(Parent.RobloxAppLocales).Localization.new(LocalizationService.RobloxLocaleId)
local t1 = {
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

return function(n1: number) -- line: 39
	-- upvalues: t1 (copy), v3 (copy)
	for _, v7 in t1 do
		if n1 >= v7.threshold then
			local v8 = math.ceil(n1 / v7.unit)

			if v8 == 1 then
				return (v3:Format(v7.headingSingle))
			end

			return (v3:Format(v7.headingPlural, {
				number = v8
			}))
		end
	end

	return ""
end
