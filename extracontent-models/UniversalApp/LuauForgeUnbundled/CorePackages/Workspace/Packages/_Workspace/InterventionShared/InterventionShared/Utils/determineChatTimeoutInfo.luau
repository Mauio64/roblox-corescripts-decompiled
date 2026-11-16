local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/RobloxAppLocales").Localization.new(LocalizationService.RobloxLocaleId)

local v5 = {
	{
		threshold = 86400,
		headingPlural = "Feature.InExperienceIntervention.Heading.ChatSuspension.Plural",
		headingSingle = "Feature.InExperienceIntervention.Heading.ChatSuspension.1Day",
		descriptionActive = "Feature.InExperienceIntervention.Description.ChatSuspension.Days",
		descriptionActiveFormatFunction = function(p2)
			return (tostring((math.ceil(p2 / 86400))))
		end,
		descriptionExpired = "Feature.InExperienceIntervention.Description.ChatSuspension.Day.Expired",
		unitInSeconds = 86400
	},
	{
		threshold = 3600,
		headingPlural = "Feature.InExperienceIntervention.Heading.ChatSuspension.MultiHour",
		headingSingle = "Feature.InExperienceIntervention.Heading.ChatSuspension.1Hour",
		descriptionActive = "Feature.InExperienceIntervention.Description.ChatSuspension.Hours",
		descriptionActiveFormatFunction = function(p2)
			return DateTime.fromUnixTimestamp(p2):FormatUniversalTime(
				"HH:mm",
				LocalizationService.RobloxLocaleId
			)
		end,
		descriptionExpired = "Feature.InExperienceIntervention.Description.ChatSuspension.Hour.Expired",
		unitInSeconds = 3600
	},
	{
		threshold = 1,
		headingPlural = "Feature.InExperienceIntervention.Heading.ChatSuspension.MultiMinute",
		headingSingle = "Feature.InExperienceIntervention.Heading.ChatSuspension.1Minute",
		descriptionActive = "Feature.InExperienceIntervention.Description.ChatSuspension.Minutes",
		descriptionActiveFormatFunction = function(p2)
			return DateTime.fromUnixTimestamp(p2):FormatUniversalTime(
				"mm:ss",
				LocalizationService.RobloxLocaleId
			)
		end,
		descriptionExpired = "Feature.InExperienceIntervention.Description.ChatSuspension.Minute.Expired",
		unitInSeconds = 60
	}
}

local function fn(p2, p3)
	if p3 then
		return localization:Format("Feature.InExperienceIntervention.Heading.ChatSuspension.Expired")
	end

	for k, v7 in v5 do
		if p2 == v7.unitInSeconds then
			return (localization:Format(v7.headingSingle))
		end

		if v7.threshold < p2 then
			local v8 = math.ceil(p2 / v7.unitInSeconds)
			return (localization:Format(v7.headingPlural, { number = v8 }))
		end
	end

	return ""
end

return function(p2, p3)
	if p2 == nil or p3 == nil then
		return 0, "", ""
	end

	local now = DateTime.now()
	local v6 = math.max(p2.UnixTimestamp - now.UnixTimestamp, 0)
	local v7 = p3 / 1000000000
	local v8 = v6 <= 0

	local v9 = fn(v7, v8)
	local v10 = ""

	for k, v12 in v5 do
		if v8 then
			if v12.threshold <= v7 then
				v10 = localization:Format(v12.descriptionExpired, {
					number = math.ceil(v7 / v12.unitInSeconds)
				})
				break
			end
		elseif v12.threshold <= v6 then
			v10 = localization:Format(v12.descriptionActive, {
				number = v12.descriptionActiveFormatFunction(v6)
			})
			break
		end
	end

	return v6, v9, v10
end
